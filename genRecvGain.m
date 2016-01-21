function receivePowerGain_dB = genRecvGain(pitch, azimuth, xls_data)
%warning : 此函数存在问题
%函数功能介绍：
%根据输入的俯仰角， 方位角以及天线的参数，
%输出对于各小区的接收天线增益；
%输出参数：
%recvAntGain_dB : 各小区的接收天线增益(dB)
%输入参数：
%pitch:俯仰角
%azimuth：方位角
%xls_data:接收天线各俯仰角、方位角的接收天线增益,输出为列向量
    xls_data = xls_data(2:size(xls_data, 1), :);
    xls_data = xls_data(:, 2:size(xls_data, 2));
    
    Pitch = round(pitch * 180 / pi);
    Azimuth = round(azimuth * 180 / pi / 5) * 5;
    receivePowerGain_dB = zeros(size(pitch, 1), size(pitch, 2));
    for temp_count = 1: 1: size(pitch, 1)
        tempAzimuth = Azimuth(temp_count, 1);
        tempPitch = Pitch(temp_count, 1);
        if tempAzimuth == 180
            tempAzimuth = 0;
            tempPitch = -1 * tempPitch;
        end
        receivePowerGain_dB(temp_count, 1) = xls_data(tempPitch + 181,  tempAzimuth/5 + 1);
    end
end