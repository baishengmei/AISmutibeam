% �������Ǹ߶ȼ�������ɨ������ֱ��, ������֯С��Ϊ��λ
% һ����֯С��ֱ��Ϊ40����
% sateHeight: ���Ǹ߶�
% num_state: ����ɨ������ֱ��, ������֯С��Ϊ��λ
%												------2013.10.9 by Z.x
function num_state = F_calSateAreaSize(sateHeight)
	global earthR nmile2km stateSize
	angle = earthR/(earthR+sateHeight);		% �н�����ֵ
	L = earthR*acos(angle)*2;			% ɨ������ֱ��
	num_state = ceil(L/(stateSize*nmile2km));	% С�����ݸ���
	% С������Ӧ����������Ϊ���ľ�γ�ȵ�������
% 	num_state = num_state + (mod(num_state,2)==0);
end