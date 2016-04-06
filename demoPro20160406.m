% 使用说明： 1. 设置参数multibeamMode值，确定求解多波束检测概率还是单天线检测概率；
%           2.  选择所求天线或者波束的目录，如文件夹 h700_t10_v500_b2_e20

close all;
clc;

global multibeamMode beamNum
multibeamMode = 0;  %   值为1表示多波束模式，值为0表示单天线模式
% beamNum = 2;

%   根据模拟源数据文件夹的名字中的字母e判断是否打开正确的文件夹，同时根据名字中波束个数求解该多波束的波束个数beamNum
%   根据解调算法的写法，demodResult_1ant在模拟源文件夹内部。

datadirName = uigetdir('E:\My shirmey\lab1017\houjincheng20160117\lab1017\AISSig_s\','选择模拟源数据文件夹……');

%   防止打开错误文件路径，单天线和多波束解调打开文件路径相同
if(strcmp(datadirName(length(datadirName)-2), 'e')==0)
    error('文件夹路径有误');
end
resdirName = [datadirName, '\demodResult_1ant\'];
% 读取卫星高度、船舶数量、观测时间的字符串
posMatr = regexpi(datadirName, '\','end');   %   查找符号\所在位置
posNum = posMatr(1,end);    %   找到符号\最后出现的位置
fileStr = datadirName((posNum+1):length(datadirName)); %   读取所求检测概率文件的文件名
strh = 'h';
strt = '_t';
strv = '_v';
stre = '_e';
[hStartStr, hEndStr] = regexpi(fileStr, strh, 'start','end');
[tStartStr, tEndStr] = regexpi(fileStr, strt, 'start','end');
[vStartStr, vEndStr] = regexpi(fileStr, strv, 'start','end');
[eStartStr, eEndStr] = regexpi(fileStr, stre, 'start','end');
heightStr = fileStr(hEndStr+1: tStartStr-1);
timeStr = fileStr(tEndStr+1: vStartStr-1);
% 多波束模式
if(multibeamMode == 1)
    strb = '_b';
    [bStartStr, bEndStr] = regexpi(fileStr, strb, 'start','end');
    vesStr = fileStr(vEndStr+1: bStartStr-1);
    beamStr = fileStr(bEndStr+1: eStartStr-1);
    beamNum = str2double(beamStr);
else
    vesStr = fileStr(vEndStr+1: eStartStr-1);
end

%%  所有点波束的data去重
%   遍历所有data文件，将文件名保存到变量datafileName中
dataFile = dir(datadirName);    %   遍历data文件目录下的所有文件
datafileNum = 1;
for ii = 1:1:length(dataFile)
    if dataFile(ii).isdir == 0 && ~strcmp(dataFile(ii).name, '.')...
            && ~strcmp(dataFile(ii).name, '..')...
            && strcmp(dataFile(ii).name(1:1:7), 'AISData')
        datafileName{datafileNum} = dataFile(ii).name;
        datafileNum = datafileNum+1;
    end
end
datafileName(datafileNum : end) = [];
datafileNum = datafileNum - 1;

%   读取datafileName中的数据，保存到矩阵beamData中
beamData_cell = cell(1, beamNum);
for ii = 1 : 1 : datafileNum
    name = datafileName{ii};
    %   加载data数据信息   
    try
        load([datadirName, '\', name]);
    catch
        disp([name, '读取错误']);
        continue;
    end
    if(multibeamMode == 1)
        aisData = aisDataBeam;    %   多波束解调使用代码
        beamData_cell{ii} = aisData;
    else
        beamData_cell{ii} = aisData;
    end
    %   将细胞元素转成矩阵格式 矩阵1用beamData1表示，矩阵2用beamData2表示
    if ii == 1
        beamData1 = beamData_cell{ii};
    else
        beamData2 = beamData_cell{ii};
        beamData1 = cat(1, beamData1, beamData2);
    end 
end
beamData = beamData1;                       %   未去重的所有点波束的data数据
beamData_new = unique(beamData, 'rows');    %   去重后的所有点波束的data数据


%%  所有点波束的result去重
resFile = dir(resdirName);
resfileNum = 1;
for ii = 1:1:length(resFile)
    if resFile(ii).isdir == 0 && ~strcmp(resFile(ii).name, '.')...
            && ~strcmp(resFile(ii).name, '..')...
            && strcmp(resFile(ii).name(1:1:6), 'AISRes')
        resfileName{resfileNum} = resFile(ii).name;
        resfileNum = resfileNum+1;
    end
end
resfileName(resfileNum : end) = [];
resfileNum = resfileNum - 1;

%   读取resultFile中的数据，保存到矩阵resultData中
for ii = 1 : 1 : resfileNum
    name = resfileName{ii};
%     disp(name);
    %   加载data数据信息   
    try
        load([resdirName, '\', name]);
    catch
        disp([name, '读取错误']);
        continue;
    end
    beamResult = demodResult.data;
    F_beamResult = zeros(size(beamResult, 2), 184);
    for jj = 1 : 1 : length(beamResult)
        beamResult{jj}(beamResult{jj} == ' ') = [];
        beamResult{jj} = beamResult{jj} - 48;
        
        %   beamResult1用来存放beamResult的矩阵形式 该段程序的目的是为了避开解调数据中存在
        %   个别解调数据去掉空格后数据位小于184的情况。
        %   beamResult1 = zeros(length(beamResult{jj}), 184);
        

        if length(beamResult{jj}) < 184
            beamResult{jj} = [beamResult{jj}, zeros(1, 184-length(beamResult{jj}))];
        elseif length(beamResult{jj} > 184)
            beamResult{jj} = beamResult{jj}(1:184);
        end        
        F_beamResult(jj, :) = beamResult{jj};
    end
    
    %	将细胞元素转成矩阵格式 矩阵1用beamResult1表示，矩阵2用beamResult2表示
    if ii == 1
        beamResult1 = F_beamResult;
    else
        beamResult2 = F_beamResult;
        beamResult1 = cat(1, beamResult1, beamResult2);
    end 
end
beamResult_new = unique(beamResult1, 'rows');    %   去重后的所有点波束的result数据

%%  求检测概率
rightNum = 0;  %   用于统计正确解调的船的个数
for jj = 1 : 1 : length(beamResult_new)
    if length(beamResult_new(jj, :)) >= 184
        count = sum(all(beamData_new(:, 1: 168) == repmat(beamResult_new(jj, 1 : 168), size(beamData_new, 1), 1), 2));
        rightNum = rightNum + count;
    end
end
%   观测范围内船舶的总的个数用vesNum = length(beamData_new)表示检测概率为beamProDet
beamProDet = rightNum / length(beamData_new);
strbeamNum = num2str(beamNum);    %   波束个数的字符串形式
str = [timeStr, '秒',  vesStr, '艘船', num2str(beamNum), '波束的解调结果为'];
disp(str);
disp(beamProDet);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



