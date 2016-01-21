% 确定所有图片中绿色方框的位置
% pics: 图片的灰度图矩阵
% borderLoc: n*4矩阵, 第1、2列为方框左上角位置, 第3、4列为方框右下角位置, 以像素为单位
%                                 ----------- 13.10.11 by Z.x

function borderLoc = F_getBorderLoc(pics)
	borderGray = 75;				% 图片中边框的灰度
	borderRowThr = 40;				% 边框横向像素数门限
	borderColThr = 20;				% 边框纵向像素数门限
	disturbThr = 5;					% 边框粗度门限

	picsNum = length(pics);
	borderLoc = cell(1, picsNum);
	for imIndex = 1 : 1 : picsNum
		imgGray = pics{imIndex};								% 转换成灰度图
		
		% 统计图片中灰度为边框灰度值的数量, 并确定边框的行号和列号
		borderRow = find(sum(imgGray == borderGray, 2) > borderRowThr);
		borderCol = find(sum(imgGray == borderGray).' > borderColThr);
		
% 		% 去除行列中由于边框错位而产生的干扰
% 		borderRow = F_deBorderDisturb(borderRow, disturbThr);
% 		borderCol = F_deBorderDisturb(borderCol, disturbThr);
		
		borderLoc{imIndex} = zeros((length(borderRow)-1)*(length(borderCol)-1), 4);	% 边框最多可能分隔出的方框数
		% 全部方框可能组合
		borderLoc{imIndex}(:, 1) = kron(borderRow(1:end-1), ones(length(borderCol)-1, 1));
		borderLoc{imIndex}(:, 3) = kron(borderRow(2:end), ones(length(borderCol)-1, 1));
		borderLoc{imIndex}(:, 2) = repmat(borderCol(1:end-1), length(borderRow)-1, 1);
		borderLoc{imIndex}(:, 4) = repmat(borderCol(2:end), length(borderRow)-1, 1);
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		% 从灰度图存在边框的行中确定边框位置
% 		for row = 1 : 1 : length(borderRow)
% 			[startLoc endLoc] = F_findBorder(imgGray(borderRow(row), :)==borderGray);
% 		end

% 		borderLoc{imIndex} = zeros((length(borderRow)-1)*(length(borderCol)-1), 4);	% 边框最多可能分隔出的方框数
% 		num = 1;
% 		edgePointGray = imgGray(borderRow, borderCol) == borderGray;	% 边框交点矩阵
% 		% 大致确定各边框位置, 只考虑了图中的完整边框, 且不消除错位的边
% 		for row = 1 : 1 : length(borderRow)-1
% 			col = find(edgePointGray(row, :) == 1);
% 			for colIndex = 1 : 1 : length(col)-1
% 				existLineDown = all(imgGray(borderRow(row):borderRow(row+1), borderCol(col(colIndex))) == borderGray);
% 				existLineRight = all(imgGray(borderRow(row), borderCol(col(colIndex)):borderCol(col(colIndex+1))) == borderGray);
% % 				squarePoint = edgePointGray(row:row+1, col(colIndex):col(colIndex)+1);
% 				if existLineDown && existLineRight
% 					borderLoc{imIndex}(num, [1 3]) = borderRow([row row+1]);
% 					borderLoc{imIndex}(num, [2 4]) = borderCol([col(colIndex) col(colIndex)+1]);
% 					num = num + 1;
% 				end
% 			end
% 		end
% 		borderLoc{imIndex}(num:end, :) = [];

		% 画图验证
% 		if imIndex>=1 && imIndex <= 5
% 			imgShow = zeros(size(imgGray));
% 			for ii = 1 : 1 : size(borderLoc{imIndex}, 1)
% 				imgShow(borderLoc{imIndex}(ii, 1):borderLoc{imIndex}(ii, 3), borderLoc{imIndex}(ii, 2):borderLoc{imIndex}(ii, 4)) = 1;
% 			end
% 			figure;
% 			imshow(imgShow);
% 		end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	end
end