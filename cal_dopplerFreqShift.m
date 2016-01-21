function dopplerFreqShiftOfAreas = cal_dopplerFreqShift(areas, transFrequency)
    global c sateHeight
    G = 6.67*1e-11;       % ��������ϵ��
	M = 5.98*1e24;        % ��������(kg)
	R = 6371*1e3;               % ����뾶(km)
    [~, distance_SatArea, vector_AreaSat, ~, vector_SatSpeed, ~, ~] = genSateVector(areas);
    
	satelliteSpeed = sqrt(G*M/(R+sateHeight*1e3));     % �����ٶ�(m/s)
	% ���������˶�������С���������ߵļн�����ֵ, �������ģ�ͷ���
	relativeAngle_cos = sum((vector_AreaSat .* vector_SatSpeed), 2)' ./ distance_SatArea;      % �����ٶȷ����봬֮��н�
	dopplerFreqShiftOfAreas = satelliteSpeed/(c/transFrequency) .* relativeAngle_cos;                  % ������Ƶƫ
end