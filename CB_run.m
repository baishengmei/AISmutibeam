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
			% 运行程序
% 			S_waitbar(0, hWaitbar, '生成信号参数...');drawnow;
            [areas, parTable, vesNum] = F_genParameter(vHeight, vVesNum);		% areas为船舶分布矩阵, parTable为各船舶参数表, vesNum为实际船舶数量
% 			S_waitbar(0.1, hWaitbar, '生成二进制信息...');drawnow;
			aisData = F_genAISData(vesNum);					% aisData为各船舶发送的二进制信息
% 			S_waitbar(0.3, hWaitbar, '分配信号时隙...');drawnow;
			timeTable = F_genTimeTable(areas, parTable(:, 3), vTime, vHeight);		% timeTable为各帧信号的发送时间
  			F_genAISSig(aisData, parTable, timeTable, vTime, vPath, hAxes);		% 生成AIS信号并保存在vPath下
			% 恢复编辑
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