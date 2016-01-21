% ����С����Ŀ�����Ǿ�γ�ȼ�������С���ľ���, ����С�����ġ������ǺͶ��Ͻǵ�γ��
% num_state: С����Ŀ
% stateLon: ��С������
%                              -------2013.10.10 by Z.x
function stateLon = F_calAreasLon(stateLat)
global  sateLon stateSize earthR nmile2km  
	num_state = size(stateLat, 1);
	stateLon = zeros(num_state, num_state, 3);
	
	centerState = ceil((num_state+1)/2);
	r_sate_NW = earthR*cos(stateLat(centerState, centerState, 2) * pi/180);		% ��������С�������ǵĵ��������뾶
	r_sate_SE = earthR*cos(stateLat(centerState, centerState, 3) * pi/180);		% ��������С�����Ͻǵĵ��������뾶
	
	dif_angle_NW = stateSize*nmile2km/r_sate_NW*180/pi;		% ����������γ����һ��С����Խ�ľ���
	dif_angle_SE = stateSize*nmile2km/r_sate_SE*180/pi;		% ���Ƕ��Ͻ�γ����һ��С����Խ�ľ���
	
	sateLon_NW = sateLon - dif_angle_NW/2;				% �������ϽǾ���
	sateLon_SE = sateLon + dif_angle_SE/2;				% �������½Ǿ���
	
	stateLonIndex = repmat(1:num_state, num_state, 1) - centerState;
	r = earthR*cos(stateLat*pi/180);			% ��ͬγ�ȵĵ��������뾶
	dif_angleLon = stateSize*nmile2km/r*180/pi;
	stateLon(:, :, 1) = sateLon+dif_angleLon(:, :, 1).*stateLonIndex;
	stateLon(:, :, 2) = sateLon_NW+dif_angleLon(:, :, 2).*stateLonIndex;
	stateLon(:, :, 3) = sateLon_SE+dif_angleLon(:, :, 3).*stateLonIndex;
	
	stateLon = stateLon - 360*(stateLon>180) + 360*(stateLon<-180);
end