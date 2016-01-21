% ����ʶ��������ֽ��������ֲ�ģ��
% totVesNum: ����ͼƬ��ʶ����Ĵ���
% borderLoc: ͼƬ�з����λ��
% picPos: ��ͼƬ�����ϽǺ����½Ǿ�γ��
% stateLon: ��С������
% stateLat: ��С��γ��
% vesDistriModel: �����ֲ�ģ��
% pics: �����ֲ�ͼ
%                       -------- 15.01.16 by C.z
function vesDistriModel = F_buildVesModel(totVesNum, borderLoc, picPos, picSize, stateLon, stateLat)
    global sateLat sateLon
	picPos_rad = picPos*pi/180;               %��ͼ��γ�ȽǶ�ת���ɻ���
	% ���Ұ���ɨ�跶Χ�����ͼƬ
	state_NW = [min(min(stateLon(:, :, 2))) min(min(stateLat(:, :, 2)))]*pi/180;
	state_SE = [max(max(stateLon(:, :, 2))) max(max(stateLat(:, :, 2)))]*pi/180;
	picRange = find(~(picPos_rad(:,3)<state_NW(1) | picPos_rad(:,1)>state_SE(1) | ...
		picPos_rad(:,2)>state_SE(2) | picPos_rad(:,4)<state_NW(2)));
	vesDistriModel = zeros(size(stateLon, 1), size(stateLon, 2));
	if isempty(picRange)
		% ɨ�������ڲ���ͼƬ��Χ��
		disp('ɨ��������ͼƬ��Χ��');
		return;
	end
	for imIndex = 1 : 1 : length(picRange)
		idx = picRange(imIndex);		% ͼƬ���
		curSq = borderLoc{idx};         
		curVesNum = totVesNum{idx};
		% �����޴��ķ���
		curSq(curVesNum == 0, :) = [];
		curVesNum(curVesNum == 0) = [];
		% ���������ľ�γ��
		sqLoc = zeros(size(curSq));	% 1 2��Ϊ���ϽǾ�γ��, 3 4��Ϊ���½Ǿ�γ��
		
% 		top_x=start_x + (end_x - start_x)*borderCol(q)/colSize;
% 		top_y=2*(atan(exp((1-borderRow(p)/rowSize)*log(tan(pi/4+start_y/2))+borderRow(p)*log(tan(pi/4+end_y/2))/rowSize))-pi/4); %�����̷������ϽǾ�γ��

		sqLoc(:, [2 4]) = 2*(atan(exp((1-curSq(:,[1 3])/picSize(idx,1)).*log(tan(pi/4+picPos_rad(idx,2)/2)) + ...
			curSq(:,[1 3]).*log(tan(pi/4+picPos_rad(idx,4)/2))/picSize(idx,1)))-pi/4);
		sqLoc(:, [1 3]) = picPos_rad(idx,1) + ...
			curSq(:, [2 4])/picSize(idx,2)*(picPos_rad(idx,3)-picPos_rad(idx,1));

		sqLoc = sqLoc*180/pi;
		% ����������а�����С������
		for sqIdx = 1 : 1 : size(sqLoc, 1)
			areaLoc = ...
				~(sqLoc(sqIdx,3)<stateLon(:,:,2) | sqLoc(sqIdx,1)>stateLon(:,:,3) | ...
				sqLoc(sqIdx,4)<stateLat(:,:,1) | sqLoc(sqIdx,2)>stateLat(:,:,3) | ...
				isnan(stateLon(:,:,3)) | isnan(stateLat(:,:,3)));
			areasInSq = sum(areaLoc(:));
			vesDistriModel(areaLoc) = curVesNum(sqIdx)/areasInSq;
			vesDistriModel(areaLoc) = round(vesDistriModel(areaLoc) + rand(areasInSq, 1));
		end
    end
end