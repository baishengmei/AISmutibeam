% ��ȡ�ļ���������ͼƬ������Ҷ�ͼ����
% sourcePicDir: ͼƬ�ļ���·��
% pics: ����ͼƬ�ĻҶ�ͼ����
%                       ---------- 13.10.11 by Z.x
function pics = F_readAllPic(sourcePicDir)
	picsNum = length(dir(sourcePicDir)) - 2;		% ͼƬ����
	pics = cell(1, picsNum);
	for imIndex = 1 : 1 : picsNum
		sourcePics = ['./', sourcePicDir num2str(imIndex) '.bmp'];	% ͼƬԴ�ļ�·��
		img = imread(sourcePics);											% ��ȡͼ��
		pics{imIndex} = rgb2gray(img);											% ת���ɻҶ�ͼ
	end
end