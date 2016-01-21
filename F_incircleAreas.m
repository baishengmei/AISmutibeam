% 取方形范围的所有小区的内切圆部分作为卫星扫描范围
% 将内切圆以外的部分的经纬度标记为NaN
% mat: 各小区经度或纬度矩阵, 为3维矩阵, 第三维维度为3
% matIncirc: 内切圆部分, 内切圆以外的部分标记为NaN
%                               ---------13.10.10 by Z.x

function matIncirc = F_incircleAreas(mat)
	num_state = size(mat, 1);
	centerState = (num_state+1) / 2;			% 内切圆半径, num_state为奇数
	rowIndex = repmat((1:num_state)', 1, num_state);
	colIndex = repmat(1:num_state, num_state, 1);
	circArea = double((rowIndex-centerState).^2+(colIndex-centerState).^2 < centerState.^2);	% 内切圆内部标记为1
	circArea(circArea == 0) = NaN;		% 内切圆外部标记为NaN
	circArea = repmat(circArea, [1 1 size(mat, 3)]);	% 将内切圆标记扩展为与mat同维数
	matIncirc = circArea .* mat;
end