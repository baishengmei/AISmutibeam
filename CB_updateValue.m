
function CB_updateValue(hPathEdit, hHeightEdit, hVesNumEdit, hTimeEdit, hEbNoEdit)
	global isRunning isLegal vPath vHeight vVesNum vTime vEbNo
	if isRunning == 0
		vPath = get(hPathEdit, 'string');
        flag = F_judgePathForm( vPath, 'OUT');
		vHeight = str2double(get(hHeightEdit, 'string'));
		if (vHeight <= 0 || vHeight > 2000) || (isnan(vHeight))
			errordlg('���Ǹ߶ȷ�Χ��(1~2000)֮��, ����������', '����������Ч');
		end
		vVesNum = str2double(get(hVesNumEdit, 'string'));
		if (vVesNum <= 0 || vVesNum > 5000) || (isnan(vVesNum)) || (rem(vVesNum,1) ~= 0)
			errordlg('����������Χ��(0~5000)֮�������, ����������', '����������Ч');
        end
		vTime = str2double(get(hTimeEdit, 'string'));
		if (vTime < 12 || vTime > 1000) || (isnan(vTime))
			errordlg('�۲�ʱ�䷶Χ��(12~1000)֮��, ����������', '����������Ч');
		end
		vEbNo = str2double(get(hEbNoEdit, 'string'));
		if (vEbNo < 0 || vEbNo > 40) || (isnan(vEbNo))
			errordlg('����ȷ�Χ��(0~40)֮��, ����������', '����������Ч');
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

