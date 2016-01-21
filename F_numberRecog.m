% ʶ�𷽿��ڵ�����
% imgBox: ͼƬ��ֵ����
% vesNum: �����д��������
%                          ------------ 13.10.12 by Z.x
function num_out = F_numberRecog(imgBox, numModel)
	maxNumSize = 15;		% ���ֵĺ������ص�����Χ
	maxNumPoint = 30;		% �������ص������ֵ
	isNumThr = 8;			% �б�Ϊ���ֵ��������ص���ֵ
	if all(imgBox(:) == 0)
		num_out = 0;
		return;
	end
	% ȷ��ͼƬ�и����ֵķ�Χ����ͨ��, ���Ż�����
	digPix=zeros(maxNumPoint, 2);                         % �洢�����������ص�����к�
	output=[];                                  % ��¼ʶ�������
    connectMat=[1,0;-1,0;0,1;0,-1;-1,-1;-1,1;1,-1;1,1;2,0;-2,0;0,2;0,-2;2,-2;2,2;-2,-2;-2,2;-2,-1;-2,1;-1,-2;-1,2;1,-2;
        1,2;2,-1;2,1;3,0];                      % �ж���ͨ����������
	boxHeight = size(imgBox, 1);
	boxWidth = size(imgBox, 2);
	is_vis = imgBox;
	num_out = 0;                       % ��¼ÿ��ʶ��֮�������
	for jj = 1 : 1 : boxWidth
		for ii = 1 : 1 : boxHeight
			if (is_vis(ii, jj) == 1)
				sqt = 0;
				sqh = 0;
				is_vis(ii, jj) = 0;
				numRange = [ii, ii, jj, jj];		% ���ֵ����ط�Χ, ��ʽΪ��С�� ����� ��С�� �����
				num = 1;
				sqt = sqt + 1;
				digPix(sqt, :) = [ii jj];
				while sqt - sqh > 0                            % �ж���ͨ��
					sqh = sqh + 1;
					v = digPix(sqh, :);
					for dir_num = 1 : 1 : size(connectMat,1)
						nextV = v + connectMat(dir_num, :);
						if nextV(1)>=1 && nextV(1)<=boxHeight && nextV(2)>=1 && nextV(2)<=boxWidth
							if (is_vis(nextV(1), nextV(2)) == 1)                  % �ж϶�����Χ�ĵ��Ƿ����������ص�
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
					% ���ָ��и��е���
					numRow = sum(imgBox(numRange(1):numRange(2), numRange(3):numRange(4)), 2);
					numCol = sum(imgBox(numRange(1):numRange(2), numRange(3):numRange(4))).';
					numRow = [numRow; zeros(maxNumSize-length(numRow), 1)];
					numCol = [numCol; zeros(maxNumSize-length(numCol), 1)];
					% ��ģ��Ƚ�
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
% 	numRange = zeros(1, 4);		% ���ֵķ�Χ, 1 2��Ϊ�������Ͻǵ����к�, 3 4��Ϊ�������½ǵ����к�
% 	pointRow = sum(imgBox, 2);
% 	pointCol = sum(imgBox).';
% 	% ȷ�����ֵ����ط�Χ
% 	numRange(1) = find(pointRow~=0, 1);
% 	numRange(2) = find(pointCol~=0, 1);
% 	numRange(3) = find(pointRow~=0, 1, 'last');
% 	numRange(4) = find(pointCol~=0, 1, 'last');
	
end