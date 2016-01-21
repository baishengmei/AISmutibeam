% 根据小区数目和卫星纬度计算所有小区的纬度, 包括小区中心、西北角和东南角的纬度
% num_state: 小区数目
% stateLat: 各小区纬度, 第一页为中心纬度, 第二页为西北角纬度, 第三页为东南角纬度
%                              -------2013.10.10 by Z.x

function stateLat = F_calAreasLat(num_state)
    global stateSize earthR nmile2km sateLat

    dif_angle = stateSize*nmile2km/earthR*180/pi;	% 一个小区跨越的纬度
    sateLat_NW = sateLat - dif_angle/2;				% 卫星西北角纬度
    sateLat_SE = sateLat + dif_angle/2;				% 卫星东南角纬度

    stateLat = zeros(num_state, num_state, 3);
    centerState = (num_state+1)/2;					% 中心小区横纵坐标
    stateLatIndex = repmat((1:num_state)', 1, num_state) - centerState;
    stateLat(:, :, 1) = sateLat*ones(num_state) + dif_angle*stateLatIndex;			% 各小区中心纬度
    stateLat(:, :, 2) = sateLat_NW*ones(num_state) + dif_angle*stateLatIndex;		% 各小区西北角纬度
    stateLat(:, :, 3) = sateLat_SE*ones(num_state) + dif_angle*stateLatIndex;		% 各小区东南角纬度
end