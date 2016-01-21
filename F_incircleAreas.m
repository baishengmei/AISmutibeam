% ȡ���η�Χ������С��������Բ������Ϊ����ɨ�跶Χ
% ������Բ����Ĳ��ֵľ�γ�ȱ��ΪNaN
% mat: ��С�����Ȼ�γ�Ⱦ���, Ϊ3ά����, ����άά��Ϊ3
% matIncirc: ����Բ����, ����Բ����Ĳ��ֱ��ΪNaN
%                               ---------13.10.10 by Z.x

function matIncirc = F_incircleAreas(mat)
	num_state = size(mat, 1);
	centerState = (num_state+1) / 2;			% ����Բ�뾶, num_stateΪ����
	rowIndex = repmat((1:num_state)', 1, num_state);
	colIndex = repmat(1:num_state, num_state, 1);
	circArea = double((rowIndex-centerState).^2+(colIndex-centerState).^2 < centerState.^2);	% ����Բ�ڲ����Ϊ1
	circArea(circArea == 0) = NaN;		% ����Բ�ⲿ���ΪNaN
	circArea = repmat(circArea, [1 1 size(mat, 3)]);	% ������Բ�����չΪ��matͬά��
	matIncirc = circArea .* mat;
end