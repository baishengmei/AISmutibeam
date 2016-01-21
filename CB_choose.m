function CB_choose(hPathEdit)
	global isRunning vPath
	if isRunning == 0
		vPath = uigetdir('.', '选择信号文件储存路径');
		if vPath ~= 0
			set(hPathEdit, 'string', vPath);
		else
			vPath = '';
		end
	end
end