function powDopDelayDOAOfAreas = F_calAreaPar(areas, sateAlt)
    global hMode vPath1 earthR antPar
    thriftAngle = 34;    % 卫星偏移角度，向左偏移为-48， 向右偏移为 20
%     antPar = '.\接收天线增益\GAIN_4(public).xlsx';
%     antPar = '.\接收天线增益\GAIN_6_N(public).xlsx';
%     antPar = '.\接收天线增益\八木组阵（公开）.xls';
     antPar = '.\接收天线增益\螺旋（公开）.xls';
%     antPar = '.\接收天线增益\八木(公开).xls';
    
%    if exist('antPar', 'var') && ~isempty(antPar)
        %thriftAngle = 0;
%   end
    transPower = 41;
	numberOfAreas_sqrt = size(areas, 1);
	mid = floor(numberOfAreas_sqrt / 2);
%     if(get(hMode, 'value') == 1)
	if exist('vPath1', 'var') && ~isempty(vPath1)
        load(vPath1);
        sateLat = sate_NS;
        sateLong = sate_EW;
    else
        sateLat = areas(mid, mid, 2);
        sateLong = areas(mid, mid, 3);
    end
    R = earthR * 1e3;
    numberOfAreas = numberOfAreas_sqrt .^ 2;                % 小区总数
    
    areasInLine = reshape(areas, 1, numberOfAreas, 3);      % 将扫描区域重组为一维向量以便计算
    areasWithVessels = find(areasInLine(1, :, 1)); % 存在船的小区标号
    areasLatitude = areasInLine(1, :, 2);   % 全部小区纬度向量
    areasLongitude = areasInLine(1, :, 3);  % 全部小区经度向量
    
    % 有船位置的经纬度
    areasLatWithVessels = areasLatitude(areasWithVessels);      % 各有船小区纬度向量
    areasLongWithVessels = areasLongitude(areasWithVessels);    % 各有船小区经度向量
    [elevationAngle, distance_SatArea , ~] = elevation(areasLatWithVessels, areasLongWithVessels, zeros(1, length(areasWithVessels)), ...
        sateLat*ones(1, length(areasWithVessels)), sateLong*ones(1, length(areasWithVessels)), ...
        sateAlt*ones(1, length(areasWithVessels))*1e3);   % 计算各小区到卫星的仰角和空间距离
    clear temp;
    
    transFrequency = 161.975*1e6; % 发送频率(Hz)
    c = 3*10^8;               % 光速(m/s)
    
	% 1 速度方向、垂直于速度方向的方向、指向地心
    
    %地心指向卫星
    vector_Sat_x = (R+sateAlt*1e3) .* sin((90-sateLat)*pi/180).* cos(sateLong * pi/180) .* ones(length(areasWithVessels), 1);
    vector_Sat_y = (R+sateAlt*1e3) .* sin((90-sateLat)*pi/180).* sin(sateLong * pi/180) .* ones(length(areasWithVessels), 1);
    vector_Sat_z = (R+sateAlt*1e3) .* cos((90-sateLat)*pi/180) .* ones(length(areasWithVessels), 1);
    vector_Sat = [vector_Sat_x vector_Sat_y vector_Sat_z];
    %速度方向（卫星运行轨迹和地球经度之间有一个8度的夹角）
    vector_latTangent = [vector_Sat_x(1,1), vector_Sat_y(1,1), 0];
    vector_latTangent = cross(vector_Sat(1,:), vector_latTangent);
    vector_lonTangent = cross(vector_Sat(1,:), vector_latTangent);
    vector_latTangent = vector_latTangent / sqrt(sum(vector_latTangent .* vector_latTangent));
    vector_lonTangent = vector_lonTangent / sqrt(sum(vector_lonTangent .* vector_lonTangent));
    vector_SatSpeed = vector_lonTangent * cos(8 * pi/180) + vector_latTangent * sin(8 * pi/180);
    vector_SatSpeed = ones(size(vector_Sat, 1), 1) * vector_SatSpeed;
    %垂直于上面两个的方向
    vector_plane = cross(vector_Sat, vector_SatSpeed);
    %卫星到小区的向量计算
    vector_Area_x = (R .* sin((90-areasLatWithVessels)*pi/180) .* cos(areasLongWithVessels * pi/180))';
    vector_Area_y = (R .* sin((90-areasLatWithVessels)*pi/180) .* sin(areasLongWithVessels * pi/180))';
    vector_Area_z = (R .* cos((90-areasLatWithVessels)*pi/180))';
    vector_Area = [vector_Area_x vector_Area_y vector_Area_z];
    vector_AreaSat = vector_Sat-vector_Area;
    
    %向量单位化
    vector_Sat = vector_Sat ./ (sqrt(sum(vector_Sat .* vector_Sat, 2)) * ones(1, 3));
    vector_SatSpeed = vector_SatSpeed ./ (sqrt(sum(vector_SatSpeed .* vector_SatSpeed, 2)) * ones(1, 3));
    vector_plane = vector_plane ./ (sqrt(sum(vector_plane .* vector_plane, 2)) * ones(1, 3));
    % 卫星天线方向
    vector_SatAnt = vector_plane * sin(thriftAngle * pi / 180) + -1 * vector_Sat * cos(thriftAngle * pi / 180);
    
    
	%% 功率计算
    coordinate = [vector_SatSpeed(1, :); vector_plane(1, :); vector_Sat(1, :)];
    powerOfAreas = calPower(transPower, elevationAngle, distance_SatArea, -1 * vector_AreaSat,  transFrequency, thriftAngle, coordinate);
	
	%% 频偏计算
	G = 6.67*1e-11;       % 万有引力系数
	M = 5.98*1e24;        % 地球质量(kg)
	R = 6371*1e3;               % 地球半径(km)
	satelliteSpeed = sqrt(G*M/(R+sateAlt*1e3));     % 卫星速度(m/s)
	% 计算卫星运动方向与小区卫星连线的夹角余弦值, 详见报告模型分析
	relativeAngle_cos = sum((vector_AreaSat .* vector_SatSpeed), 2)' ./ distance_SatArea;      % 卫星速度方向与船之间夹角
	dopplerFreqShift = satelliteSpeed/(c/transFrequency) .* relativeAngle_cos;                  % 各船舶频偏
	
	%% DOA计算
	DOAOfAreas = 90 - acos(relativeAngle_cos)/pi*180;           % 各船舶DOA（暂未处理）
	

	%% 时延计算
    bitsPerSecond = 9600;           % AIS数据速率(bps)
    delayCenterDiff = calTimeDelayDiff(bitsPerSecond, distance_SatArea, sateAlt, c);

    %% 合并输出
	powDopDelayDOAOfAreas = [powerOfAreas;dopplerFreqShift;delayCenterDiff;DOAOfAreas].';
end