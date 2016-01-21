function powDopDelayDOAOfAreas = F_calAreaPar_beam(timeDlay_beam, areas, arrBeam, transFrequency)

    %   �㲨��areas_beam(ά�ȵ���areas��ά�ȣ����㲨�������������)
    areas_beam(:, :, :) = zeros(size(areas));
    areas_beam(:,:,1) = arrBeam.*areas(:,:,1);
    areas_beam(:,:,2) = arrBeam.*areas(:,:,2);
    areas_beam(:,:,3) = arrBeam.*areas(:,:,3);
    
    %   �㲨��ʱ�Ӽ���
%     areaRealNo_beam = unique(timeTable_beam(:, 4));    %   �㲨�����д�С�����
%     timeDlay_beam = timeDelay(1, areaRealNo_beam');
    
    %   �㲨�����ʼ���
    power_beam = cal_power(areas_beam, transFrequency);
    %   �㲨��Ƶƫ����
    dopplerFreq_beam = cal_dopplerFreqShift(areas_beam, transFrequency);
    %   �㲨��DOA����
    DOA_beam = cal_doa(areas_beam);
    %   �㲨�������ϲ����
    powDopDelayDOAOfAreas = [power_beam;dopplerFreq_beam;timeDlay_beam;DOA_beam].';
end