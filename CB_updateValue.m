
function CB_updateValue(hPathEdit, hHeightEdit, hVesNumEdit, hTimeEdit, hEbNoEdit)
	global isRunning isLegal vPath vHeight vVesNum vTime vEbNo
	if isRunning == 0
		vPath = get(hPathEdit, 'string');
        flag = F_judgePathForm( vPath, 'OUT');
		vHeight = str2double(get(hHeightEdit, 'string'));
		if (vHeight <= 0 || vHeight > 2000) || (isnan(vHeight))
			errordlg('卫星高度范围在(1~2000)之间, 请重新输入', '参数输入无效');
		end
		vVesNum = str2double(get(hVesNumEdit, 'string'));
		if (vVesNum <= 0 || vVesNum > 5000) || (isnan(vVesNum)) || (rem(vVesNum,1) ~= 0)
			errordlg('船舶数量范围在(0~5000)之间的整数, 请重新输入', '参数输入无效');
        end
		vTime = str2double(get(hTimeEdit, 'string'));
		if (vTime < 12 || vTime > 1000) || (isnan(vTime))
			errordlg('观测时间范围在(12~1000)之间, 请重新输入', '参数输入无效');
		end
		vEbNo = str2double(get(hEbNoEdit, 'string'));
		if (vEbNo < 0 || vEbNo > 40) || (isnan(vEbNo))
			errordlg('信噪比范围在(0~40)之间, 请重新输入', '参数输入无效');
		end
		if (flag == 0) || ...
				(vHeight <= 0 || vHeight > 2000) || ...
				(vVesNum <= 0 || vVesNum > 5000) || ...
				(vTime < 12 || vTime > 1000) || ...
				(vEbNo < 0 || vEbNo > 40)||...
                (rem(vVesNum,1) ~= 0)||...
                (isnan(vTime))||...
                (isnan(vHeight))||...
                (isnan(vVesNum))||...
                (isnan(vEbNo))
			isLegal = 0;
		else
			isLegal = 1;
        end
	end
end

