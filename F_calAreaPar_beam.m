function powDopDelayDOAOfAreas = F_calAreaPar_beam(timeDlay_beam, areas, arrBeam, transFrequency)

    %   点波束areas_beam(维度等于areas的维度，将点波束外的区域置零)
    areas_beam(:, :, :) = zeros(size(areas));
    areas_beam(:,:,1) = arrBeam.*areas(:,:,1);
    areas_beam(:,:,2) = arrBeam.*areas(:,:,2);
    areas_beam(:,:,3) = arrBeam.*areas(:,:,3);
    
    %   点波束时延计算
%     areaRealNo_beam = unique(timeTable_beam(:, 4));    %   点波束内有船小区编号
%     timeDlay_beam = timeDelay(1, areaRealNo_beam');
    
    %   点波束功率计算
    power_beam = cal_power(areas_beam, transFrequency);
    %   点波束频偏计算
    dopplerFreq_beam = cal_dopplerFreqShift(areas_beam, transFrequency);
    %   点波束DOA计算
    DOA_beam = cal_doa(areas_beam);
    %   点波束参数合并输出
    powDopDelayDOAOfAreas = [power_beam;dopplerFreq_beam;timeDlay_beam;DOA_beam].';
end