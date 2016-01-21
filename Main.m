function Main
    clc
    clear
    tic;
    global vHeight vVesNum vTime vEbNo vPath sateHeight sateLon stateSize earthR nmile2km sateLat ModleORRand ...
        multibeamMode beamNum thriftAngle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%������ֵ%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sateHeight = 700;              %���Ǹ߶�
    sateLon = 102;                 %���Ǿ���
    sateLat = 31.8029;             %����γ��
    stateSize = 40;                %һ��С���ı߳�Ϊ40����
    earthR = 6371;                 %����뾶
    nmile2km = 1.852;              %Km������ת��
    ModleORRand = 0;               %0���þ��ȷֲ�ģ�ͣ�1����ʵ�ʷֲ�ģ��
    multibeamMode = 1;             %1���öನ��ģʽ��0 �����ã�
    beamNum = 2;                   %������öನ��ģʽ���趨����������
    thriftAngle = 34;              %����ƫ��
    resultPath = './AISSig_s';
    %     modelPath = '../�Ϻ���transNew102.mat';
    obTime = [300];                 %�۲�ʱ��
    vesNum = [2000 4000];               %��������
    snr = 20;                      %�����
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    F_initPar;
    vHeight = sateHeight;
    vEbNo = snr;
    vPath = resultPath;
    %     vPath1 = modelPath;
    for tt = 1 : 1 : length(obTime)
        vTime = obTime(tt);
        for vv = 1 : 1 : length(vesNum)
            vVesNum = vesNum(vv);
            disp([obTime(tt) vesNum(vv)]);      
            %F_genParameter������areas����������ʵ�ʲ�������ʱ��Ҫ�޸�
            [areas, realVesNum] = F_genParameter(vHeight, vVesNum);		% areasΪ�����ֲ�����, parTableΪ������������, vesNumΪʵ�ʴ�������
            [aisData, zeroNum] = F_genAISData(realVesNum);					        % aisDataΪ���������͵Ķ�������Ϣ
            TimeTable = F_genTimeTable(areas, vTime, vHeight);		% timeTableΪ��֡�źŵķ���ʱ��
            areasdatazerotime = F_areasdatazerotime(areas, aisData, zeroNum, TimeTable);    %   �������������ڵ�areas��aisdata��zeronum��timeTable��һ���ļ���
            [realVesNum_cell, aisData_cell, zeroNum_cell, parTable_cell, timeTable_cell, transFrequency_cell] = F_ProcAISModel(areas, TimeTable, aisData, zeroNum);
            F_genAISSig(areasdatazerotime, realVesNum_cell, aisData_cell, zeroNum_cell, parTable_cell, timeTable_cell, transFrequency_cell,  vTime, vPath);		% ����AIS�źŲ�������vPath��
        end
    end
    toc;
end