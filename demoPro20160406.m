% ʹ��˵���� 1. ���ò���multibeamModeֵ��ȷ�����ನ�������ʻ��ǵ����߼����ʣ�
%           2.  ѡ���������߻��߲�����Ŀ¼�����ļ��� h700_t10_v500_b2_e20

close all;
clc;

global multibeamMode beamNum
multibeamMode = 0;  %   ֵΪ1��ʾ�ನ��ģʽ��ֵΪ0��ʾ������ģʽ
% beamNum = 2;

%   ����ģ��Դ�����ļ��е������е���ĸe�ж��Ƿ����ȷ���ļ��У�ͬʱ���������в����������öನ���Ĳ�������beamNum
%   ���ݽ���㷨��д����demodResult_1ant��ģ��Դ�ļ����ڲ���

datadirName = uigetdir('E:\My shirmey\lab1017\houjincheng20160117\lab1017\AISSig_s\','ѡ��ģ��Դ�����ļ��С���');

%   ��ֹ�򿪴����ļ�·���������ߺͶನ��������ļ�·����ͬ
if(strcmp(datadirName(length(datadirName)-2), 'e')==0)
    error('�ļ���·������');
end
resdirName = [datadirName, '\demodResult_1ant\'];
% ��ȡ���Ǹ߶ȡ������������۲�ʱ����ַ���
posMatr = regexpi(datadirName, '\','end');   %   ���ҷ���\����λ��
posNum = posMatr(1,end);    %   �ҵ�����\�����ֵ�λ��
fileStr = datadirName((posNum+1):length(datadirName)); %   ��ȡ����������ļ����ļ���
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
% �ನ��ģʽ
if(multibeamMode == 1)
    strb = '_b';
    [bStartStr, bEndStr] = regexpi(fileStr, strb, 'start','end');
    vesStr = fileStr(vEndStr+1: bStartStr-1);
    beamStr = fileStr(bEndStr+1: eStartStr-1);
    beamNum = str2double(beamStr);
else
    vesStr = fileStr(vEndStr+1: eStartStr-1);
end

%%  ���е㲨����dataȥ��
%   ��������data�ļ������ļ������浽����datafileName��
dataFile = dir(datadirName);    %   ����data�ļ�Ŀ¼�µ������ļ�
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

%   ��ȡdatafileName�е����ݣ����浽����beamData��
beamData_cell = cell(1, beamNum);
for ii = 1 : 1 : datafileNum
    name = datafileName{ii};
    %   ����data������Ϣ   
    try
        load([datadirName, '\', name]);
    catch
        disp([name, '��ȡ����']);
        continue;
    end
    if(multibeamMode == 1)
        aisData = aisDataBeam;    %   �ನ�����ʹ�ô���
        beamData_cell{ii} = aisData;
    else
        beamData_cell{ii} = aisData;
    end
    %   ��ϸ��Ԫ��ת�ɾ����ʽ ����1��beamData1��ʾ������2��beamData2��ʾ
    if ii == 1
        beamData1 = beamData_cell{ii};
    else
        beamData2 = beamData_cell{ii};
        beamData1 = cat(1, beamData1, beamData2);
    end 
end
beamData = beamData1;                       %   δȥ�ص����е㲨����data����
beamData_new = unique(beamData, 'rows');    %   ȥ�غ�����е㲨����data����


%%  ���е㲨����resultȥ��
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

%   ��ȡresultFile�е����ݣ����浽����resultData��
for ii = 1 : 1 : resfileNum
    name = resfileName{ii};
%     disp(name);
    %   ����data������Ϣ   
    try
        load([resdirName, '\', name]);
    catch
        disp([name, '��ȡ����']);
        continue;
    end
    beamResult = demodResult.data;
    F_beamResult = zeros(size(beamResult, 2), 184);
    for jj = 1 : 1 : length(beamResult)
        beamResult{jj}(beamResult{jj} == ' ') = [];
        beamResult{jj} = beamResult{jj} - 48;
        
        %   beamResult1�������beamResult�ľ�����ʽ �öγ����Ŀ����Ϊ�˱ܿ���������д���
        %   ����������ȥ���ո������λС��184�������
        %   beamResult1 = zeros(length(beamResult{jj}), 184);
        

        if length(beamResult{jj}) < 184
            beamResult{jj} = [beamResult{jj}, zeros(1, 184-length(beamResult{jj}))];
        elseif length(beamResult{jj} > 184)
            beamResult{jj} = beamResult{jj}(1:184);
        end        
        F_beamResult(jj, :) = beamResult{jj};
    end
    
    %	��ϸ��Ԫ��ת�ɾ����ʽ ����1��beamResult1��ʾ������2��beamResult2��ʾ
    if ii == 1
        beamResult1 = F_beamResult;
    else
        beamResult2 = F_beamResult;
        beamResult1 = cat(1, beamResult1, beamResult2);
    end 
end
beamResult_new = unique(beamResult1, 'rows');    %   ȥ�غ�����е㲨����result����

%%  �������
rightNum = 0;  %   ����ͳ����ȷ����Ĵ��ĸ���
for jj = 1 : 1 : length(beamResult_new)
    if length(beamResult_new(jj, :)) >= 184
        count = sum(all(beamData_new(:, 1: 168) == repmat(beamResult_new(jj, 1 : 168), size(beamData_new, 1), 1), 2));
        rightNum = rightNum + count;
    end
end
%   �۲ⷶΧ�ڴ������ܵĸ�����vesNum = length(beamData_new)��ʾ������ΪbeamProDet
beamProDet = rightNum / length(beamData_new);
strbeamNum = num2str(beamNum);    %   �����������ַ�����ʽ
str = [timeStr, '��',  vesStr, '�Ҵ�', num2str(beamNum), '�����Ľ�����Ϊ'];
disp(str);
disp(beamProDet);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



