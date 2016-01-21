function powerOfAreas = cal_power(areas, transFrequency)
    global thriftAngle transPower
    [elevationAngle, distance_SatArea, vector_AreaSat, vector_Sat, vector_SatSpeed, vector_plane, ~] = genSateVector(areas);
    coordinate = [vector_SatSpeed(1, :); vector_plane(1, :); vector_Sat(1, :)];
    
    %�������͹���
    vesTransPower = transPower; 
    sateThriftAngle = thriftAngle;
    %������������
    %warning���˴��õ���evaluation��������������ǣ�
    patternGain_dB = 10*log10(0.964*16/3/pi*(sin((90-elevationAngle)*pi/180)).^3 + eps*1e10);  
    %�������
    freeSpaceLoss_dB = -(32.44 + 20*log10(distance_SatArea/1000) + 20*log10(transFrequency/1e6));   %���ɿռ����(dB)
    totalLoss_dB = freeSpaceLoss_dB;    %�ź������
    %������������
    recvGain_dB = calRecvGain(-1 * vector_AreaSat, coordinate, sateThriftAngle);
    %�����źŹ���
    powerOfAreas = vesTransPower + patternGain_dB + totalLoss_dB + recvGain_dB'; 
end