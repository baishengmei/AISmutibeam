function CB_choose(hPathEdit)
	global isRunning vPath
	if isRunning == 0
		vPath = uigetdir('.', 'ѡ���ź��ļ�����·��');
		if vPath ~= 0
			set(hPathEdit, 'string', vPath);
		else
			vPath = '';
		end
	end
end