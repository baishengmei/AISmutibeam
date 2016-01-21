function CB_run(hPathEdit, hHeightEdit, hVesNumEdit, hTimeEdit, hEbNoEdit, hPathBtn, hGenBtn, hAxes)
	global isRunning isLegal vPath vHeight vVesNum vTime vPath1 hMode hPathBtn1 hPathEdit1
	if isRunning == 0
		CB_updateValue(hPathEdit, hHeightEdit, hVesNumEdit, hTimeEdit, hEbNoEdit);
		if isLegal == 1
			set(hPathEdit,'enable', 'inactive');
			set(hHeightEdit, 'enable', 'inactive');
			set(hVesNumEdit, 'enable', 'inactive');
			set(hTimeEdit, 'enable', 'inactive');
			set(hEbNoEdit, 'enable', 'inactive');
			set(hPathBtn, 'enable', 'inactive');
			set(hGenBtn, 'enable', 'inactive');
            set(hMode, 'enable', 'inactive');
			set(hPathEdit1, 'enable', 'inactive');
            set(hPathBtn1, 'enable', 'inactive');
            drawnow;
			isRunning = 1;
			% ���г���
% 			S_waitbar(0, hWaitbar, '�����źŲ���...');drawnow;
            [areas, parTable, vesNum] = F_genParameter(vHeight, vVesNum);		% areasΪ�����ֲ�����, parTableΪ������������, vesNumΪʵ�ʴ�������
% 			S_waitbar(0.1, hWaitbar, '���ɶ�������Ϣ...');drawnow;
			aisData = F_genAISData(vesNum);					% aisDataΪ���������͵Ķ�������Ϣ
% 			S_waitbar(0.3, hWaitbar, '�����ź�ʱ϶...');drawnow;
			timeTable = F_genTimeTable(areas, parTable(:, 3), vTime, vHeight);		% timeTableΪ��֡�źŵķ���ʱ��
  			F_genAISSig(aisData, parTable, timeTable, vTime, vPath, hAxes);		% ����AIS�źŲ�������vPath��
			% �ָ��༭
			set(hPathEdit, 'enable', 'on');
			set(hHeightEdit, 'enable', 'on');
			set(hVesNumEdit, 'enable', 'on');
			set(hTimeEdit, 'enable', 'on');
			set(hEbNoEdit, 'enable', 'on');
			set(hPathBtn, 'enable', 'on');
			set(hGenBtn, 'enable', 'on');
            set(hMode, 'enable', 'on');
			set(hPathEdit1, 'enable', 'on');
            set(hPathBtn1, 'enable', 'on');
            drawnow;
			isRunning = 0;
		end
    end
    
end