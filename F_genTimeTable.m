function allVesselsSendBit = F_genTimeTable(areas, obTime, sateAlt)
	transInterval = 12;
	numberOfAreas = size(areas, 1) * size(areas, 2);        % С������
	areasInLine = reshape(areas, 1, numberOfAreas, 3);      % ������ʽ�����С����Ϣ, ����ͳ�Ʒ���
	areasWithVessels = find(areasInLine(1, :, 1));          % ���ڴ���С�����
	vesselNumberOfAreas = areasInLine(1, areasWithVessels, 1);  % �д�С��������
    
    delayDiffOfAreas = cal_timeDelay(areas);
	delayOfAreas = delayDiffOfAreas + 9600*sateAlt*1e3/3e8;

	loc = 1;
	totalVesselsBefore = 0;         % �Ѿ�������Ϣ�Ĵ���
	allVesselsSendBit = zeros(floor(sum(vesselNumberOfAreas)) * floor(obTime ...
		/ transInterval), 4);        % 1ΪС�����, 2Ϊ����, 3Ϊ����ʱ��, 4Ϊ���д�С���еı��
	for ii = 1 : 1 : length(areasWithVessels)
		slotTabOfCurArea = F_reservedSlots(vesselNumberOfAreas(ii), transInterval, ...
			obTime);       % Ϊ��ǰС���и��Ҵ�������䷢��ʱ϶
		%         fprintf('С����:%d\n', ii);
		transSlot = find(slotTabOfCurArea(1, :));                     % ��ǰ����ռ�õ�ʱ϶
		slotTabOfCurArea(2, transSlot) = slotTabOfCurArea(2, transSlot) + totalVesselsBefore;       % ����С�����������Ĵ��Ÿ�Ϊȫ�������
		sendBitOfCurArea = (transSlot - 1) * 256 + ceil(delayOfAreas(ii));   % ��ǰ��������֡���;���bitʱ��

		allVesselsSendBit(loc : loc + length(transSlot) - 1, 1) = areasWithVessels(ii);                % ��¼����С���ı��
		allVesselsSendBit(loc : loc + length(transSlot) - 1, 2) = slotTabOfCurArea(2, transSlot);     % ��¼���ʹ���
		allVesselsSendBit(loc : loc + length(transSlot) - 1, 3) = sendBitOfCurArea;                   % ��¼����ʱ��
		allVesselsSendBit(loc : loc + length(transSlot) - 1, 4) = ii;                                  % ��¼���д�С���еı��

		totalVesselsBefore = totalVesselsBefore + vesselNumberOfAreas(ii);   % ��ͳ�ƵĴ���
		loc = loc + length(transSlot);
	end
	[temp, index] = sort(allVesselsSendBit(:, 3));             % ���շ���ʱ�������֡��������
	allVesselsSendBit = allVesselsSendBit(index, :);        % �����д�������ʱ�����ʱ������
    %����timeTable���д�С������Ƿ�����д�С����
%     aa = max(allVesselsSendBit(:, 4));
    
end
