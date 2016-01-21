% 识别文件夹下所有图片中的数字并以矩阵形式储存
% pics: 图片的灰度值矩阵
% borderLoc: 方框所在位置
% totVesNum: 所有图片中的船舶数量矩阵
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
		% 重新排列, 观察正确性时用
% 		rowNum = length(unique(borderLoc{imIndex}(:, [1 3])));
% 		colNum = length(unique(borderLoc{imIndex}(:, [2 4])));
% 		totVesNum{imIndex} = reshape(totVesNum{imIndex}, colNum-1, rowNum-1).';
	end
end