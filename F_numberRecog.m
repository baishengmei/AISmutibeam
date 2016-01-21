% 识别方框内的数字
% imgBox: 图片二值矩阵
% vesNum: 方框中储存的数字
%                          ------------ 13.10.12 by Z.x
function num_out = F_numberRecog(imgBox, numModel)
	maxNumSize = 15;		% 数字的横纵像素点数范围
	maxNumPoint = 30;		% 数字像素点数最大值
	isNumThr = 8;			% 判别为数字的连续像素点阈值
	if all(imgBox(:) == 0)
		num_out = 0;
		return;
	end
	% 确定图片中各数字的范围及连通性, 需优化程序
	digPix=zeros(maxNumPoint, 2);                         % 存储单个数字像素点的行列号
	output=[];                                  % 记录识别的数据
    connectMat=[1,0;-1,0;0,1;0,-1;-1,-1;-1,1;1,-1;1,1;2,0;-2,0;0,2;0,-2;2,-2;2,2;-2,-2;-2,2;-2,-1;-2,1;-1,-2;-1,2;1,-2;
        1,2;2,-1;2,1;3,0];                      % 判断连通性伸缩数据
	boxHeight = size(imgBox, 1);
	boxWidth = size(imgBox, 2);
	is_vis = imgBox;
	num_out = 0;                       % 记录每次识别之后的数据
	for jj = 1 : 1 : boxWidth
		for ii = 1 : 1 : boxHeight
			if (is_vis(ii, jj) == 1)
				sqt = 0;
				sqh = 0;
				is_vis(ii, jj) = 0;
				numRange = [ii, ii, jj, jj];		% 数字的像素范围, 格式为最小行 最大行 最小列 最大列
				num = 1;
				sqt = sqt + 1;
				digPix(sqt, :) = [ii jj];
				while sqt - sqh > 0                            % 判断连通性
					sqh = sqh + 1;
					v = digPix(sqh, :);
					for dir_num = 1 : 1 : size(connectMat,1)
						nextV = v + connectMat(dir_num, :);
						if nextV(1)>=1 && nextV(1)<=boxHeight && nextV(2)>=1 && nextV(2)<=boxWidth
							if (is_vis(nextV(1), nextV(2)) == 1)                  % 判断定点周围的点是否是数字像素点
								is_vis(nextV(1), nextV(2)) = 0;
								sqt = sqt + 1;
								digPix(sqt, :) = nextV;
								numRange([1 3]) = min(nextV, numRange([1 3]));
								numRange([2 4]) = max(nextV, numRange([2 4]));
								num = num + 1;
							end
						end
					end
				end
				if num > isNumThr
					% 数字各行各列点数
					numRow = sum(imgBox(numRange(1):numRange(2), numRange(3):numRange(4)), 2);
					numCol = sum(imgBox(numRange(1):numRange(2), numRange(3):numRange(4))).';
					numRow = [numRow; zeros(maxNumSize-length(numRow), 1)];
					numCol = [numCol; zeros(maxNumSize-length(numCol), 1)];
					% 与模板比较
					conf = zeros(1, length(numModel));
					for num = 1 : 1 : length(numModel)
						conf(num) = sum(abs(numModel(num).row-numRow) + abs(numModel(num).col-numCol));
					end
					[confVal, vesNum] = min(conf);
					vesNum = mod(vesNum, 10);
					num_out = num_out*10 + vesNum;
				end
			end
		end
	end
% 	numRange = zeros(1, 4);		% 数字的范围, 1 2列为数字左上角的行列号, 3 4列为数字右下角的行列号
% 	pointRow = sum(imgBox, 2);
% 	pointCol = sum(imgBox).';
% 	% 确定数字的像素范围
% 	numRange(1) = find(pointRow~=0, 1);
% 	numRange(2) = find(pointCol~=0, 1);
% 	numRange(3) = find(pointRow~=0, 1, 'last');
% 	numRange(4) = find(pointCol~=0, 1, 'last');
	
end