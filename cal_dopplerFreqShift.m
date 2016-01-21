function dopplerFreqShiftOfAreas = cal_dopplerFreqShift(areas, transFrequency)
    global c sateHeight
    G = 6.67*1e-11;       % 万有引力系数
	M = 5.98*1e24;        % 地球质量(kg)
	R = 6371*1e3;               % 地球半径(km)
    [~, distance_SatArea, vector_AreaSat, ~, vector_SatSpeed, ~, ~] = genSateVector(areas);
    
	satelliteSpeed = sqrt(G*M/(R+sateHeight*1e3));     % 卫星速度(m/s)
	% 计算卫星运动方向与小区卫星连线的夹角余弦值, 详见报告模型分析
	relativeAngle_cos = sum((vector_AreaSat .* vector_SatSpeed), 2)' ./ distance_SatArea;      % 卫星速度方向与船之间夹角
	dopplerFreqShiftOfAreas = satelliteSpeed/(c/transFrequency) .* relativeAngle_cos;                  % 各船舶频偏
end