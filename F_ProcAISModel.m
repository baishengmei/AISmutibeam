function [realVesNum, aisData, zeroNum, parTable, timeTable, transFrequency] = F_ProcAISModel(areas, pretimeTable, preaisData, prezeroNum)
    global multibeamMode beamNum
    numOfAreas_sqrt = size(areas, 1);                   %覆盖直径（小区）
    timeDelay = cal_timeDelay(areas); 
    %   校验输入波束个数是否正确
    if(beamNum ~= 2 && beamNum ~= 4 && beamNum ~= 7)
        error('多波束模式不正确，请输入正确的波束个数（如2,4,7）');
    end
    if multibeamMode == 1       %多波束模式              %由此插入多波束模块的函数
        realVesNum = cell(beamNum, 1);
        aisData = cell(beamNum, 1);
        zeroNum = cell(beamNum, 1);
        parTable = cell(beamNum, 1);
        timeTable = cell(beamNum, 1);
        transFrequency = cell(beamNum, 1);
        for bb = 1: 1: beamNum
            [ transFrequencyBeam, arrBeam] = F_distMutiBeam( bb, numOfAreas_sqrt );
            [ timeDelayBeam, timeTableBeam, aisDataBeam, zeroNumBeam, realVesNumBeam] = F_messageBeam( timeDelay, pretimeTable, arrBeam, numOfAreas_sqrt, preaisData, prezeroNum );
            
            %%%%%%%%%测试用  测试有船小区编号的最大值是不是等于有船小区数；
            aa = max(timeTableBeam(:, 4));
            
            [parTableBeam] = F_calAreaPar_beam(timeDelayBeam, areas, arrBeam, transFrequencyBeam);
            realVesNum(bb) = {realVesNumBeam};
            aisData(bb) = {aisDataBeam};
            zeroNum(bb) = {zeroNumBeam};
            parTable(bb) = {parTableBeam};
            timeTable(bb) = {timeTableBeam};
            transFrequency(bb) = {transFrequencyBeam};
        end
    else                        %非多波束模式
        aisData = preaisData;
        zeroNum = prezeroNum;
        timeTable = pretimeTable;
        transFrequency = 162 * 1e6;      %载波频率
        powerOfAreas = cal_power(areas, transFrequency);
        dopplerFreqShift = cal_dopplerFreqShift(areas, transFrequency);
        DOAOfAreas = cal_doa(areas);
        parTable = [powerOfAreas;dopplerFreqShift;timeDelay;DOAOfAreas].';
    end
end