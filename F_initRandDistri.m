function distriMat = F_initRandDistri(vesNum, numberOfAreas_sqrt)
    % ������ȷֲ�����
    numOfCh = 1;		% �ŵ���
    areaWidth = 40;		% С��ֱ��(nmile)
%     initLatitude = 0;		% ��ʼγ��
%     initLongitude = 0;		% ��ʼ����
    
    averageNumberOfVessels = (vesNum / ((numberOfAreas_sqrt.^2) / 4 * pi) / numOfCh );         % ƽ����С��ÿ�ŵ��Ĵ���
    
    distriMat = zeros(numberOfAreas_sqrt, numberOfAreas_sqrt, 3);   % �������, ��һά�Ǵ���������άΪ����
    deltaDeg = nm2deg(areaWidth);           % ����С����ȼ���С���ڵ����Ͽ�Խ�ľ�γ��
%     latitude = initLatitude + deltaDeg .* (numberOfAreas_sqrt - 1 : -1 : 0)';       % ��С��γ��
%     latitudeOfAllAreas = repmat(latitude, 1, numberOfAreas_sqrt);
%     longitude = initLongitude + deltaDeg .* (0 : 1 : numberOfAreas_sqrt - 1);       % ��С������
%     longitudeOfAllAreas = repmat(longitude, numberOfAreas_sqrt, 1);
    latitude = F_calAreasLat(numberOfAreas_sqrt);       % ��С��γ��
%     latitudeOfAllAreas = repmat(latitude, 1, numberOfAreas_sqrt);
    latitudeOfAllAreas = latitude(:, :, 1);
    longitude = F_calAreasLon(latitude);       % ��С������
%     longitudeOfAllAreas = repmat(longitude, numberOfAreas_sqrt, 1);
    longitudeOfAllAreas = longitude(:, :, 1);
    distriMat(:, :, 2) = -latitudeOfAllAreas;   
    distriMat(:, :, 3) = longitudeOfAllAreas;
    
    rows = repmat((1 : 1 : numberOfAreas_sqrt).', 1, numberOfAreas_sqrt);
    cols = repmat(1 : 1 : numberOfAreas_sqrt, numberOfAreas_sqrt, 1);
    range = (rows - numberOfAreas_sqrt / 2) .^ 2 + (cols - numberOfAreas_sqrt / 2) .^ 2 <= (numberOfAreas_sqrt / 2) .^ 2;
    
    distriMat(:, :, 1) = round(rand(numberOfAreas_sqrt) + averageNumberOfVessels - 0.5);
    distriMat(:, :, 1) = distriMat(:, :, 1) .* range;
end