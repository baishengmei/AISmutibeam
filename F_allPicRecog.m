% ʶ���ļ���������ͼƬ�е����ֲ��Ծ�����ʽ����
% pics: ͼƬ�ĻҶ�ֵ����
% borderLoc: ��������λ��
% totVesNum: ����ͼƬ�еĴ�����������
%                          ------------ 13.10.12 by Z.x
function [totVesNum picSize] = F_allPicRecog(pics, numModel, borderLoc)
	numberGray = 45;
	picsNum = length(pics);
	totVesNum = cell(1, picsNum);
	picSize = zeros(length(pics), 2);
	for imIndex = 1 : 1 : length(pics)
		curPic = pics{imIndex};
		picSize(imIndex, :) = size(curPic);
		squareLoc = borderLoc{imIndex};
		squareNum = size(squareLoc, 1);
		totVesNum{imIndex} = zeros(1, size(borderLoc{imIndex}, 1));
		for sqIndex = 1 : 1 : squareNum
			imgBox = curPic(squareLoc(sqIndex,1):squareLoc(sqIndex,3), squareLoc(sqIndex,2):squareLoc(sqIndex,4));
% 				figure;imshow(imgBox);pause(0.5);close;
			totVesNum{imIndex}(sqIndex) = F_numberRecog(imgBox == numberGray, numModel);
		end
		% ��������, �۲���ȷ��ʱ��
% 		rowNum = length(unique(borderLoc{imIndex}(:, [1 3])));
% 		colNum = length(unique(borderLoc{imIndex}(:, [2 4])));
% 		totVesNum{imIndex} = reshape(totVesNum{imIndex}, colNum-1, rowNum-1).';
	end
end