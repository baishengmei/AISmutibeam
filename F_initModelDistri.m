function distriMat = F_initModelDistri(vesNum, N, state_EW, state_NS)
%     global vPath1
%     load(vPath1);
    N = N * (vesNum / sum(N(:)));
    N(N > 400) = 400;           % ��ֹ�������ർ�µ�ʱ϶�޷�����, �������ʱ϶���亯���������жϱ�������
    distriMat(:, :, 1) = round(N);
    distriMat(:, :, 2) = state_NS;     % ԭ����ģ�ͳ���γΪ��, �˳����б�γΪ��, ���ĳ�������޸�
    distriMat(:, :, 3) = state_EW;
end