function S_changeLogo(h, filename)
	if nargin < 2
		error('MATLAB: changeLogo: Too few input argument!');
	end
	if nargin > 2
		error('MATLAB: changeLogo: Too many input argument!');
	end
	newIcon = javax.swing.ImageIcon(filename);
	javaFrame = get(h, 'JavaFrame');
	javaFrame.setFigureIcon(newIcon);
end