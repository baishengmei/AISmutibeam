function powerOfAreas = cal_power(areas, transFrequency)
    global thriftAngle transPower
    [elevationAngle, distance_SatArea, vector_AreaSat, vector_Sat, vector_SatSpeed, vector_plane, ~] = genSateVector(areas);
    coordinate = [vector_SatSpeed(1, :); vector_plane(1, :); vector_Sat(1, :)];
    
    %船舶发送功率
    vesTransPower = transPower; 
    sateThriftAngle = thriftAngle;
    %发送天线增益
    %warning：此处用的是evaluation所计算出来的仰角；
    patternGain_dB = 10*log10(0.964*16/3/pi*(sin((90-elevationAngle)*pi/180)).^3 + eps*1e10);  
    %传输损耗
    freeSpaceLoss_dB = -(32.44 + 20*log10(distance_SatArea/1000) + 20*log10(transFrequency/1e6));   %自由空间损耗(dB)
    totalLoss_dB = freeSpaceLoss_dB;    %信号总损耗
    %接收天线增益
    recvGain_dB = calRecvGain(-1 * vector_AreaSat, coordinate, sateThriftAngle);
    %接收信号功率
    powerOfAreas = vesTransPower + patternGain_dB + totalLoss_dB + recvGain_dB'; 
end