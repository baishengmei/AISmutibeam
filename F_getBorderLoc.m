% ȷ������ͼƬ����ɫ�����λ��
% pics: ͼƬ�ĻҶ�ͼ����
% borderLoc: n*4����, ��1��2��Ϊ�������Ͻ�λ��, ��3��4��Ϊ�������½�λ��, ������Ϊ��λ
%                                 ----------- 13.10.11 by Z.x

function borderLoc = F_getBorderLoc(pics)
	borderGray = 75;				% ͼƬ�б߿�ĻҶ�
	borderRowThr = 40;				% �߿��������������
	borderColThr = 20;				% �߿���������������
	disturbThr = 5;					% �߿�ֶ�����

	picsNum = length(pics);
	borderLoc = cell(1, picsNum);
	for imIndex = 1 : 1 : picsNum
		imgGray = pics{imIndex};								% ת���ɻҶ�ͼ
		
		% ͳ��ͼƬ�лҶ�Ϊ�߿�Ҷ�ֵ������, ��ȷ���߿���кź��к�
		borderRow = find(sum(imgGray == borderGray, 2) > borderRowThr);
		borderCol = find(sum(imgGray == borderGray).' > borderColThr);
		
% 		% ȥ�����������ڱ߿��λ�������ĸ���
% 		borderRow = F_deBorderDisturb(borderRow, disturbThr);
% 		borderCol = F_deBorderDisturb(borderCol, disturbThr);
		
		borderLoc{imIndex} = zeros((length(borderRow)-1)*(length(borderCol)-1), 4);	% �߿������ָܷ����ķ�����
		% ȫ������������
		borderLoc{imIndex}(:, 1) = kron(borderRow(1:end-1), ones(length(borderCol)-1, 1));
		borderLoc{imIndex}(:, 3) = kron(borderRow(2:end), ones(length(borderCol)-1, 1));
		borderLoc{imIndex}(:, 2) = repmat(borderCol(1:end-1), length(borderRow)-1, 1);
		borderLoc{imIndex}(:, 4) = repmat(borderCol(2:end), length(borderRow)-1, 1);
		
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 		% �ӻҶ�ͼ���ڱ߿������ȷ���߿�λ��
% 		for row = 1 : 1 : length(borderRow)
% 			[startLoc endLoc] = F_findBorder(imgGray(borderRow(row), :)==borderGray);
% 		end

% 		borderLoc{imIndex} = zeros((length(borderRow)-1)*(length(borderCol)-1), 4);	% �߿������ָܷ����ķ�����
% 		num = 1;
% 		edgePointGray = imgGray(borderRow, borderCol) == borderGray;	% �߿򽻵����
% 		% ����ȷ�����߿�λ��, ֻ������ͼ�е������߿�, �Ҳ�������λ�ı�
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

		% ��ͼ��֤
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