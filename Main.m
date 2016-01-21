function Main
    clc
    clear
    tic;
    global vHeight vVesNum vTime vEbNo vPath sateHeight sateLon stateSize earthR nmile2km sateLat ModleORRand ...
        multibeamMode beamNum thriftAngle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%变量赋值%%%%%%%%%%%%%%%%%%%%%%%%%%%
    sateHeight = 700;              %卫星高度
    sateLon = 102;                 %卫星经度
    sateLat = 31.8029;             %卫星纬度
    stateSize = 40;                %一个小区的边长为40海里
    earthR = 6371;                 %地球半径
    nmile2km = 1.852;              %Km跟海里转换
    ModleORRand = 0;               %0采用均匀分布模型；1采用实际分布模型
    multibeamMode = 1;             %1采用多波束模式；0 不采用；
    beamNum = 2;                   %如果采用多波束模式，设定波束个数；
    thriftAngle = 34;              %天线偏角
    resultPath = './AISSig_s';
    %     modelPath = '../上海新transNew102.mat';
    obTime = [300];                 %观测时间
    vesNum = [2000 4000];               %船舶数量
    snr = 20;                      %信噪比
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
            %F_genParameter里面有areas测试用例，实际产生数据时需要修改
            [areas, realVesNum] = F_genParameter(vHeight, vVesNum);		% areas为船舶分布矩阵, parTable为各船舶参数表, vesNum为实际船舶数量
            [aisData, zeroNum] = F_genAISData(realVesNum);					        % aisData为各船舶发送的二进制信息
            TimeTable = F_genTimeTable(areas, vTime, vHeight);		% timeTable为各帧信号的发送时间
            areasdatazerotime = F_areasdatazerotime(areas, aisData, zeroNum, TimeTable);    %   保存整体区域内的areas，aisdata，zeronum和timeTable到一个文件中
            [realVesNum_cell, aisData_cell, zeroNum_cell, parTable_cell, timeTable_cell, transFrequency_cell] = F_ProcAISModel(areas, TimeTable, aisData, zeroNum);
            F_genAISSig(areasdatazerotime, realVesNum_cell, aisData_cell, zeroNum_cell, parTable_cell, timeTable_cell, transFrequency_cell,  vTime, vPath);		% 生成AIS信号并保存在vPath下
        end
    end
    toc;
end