function receivePowerGain_dB = genRecvGain(pitch, azimuth, xls_data)
%warning : �˺�����������
%�������ܽ��ܣ�
%��������ĸ����ǣ� ��λ���Լ����ߵĲ�����
%������ڸ�С���Ľ����������棻
%���������
%recvAntGain_dB : ��С���Ľ�����������(dB)
%���������
%pitch:������
%azimuth����λ��
%xls_data:�������߸������ǡ���λ�ǵĽ�����������,���Ϊ������
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