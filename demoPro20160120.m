clear all;
close all;
clc;
global multibeamMode beamNum
%   根据模拟源数据文件夹的名字中的字母e判断是否打开正确的文件夹，同时根据名字中波束个数求解该多波束的波束个数beamNum
%   根据解调算法的写法，demodResult_1ant在模拟源文件夹内部。
% datadirName = uigetdir('E:\','选择模拟源数据文件夹……');
datadirName = uigetdir('E:\My shirmey\lab1017\houjincheng20160117\lab1017\AISSig_s\','选择模拟源数据文件夹……');
if(strcmp(datadirName(length(datadirName)-2), 'e')==0)
    error('文件夹路径有误');
end
%   多波束概率使用
% vesStr = datadirName((length(datadirName)-10):(length(datadirName)-7));
% timeStr = datadirName((length(datadirName)-14):(length(datadirName)-13));
% beamNum = str2double(datadirName(length(datadirName)-4));   %   根据文件夹名字读取波束个数

%   单天线解调概率使用
vesStr = datadirName((length(datadirName)-7):(length(datadirName)-4));
timeStr = datadirName((length(datadirName)-11):(length(datadirName)-10));
beamNum = 1;

resdirName = [datadirName, '/demodResult_1ant/'];

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
%     disp(name);
    %   获取观测时间字符串
    sigTimeLoc = strfind(name, '_t') + 2;
    sigTimeEndLoc = strfind(name, '_v')-1;
    sigTimeEndLoc_1 = sigTimeEndLoc(1);
%     sigTimeEndLoc_2 = sigTimeEndLoc(2);   %   多波束解调使用该代码
    sigTimeStr = name(sigTimeLoc : 1 : sigTimeEndLoc_1);		
    
%       获取船数字符串，包括总船数以及波束内的船数
%     vesNumLoc_1 = sigTimeEndLoc_1 + 3;
%     vesNumEndLoc = strfind(name, '_e20') - 1;
%     vesNumStr_1 = name(vesNumLoc_1:1:sigTimeEndLoc_2);  %   总船数的字符串
    
%     vesNumLoc_2 = sigTimeEndLoc_2+3;
%     vesNumStr_2 = name(vesNumLoc_2 : 1 : vesNumEndLoc); %   实际波束船数的字符串

%   单天线解调方式，获取船舶数量字符串，包括总船数以及波束内的船数
    vesNumLoc_1 = sigTimeEndLoc_1 + 3;
    vesNumEndLoc = strfind(name, '_e20') - 1;
    vesNumStr_1 = name(vesNumLoc_1:1:vesNumEndLoc);  %   总船数的字符串
    
    %   加载data数据信息   
    try
        load([datadirName, '\', name]);
    catch
        disp([name, '读取错误']);
        continue;
    end
%     aisData = aisDataBeam;    %   多波束解调使用代码
    beamData_cell{ii} = aisData;
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
% beamResult_cell = cell(1, length(resultFile));
for ii = 1 : 1 : resfileNum
    name = resfileName{ii};
    disp(name);
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
%         beamResult1 = zeros(length(beamResult{jj}), 184);
        

        if length(beamResult{jj}) < 184
            beamResult{jj} = [beamResult{jj}, zeros(1, 184-length(beamResult{jj}))];
        elseif length(beamResult{jj} > 184)
            beamResult{jj} = beamResult{jj}(1:184);
        end        
        F_beamResult(jj, :) = beamResult{jj};
    end
    
%       将细胞元素转成矩阵格式 矩阵1用beamResult1表示，矩阵2用beamResult2表示
    if ii == 1
        beamResult1 = F_beamResult;
    else
        beamResult2 = F_beamResult;
        beamResult1 = cat(1, beamResult1, beamResult2);
    end 
end
% beamResult = beamResult1;                       %   未去重的所有点波束的result数据
beamResult_new = unique(beamResult1, 'rows');    %   去重后的所有点波束的result数据

%%  求检测概率
rightNum = 0;  %   用于统计正确解调的船的个数
for jj = 1 : 1 : length(beamResult_new)
    if length(beamResult_new(jj, :)) >= 184
%         count = sum(all(beamData_new(:, 1: 168) == repmat(beamResult_new{jj}(1 : 168), size(beamData_new, 1), 1), 2));
        count = sum(all(beamData_new(:, 1: 168) == repmat(beamResult_new(jj, 1 : 168), size(beamData_new, 1), 1), 2));
        rightNum = rightNum + count;
    end
end
%   观测范围内船舶的总的个数用vesNum = length(beamData_new)表示检测概率为beamProDet
beamProDet = rightNum / length(beamData_new);
% strbeamNum = num2str(beamNum);    %   波束个数的字符串形式
% strX = strcat(strbeamNum, '波束检测概率.xlsx');
% xlswrite(strX, beamProDet, 'sheet1', 'D1');
% disp('四波束的解调概率为：');
str = [timeStr, '秒',  vesStr, '艘船', num2str(beamNum), '波束的解调结果为'];
% disp([num2str(beamNum), '波束的解调结果为']);
disp(str);
disp(beamProDet);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



