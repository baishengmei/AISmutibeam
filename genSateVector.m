function [elevationAngle, distance_SatArea, vector_AreaSat, vector_Sat, vector_SatSpeed, vector_plane, vector_SatAnt] = genSateVector(areas)
    global sateHeight earthR thriftAngle
    [sateLong, sateLat] = getSateMes(areas);
    
	numberOfAreas_sqrt = size(areas, 1);
	numberOfAreas = numberOfAreas_sqrt .^ 2;					% С������
	areasInLine = reshape(areas, 1, numberOfAreas, 3);			% ��ɨ����������Ϊһά�����Ա����
	areasWithVessels = find(areasInLine(1, :, 1));
    areasLatitude = areasInLine(1, :, 2);   % ȫ��С��γ������
    areasLongitude = areasInLine(1, :, 3);  % ȫ��С����������
    areasLatWithVessels = areasLatitude(areasWithVessels);      % ���д�С��γ������
    areasLongWithVessels = areasLongitude(areasWithVessels);    % ���д�С����������

    [elevationAngle, distance_SatArea , ~] = elevation(areasLatWithVessels, areasLongWithVessels, zeros(1, length(areasWithVessels)), ...
        sateLat*ones(1, length(areasWithVessels)), sateLong*ones(1, length(areasWithVessels)), ...
        sateHeight*ones(1, length(areasWithVessels))*1e3);   % �����С�������ǵ����ǺͿռ����
    
    % 1 �ٶȷ��򡢴�ֱ���ٶȷ���ķ���ָ�����
    %����ָ������
    R = earthR * 1e3;
    sateAlt = sateHeight;
    vector_Sat_x = (R+sateAlt*1e3) .* sin((90-sateLat)*pi/180).* cos(sateLong * pi/180) .* ones(length(areasWithVessels), 1);
    vector_Sat_y = (R+sateAlt*1e3) .* sin((90-sateLat)*pi/180).* sin(sateLong * pi/180) .* ones(length(areasWithVessels), 1);
    vector_Sat_z = (R+sateAlt*1e3) .* cos((90-sateLat)*pi/180) .* ones(length(areasWithVessels), 1);
    vector_Sat = [vector_Sat_x vector_Sat_y vector_Sat_z];
    
    %�ٶȷ����������й켣�͵��򾭶�֮����һ��8�ȵļнǣ�
    vector_latTangent = [vector_Sat_x(1,1), vector_Sat_y(1,1), 0];
    vector_latTangent = cross(vector_Sat(1,:), vector_latTangent);
    vector_lonTangent = cross(vector_Sat(1,:), vector_latTangent);
    vector_latTangent = vector_latTangent / sqrt(sum(vector_latTangent .* vector_latTangent));
    vector_lonTangent = vector_lonTangent / sqrt(sum(vector_lonTangent .* vector_lonTangent));
    vector_SatSpeed = vector_lonTangent * cos(8 * pi/180) + vector_latTangent * sin(8 * pi/180);
    vector_SatSpeed = ones(size(vector_Sat, 1), 1) * vector_SatSpeed;
    
    %��ֱ�����������ķ���
    vector_plane = cross(vector_Sat, vector_SatSpeed);
    
    %���ǵ�С������������
    vector_Area_x = (R .* sin((90-areasLatWithVessels)*pi/180) .* cos(areasLongWithVessels * pi/180))';
    vector_Area_y = (R .* sin((90-areasLatWithVessels)*pi/180) .* sin(areasLongWithVessels * pi/180))';
    vector_Area_z = (R .* cos((90-areasLatWithVessels)*pi/180))';
    vector_Area = [vector_Area_x vector_Area_y vector_Area_z];
    vector_AreaSat = vector_Sat-vector_Area;
    
    %������λ��
    vector_Sat = vector_Sat ./ (sqrt(sum(vector_Sat .* vector_Sat, 2)) * ones(1, 3));
    vector_SatSpeed = vector_SatSpeed ./ (sqrt(sum(vector_SatSpeed .* vector_SatSpeed, 2)) * ones(1, 3));
    vector_plane = vector_plane ./ (sqrt(sum(vector_plane .* vector_plane, 2)) * ones(1, 3));
    
    % �������߷���
    vector_SatAnt = vector_plane * sin(thriftAngle * pi / 180) + -1 * vector_Sat * cos(thriftAngle * pi / 180);
end
