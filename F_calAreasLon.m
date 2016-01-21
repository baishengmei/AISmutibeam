% 根据小区数目和卫星经纬度计算所有小区的经度, 包括小区中心、西北角和东南角的纬度
% num_state: 小区数目
% stateLon: 各小区经度
%                              -------2013.10.10 by Z.x
function stateLon = F_calAreasLon(stateLat)
global  sateLon stateSize earthR nmile2km  
	num_state = size(stateLat, 1);
	stateLon = zeros(num_state, num_state, 3);
	
	centerState = ceil((num_state+1)/2);
	r_sate_NW = earthR*cos(stateLat(centerState, centerState, 2) * pi/180);		% 卫星所在小区西北角的地球横切面半径
	r_sate_SE = earthR*cos(stateLat(centerState, centerState, 3) * pi/180);		% 卫星所在小区东南角的地球横切面半径
	
	dif_angle_NW = stateSize*nmile2km/r_sate_NW*180/pi;		% 卫星西北角纬度上一个小区跨越的经度
	dif_angle_SE = stateSize*nmile2km/r_sate_SE*180/pi;		% 卫星东南角纬度上一个小区跨越的经度
	
	sateLon_NW = sateLon - dif_angle_NW/2;				% 卫星左上角经度
	sateLon_SE = sateLon + dif_angle_SE/2;				% 卫星右下角经度
	
	stateLonIndex = repmat(1:num_state, num_state, 1) - centerState;
	r = earthR*cos(stateLat*pi/180);			% 不同纬度的地球横切面半径
	dif_angleLon = stateSize*nmile2km/r*180/pi;
	stateLon(:, :, 1) = sateLon+dif_angleLon(:, :, 1).*stateLonIndex;
	stateLon(:, :, 2) = sateLon_NW+dif_angleLon(:, :, 2).*stateLonIndex;
	stateLon(:, :, 3) = sateLon_SE+dif_angleLon(:, :, 3).*stateLonIndex;
	
	stateLon = stateLon - 360*(stateLon>180) + 360*(stateLon<-180);
end