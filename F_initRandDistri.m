function distriMat = F_initRandDistri(vesNum, numberOfAreas_sqrt)
    % 随机均匀分布船舶
    numOfCh = 1;		% 信道数
    areaWidth = 40;		% 小区直径(nmile)
%     initLatitude = 0;		% 初始纬度
%     initLongitude = 0;		% 初始经度
    
    averageNumberOfVessels = (vesNum / ((numberOfAreas_sqrt.^2) / 4 * pi) / numOfCh );         % 平均各小区每信道的船数
    
    distriMat = zeros(numberOfAreas_sqrt, numberOfAreas_sqrt, 3);   % 区域矩阵, 第一维是船数，后两维为坐标
    deltaDeg = nm2deg(areaWidth);           % 根据小区宽度计算小区在地球上跨越的经纬度
%     latitude = initLatitude + deltaDeg .* (numberOfAreas_sqrt - 1 : -1 : 0)';       % 各小区纬度
%     latitudeOfAllAreas = repmat(latitude, 1, numberOfAreas_sqrt);
%     longitude = initLongitude + deltaDeg .* (0 : 1 : numberOfAreas_sqrt - 1);       % 各小区经度
%     longitudeOfAllAreas = repmat(longitude, numberOfAreas_sqrt, 1);
    latitude = F_calAreasLat(numberOfAreas_sqrt);       % 各小区纬度
%     latitudeOfAllAreas = repmat(latitude, 1, numberOfAreas_sqrt);
    latitudeOfAllAreas = latitude(:, :, 1);
    longitude = F_calAreasLon(latitude);       % 各小区经度
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