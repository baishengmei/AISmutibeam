function [elevationAngle, distance_SatArea, vector_AreaSat, vector_Sat, vector_SatSpeed, vector_plane, vector_SatAnt] = genSateVector(areas)
    global sateHeight earthR thriftAngle
    [sateLong, sateLat] = getSateMes(areas);
    
	numberOfAreas_sqrt = size(areas, 1);
	numberOfAreas = numberOfAreas_sqrt .^ 2;					% 小区总数
	areasInLine = reshape(areas, 1, numberOfAreas, 3);			% 将扫描区域重组为一维向量以便计算
	areasWithVessels = find(areasInLine(1, :, 1));
    areasLatitude = areasInLine(1, :, 2);   % 全部小区纬度向量
    areasLongitude = areasInLine(1, :, 3);  % 全部小区经度向量
    areasLatWithVessels = areasLatitude(areasWithVessels);      % 各有船小区纬度向量
    areasLongWithVessels = areasLongitude(areasWithVessels);    % 各有船小区经度向量

    [elevationAngle, distance_SatArea , ~] = elevation(areasLatWithVessels, areasLongWithVessels, zeros(1, length(areasWithVessels)), ...
        sateLat*ones(1, length(areasWithVessels)), sateLong*ones(1, length(areasWithVessels)), ...
        sateHeight*ones(1, length(areasWithVessels))*1e3);   % 计算各小区到卫星的仰角和空间距离
    
    % 1 速度方向、垂直于速度方向的方向、指向地心
    %地心指向卫星
    R = earthR * 1e3;
    sateAlt = sateHeight;
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
end
