function powDopDelayDOAOfAreas = F_calAreaPar(areas, sateAlt)
    global hMode vPath1 earthR antPar
    thriftAngle = 34;    % ����ƫ�ƽǶȣ�����ƫ��Ϊ-48�� ����ƫ��Ϊ 20
%     antPar = '.\������������\GAIN_4(public).xlsx';
%     antPar = '.\������������\GAIN_6_N(public).xlsx';
%     antPar = '.\������������\��ľ���󣨹�����.xls';
     antPar = '.\������������\������������.xls';
%     antPar = '.\������������\��ľ(����).xls';
    
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
    numberOfAreas = numberOfAreas_sqrt .^ 2;                % С������
    
    areasInLine = reshape(areas, 1, numberOfAreas, 3);      % ��ɨ����������Ϊһά�����Ա����
    areasWithVessels = find(areasInLine(1, :, 1)); % ���ڴ���С�����
    areasLatitude = areasInLine(1, :, 2);   % ȫ��С��γ������
    areasLongitude = areasInLine(1, :, 3);  % ȫ��С����������
    
    % �д�λ�õľ�γ��
    areasLatWithVessels = areasLatitude(areasWithVessels);      % ���д�С��γ������
    areasLongWithVessels = areasLongitude(areasWithVessels);    % ���д�С����������
    [elevationAngle, distance_SatArea , ~] = elevation(areasLatWithVessels, areasLongWithVessels, zeros(1, length(areasWithVessels)), ...
        sateLat*ones(1, length(areasWithVessels)), sateLong*ones(1, length(areasWithVessels)), ...
        sateAlt*ones(1, length(areasWithVessels))*1e3);   % �����С�������ǵ����ǺͿռ����
    clear temp;
    
    transFrequency = 161.975*1e6; % ����Ƶ��(Hz)
    c = 3*10^8;               % ����(m/s)
    
	% 1 �ٶȷ��򡢴�ֱ���ٶȷ���ķ���ָ�����
    
    %����ָ������
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
    
    
	%% ���ʼ���
    coordinate = [vector_SatSpeed(1, :); vector_plane(1, :); vector_Sat(1, :)];
    powerOfAreas = calPower(transPower, elevationAngle, distance_SatArea, -1 * vector_AreaSat,  transFrequency, thriftAngle, coordinate);
	
	%% Ƶƫ����
	G = 6.67*1e-11;       % ��������ϵ��
	M = 5.98*1e24;        % ��������(kg)
	R = 6371*1e3;               % ����뾶(km)
	satelliteSpeed = sqrt(G*M/(R+sateAlt*1e3));     % �����ٶ�(m/s)
	% ���������˶�������С���������ߵļн�����ֵ, �������ģ�ͷ���
	relativeAngle_cos = sum((vector_AreaSat .* vector_SatSpeed), 2)' ./ distance_SatArea;      % �����ٶȷ����봬֮��н�
	dopplerFreqShift = satelliteSpeed/(c/transFrequency) .* relativeAngle_cos;                  % ������Ƶƫ
	
	%% DOA����
	DOAOfAreas = 90 - acos(relativeAngle_cos)/pi*180;           % ������DOA����δ����
	

	%% ʱ�Ӽ���
    bitsPerSecond = 9600;           % AIS��������(bps)
    delayCenterDiff = calTimeDelayDiff(bitsPerSecond, distance_SatArea, sateAlt, c);

    %% �ϲ����
	powDopDelayDOAOfAreas = [powerOfAreas;dopplerFreqShift;delayCenterDiff;DOAOfAreas].';
end