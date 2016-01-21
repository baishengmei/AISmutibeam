function [realVesNum, aisData, zeroNum, parTable, timeTable, transFrequency] = F_ProcAISModel(areas, pretimeTable, preaisData, prezeroNum)
    global multibeamMode beamNum
    numOfAreas_sqrt = size(areas, 1);                   %����ֱ����С����
    timeDelay = cal_timeDelay(areas); 
    %   У�����벨�������Ƿ���ȷ
    if(beamNum ~= 2 && beamNum ~= 4 && beamNum ~= 7)
        error('�ನ��ģʽ����ȷ����������ȷ�Ĳ�����������2,4,7��');
    end
    if multibeamMode == 1       %�ನ��ģʽ              %�ɴ˲���ನ��ģ��ĺ���
        realVesNum = cell(beamNum, 1);
        aisData = cell(beamNum, 1);
        zeroNum = cell(beamNum, 1);
        parTable = cell(beamNum, 1);
        timeTable = cell(beamNum, 1);
        transFrequency = cell(beamNum, 1);
        for bb = 1: 1: beamNum
            [ transFrequencyBeam, arrBeam] = F_distMutiBeam( bb, numOfAreas_sqrt );
            [ timeDelayBeam, timeTableBeam, aisDataBeam, zeroNumBeam, realVesNumBeam] = F_messageBeam( timeDelay, pretimeTable, arrBeam, numOfAreas_sqrt, preaisData, prezeroNum );
            
            %%%%%%%%%������  �����д�С����ŵ����ֵ�ǲ��ǵ����д�С������
            aa = max(timeTableBeam(:, 4));
            
            [parTableBeam] = F_calAreaPar_beam(timeDelayBeam, areas, arrBeam, transFrequencyBeam);
            realVesNum(bb) = {realVesNumBeam};
            aisData(bb) = {aisDataBeam};
            zeroNum(bb) = {zeroNumBeam};
            parTable(bb) = {parTableBeam};
            timeTable(bb) = {timeTableBeam};
            transFrequency(bb) = {transFrequencyBeam};
        end
    else                        %�Ƕನ��ģʽ
        aisData = preaisData;
        zeroNum = prezeroNum;
        timeTable = pretimeTable;
        transFrequency = 162 * 1e6;      %�ز�Ƶ��
        powerOfAreas = cal_power(areas, transFrequency);
        dopplerFreqShift = cal_dopplerFreqShift(areas, transFrequency);
        DOAOfAreas = cal_doa(areas);
        parTable = [powerOfAreas;dopplerFreqShift;timeDelay;DOAOfAreas].';
    end
end