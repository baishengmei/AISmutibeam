% 根据卫星高度计算卫星扫描区域直径, 以自组织小区为单位
% 一自组织小区直径为40海里
% sateHeight: 卫星高度
% num_state: 卫星扫描区域直径, 以自组织小区为单位
%												------2013.10.9 by Z.x
function num_state = F_calSateAreaSize(sateHeight)
	global earthR nmile2km stateSize
	angle = earthR/(earthR+sateHeight);		% 夹角余弦值
	L = earthR*acos(angle)*2;			% 扫描区域直径
	num_state = ceil(L/(stateSize*nmile2km));	% 小区横纵个数
	% 小区个数应该是以卫星为中心经纬度的奇数个
% 	num_state = num_state + (mod(num_state,2)==0);
end