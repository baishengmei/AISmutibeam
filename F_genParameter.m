function [distriMat, realVesNum] = F_genParameter(sateHeight, vesNum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ������ȷֲ�����������Ĺ��ʲƵƫ��ʱ�Ӳ��DOA.
%
% �������:
%   areas:                ��С����γ�ȼ������ֲ��������
%   satelliteSwath:       ����ɨ����
%	areaWidth:            С�����
%	satelliteAltitude:    ���Ǹ߶�
%	plotProb:             �Ƿ��Ǽ����������, �������������㹦�ʲƵƫ��DOA
% �������:
%	powDopDelayDOAOfAreas:	�д�С���ĸ���������, ��һ��Ϊ���ʲ�, �ڶ���Ϊ
%                           Ƶƫ, ������Ϊʱ�Ӳ�, ������ΪDOA
%	delayOfAreas_bit:       ����С���źŵ������ǵ�ʱ��, ��bitΪ��λ, ���������
%                           �����ʱ���ɸ�֡ʵ�ʽ���ʱ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global ModleORRand sateLat
	numOfAreas_sqrt = ceil(acos(6371/(6371+sateHeight))*6371* 2/1.852/40);    % ���㸲������ֱ��
%     if(~exist('vPath1', 'var') || isempty(vPath1))
    if ModleORRand == 0
        sateLat = -sateLat;
        distriMat = F_initRandDistri(vesNum, numOfAreas_sqrt);			% ���ɴ����ֲ�����_����
        sateLat = -sateLat;
    else
        % �Էֲ�ģ������ʱ, �߶�������Ч
        distriMat = F_initModelDistriNew(vesNum);			% ���ɴ����ֲ�����_ʵ��
    end
%     %������
%     distriMat(:, : , 1) = ones(78, 78);
%     distriMat(36, 18, 1) = 1;
%     distriMat(18, 36, 1) = 1;
%     distriMat(36, 12, 1) = 1;
%     distriMat(12, 36, 1) = 1;
    
% 	parTable = F_calAreaPar(distriMat, sateHeight);
	realVesNum = sum(sum(distriMat(:, :, 1)));
end