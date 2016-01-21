% ����С����Ŀ������γ�ȼ�������С����γ��, ����С�����ġ������ǺͶ��Ͻǵ�γ��
% num_state: С����Ŀ
% stateLat: ��С��γ��, ��һҳΪ����γ��, �ڶ�ҳΪ������γ��, ����ҳΪ���Ͻ�γ��
%                              -------2013.10.10 by Z.x

function stateLat = F_calAreasLat(num_state)
    global stateSize earthR nmile2km sateLat

    dif_angle = stateSize*nmile2km/earthR*180/pi;	% һ��С����Խ��γ��
    sateLat_NW = sateLat - dif_angle/2;				% ����������γ��
    sateLat_SE = sateLat + dif_angle/2;				% ���Ƕ��Ͻ�γ��

    stateLat = zeros(num_state, num_state, 3);
    centerState = (num_state+1)/2;					% ����С����������
    stateLatIndex = repmat((1:num_state)', 1, num_state) - centerState;
    stateLat(:, :, 1) = sateLat*ones(num_state) + dif_angle*stateLatIndex;			% ��С������γ��
    stateLat(:, :, 2) = sateLat_NW*ones(num_state) + dif_angle*stateLatIndex;		% ��С��������γ��
    stateLat(:, :, 3) = sateLat_SE*ones(num_state) + dif_angle*stateLatIndex;		% ��С�����Ͻ�γ��
end