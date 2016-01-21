% 读取文件夹下所有图片并储存灰度图矩阵
% sourcePicDir: 图片文件夹路径
% pics: 所有图片的灰度图矩阵
%                       ---------- 13.10.11 by Z.x
function pics = F_readAllPic(sourcePicDir)
	picsNum = length(dir(sourcePicDir)) - 2;		% 图片总数
	pics = cell(1, picsNum);
	for imIndex = 1 : 1 : picsNum
		sourcePics = ['./', sourcePicDir num2str(imIndex) '.bmp'];	% 图片源文件路径
		img = imread(sourcePics);											% 读取图像
		pics{imIndex} = rgb2gray(img);											% 转换成灰度图
	end
end