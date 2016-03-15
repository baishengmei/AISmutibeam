clear all;
close all;
clc;
global multibeamMode beamNum
%   ����ģ��Դ�����ļ��е������е���ĸe�ж��Ƿ����ȷ���ļ��У�ͬʱ���������в����������öನ���Ĳ�������beamNum
%   ���ݽ���㷨��д����demodResult_1ant��ģ��Դ�ļ����ڲ���
% datadirName = uigetdir('E:\','ѡ��ģ��Դ�����ļ��С���');
datadirName = uigetdir('E:\My shirmey\lab1017\houjincheng20160117\lab1017\AISSig_s\','ѡ��ģ��Դ�����ļ��С���');
if(strcmp(datadirName(length(datadirName)-2), 'e')==0)
    error('�ļ���·������');
end
%   �ನ������ʹ��
% vesStr = datadirName((length(datadirName)-10):(length(datadirName)-7));
% timeStr = datadirName((length(datadirName)-14):(length(datadirName)-13));
% beamNum = str2double(datadirName(length(datadirName)-4));   %   �����ļ������ֶ�ȡ��������

%   �����߽������ʹ��
vesStr = datadirName((length(datadirName)-7):(length(datadirName)-4));
timeStr = datadirName((length(datadirName)-11):(length(datadirName)-10));
beamNum = 1;

resdirName = [datadirName, '/demodResult_1ant/'];

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
%     disp(name);
    %   ��ȡ�۲�ʱ���ַ���
    sigTimeLoc = strfind(name, '_t') + 2;
    sigTimeEndLoc = strfind(name, '_v')-1;
    sigTimeEndLoc_1 = sigTimeEndLoc(1);
%     sigTimeEndLoc_2 = sigTimeEndLoc(2);   %   �ನ�����ʹ�øô���
    sigTimeStr = name(sigTimeLoc : 1 : sigTimeEndLoc_1);		
    
%       ��ȡ�����ַ����������ܴ����Լ������ڵĴ���
%     vesNumLoc_1 = sigTimeEndLoc_1 + 3;
%     vesNumEndLoc = strfind(name, '_e20') - 1;
%     vesNumStr_1 = name(vesNumLoc_1:1:sigTimeEndLoc_2);  %   �ܴ������ַ���
    
%     vesNumLoc_2 = sigTimeEndLoc_2+3;
%     vesNumStr_2 = name(vesNumLoc_2 : 1 : vesNumEndLoc); %   ʵ�ʲ����������ַ���

%   �����߽����ʽ����ȡ���������ַ����������ܴ����Լ������ڵĴ���
    vesNumLoc_1 = sigTimeEndLoc_1 + 3;
    vesNumEndLoc = strfind(name, '_e20') - 1;
    vesNumStr_1 = name(vesNumLoc_1:1:vesNumEndLoc);  %   �ܴ������ַ���
    
    %   ����data������Ϣ   
    try
        load([datadirName, '\', name]);
    catch
        disp([name, '��ȡ����']);
        continue;
    end
%     aisData = aisDataBeam;    %   �ನ�����ʹ�ô���
    beamData_cell{ii} = aisData;
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
% beamResult_cell = cell(1, length(resultFile));
for ii = 1 : 1 : resfileNum
    name = resfileName{ii};
    disp(name);
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
%         beamResult1 = zeros(length(beamResult{jj}), 184);
        

        if length(beamResult{jj}) < 184
            beamResult{jj} = [beamResult{jj}, zeros(1, 184-length(beamResult{jj}))];
        elseif length(beamResult{jj} > 184)
            beamResult{jj} = beamResult{jj}(1:184);
        end        
        F_beamResult(jj, :) = beamResult{jj};
    end
    
%       ��ϸ��Ԫ��ת�ɾ����ʽ ����1��beamResult1��ʾ������2��beamResult2��ʾ
    if ii == 1
        beamResult1 = F_beamResult;
    else
        beamResult2 = F_beamResult;
        beamResult1 = cat(1, beamResult1, beamResult2);
    end 
end
% beamResult = beamResult1;                       %   δȥ�ص����е㲨����result����
beamResult_new = unique(beamResult1, 'rows');    %   ȥ�غ�����е㲨����result����

%%  �������
rightNum = 0;  %   ����ͳ����ȷ����Ĵ��ĸ���
for jj = 1 : 1 : length(beamResult_new)
    if length(beamResult_new(jj, :)) >= 184
%         count = sum(all(beamData_new(:, 1: 168) == repmat(beamResult_new{jj}(1 : 168), size(beamData_new, 1), 1), 2));
        count = sum(all(beamData_new(:, 1: 168) == repmat(beamResult_new(jj, 1 : 168), size(beamData_new, 1), 1), 2));
        rightNum = rightNum + count;
    end
end
%   �۲ⷶΧ�ڴ������ܵĸ�����vesNum = length(beamData_new)��ʾ������ΪbeamProDet
beamProDet = rightNum / length(beamData_new);
% strbeamNum = num2str(beamNum);    %   �����������ַ�����ʽ
% strX = strcat(strbeamNum, '����������.xlsx');
% xlswrite(strX, beamProDet, 'sheet1', 'D1');
% disp('�Ĳ����Ľ������Ϊ��');
str = [timeStr, '��',  vesStr, '�Ҵ�', num2str(beamNum), '�����Ľ�����Ϊ'];
% disp([num2str(beamNum), '�����Ľ�����Ϊ']);
disp(str);
disp(beamProDet);
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



