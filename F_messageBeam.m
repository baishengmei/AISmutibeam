function [timeDlay_beam, timeTable_beam, aisData_beam, zeroNum_beam, realVesNum_beam] = F_messageBeam( timeDelay, timeTable, arrBeam, diameter, aisData, zeroNum )
    
    %%%%%%%%%%%%%%%����timeTable��Ϸ��С������Ƿ�����д�С����,��zeronum��ά�ȱȽ�
    aa = max(timeTable(:, 4));
    
    %   timeTable_beam
    %   С����ţ� 
    areasNo = reshape(1:1:diameter*diameter, diameter, diameter);  
    %   �㲨���ڵ�С����ţ���һ�б�ʾ����
    areasNoBeam = arrBeam .* areasNo;   %   areasNoBeam���ǵ㲨���ڵ�С��������㣻
    areasNo_beam = areasNoBeam(areasNoBeam~=0);
    
    %%   ��ȡ�㲨���ڵ�timeTable_beam
    timeTable_beam = [];    
    for temp = 1:1:size(areasNo_beam, 1)
        timeTable_temp = timeTable(all(repmat(areasNo_beam(temp),size(timeTable,1),1) == timeTable(:,1), 2), :);
        
        timeTable_beam = [timeTable_beam; timeTable_temp];
    end
%     %%  ���㲨���źŽ�������
%     [temp, index] = sort(timeTable_beam(:, 3));             % ���շ���ʱ�������֡��������
% 	timeTable_beam = timeTable_beam(index, :);        % �����д�������ʱ�����ʱ������

%%   �㲨��ʱ�Ӽ���
    areaRealNo_beam = unique(timeTable_beam(:, 4));    %   �㲨�����д�С�����
    timeDlay_beam = timeDelay(1, areaRealNo_beam');
    
    %%   ��ȡʵ�ʴ����ĸ���
    realVesNum_beam = length(unique(timeTable_beam(:, 2)));
    
    %%   ��ȡ�㲨����areaData��zeroNum
    vesNum_beam = unique(timeTable_beam(:,2)); %   �㲨���ڵĴ���
    aisData_beam = aisData(vesNum_beam, :);
    zeroNum_beam = zeroNum(vesNum_beam,:);
    %%%%%%%%%%%����timeTable��Ϸ��С������Ƿ�����д�С����,��zeronum��ά�ȱȽ�
    aa = max(timeTable_beam(:, 4)); 
    
    %%   ��timeTableС���ţ����ţ��д�С����Ű��յ㲨������������±��
    %   ��timeTable�������д�С����Ÿ�Ϊ������Χ�ڵ��д�С�����
    areasOfVess = unique(timeTable_beam(:, 4));                                                %   �㲨�����д�С�������������д�С���е��ź�
    areaOfVessNum_beam = size(areasOfVess, 1);                                                 %   �㲨�����д�С������
    areaOfVess_beam = [1:1:areaOfVessNum_beam]';    %   �㲨�����д�С���������
    areasNum = [areasOfVess, areaOfVess_beam];                                                    %   ���㲨�����д�С����������������еı�Ŷ�Ӧ����
    xx4 = timeTable_beam(:, 4);
    for nn4 = 1:1:size(xx4, 1)
        
        xx4(nn4, :) = areasNum(find(xx4(nn4, 1) == areasNum(:, 1)), 2);
    end
    timeTable_beam(:, 4) = xx4;
    %   ��timeTable��һ��С���ţ����½��б��
    xx1 = timeTable_beam(:, 1);
    areasNum_beam = size(areasNo_beam, 1);%  �㲨��������С���ĸ���
    areasQue_beam = [1:1:areasNum_beam]';%   �㲨��������С�����
    areasQue = [areasNo_beam, areasQue_beam];
    for nn1 = 1:1:size(xx1, 1)
        xx1(nn1, :) = areasQue(find(xx1(nn1, 1) == areasNo_beam(:, 1)), 2);
    end
    timeTable_beam(:, 1) = xx1;
    %   ��timeTable_beam�ڶ��д��ţ����½��б��
    xx2 = timeTable_beam(:, 2);
    vessNum_beam = size(unique(xx2), 1);%   �㲨�������д��ĸ���
    vessQue_beam = [1:1:vessNum_beam]';% �㲨�����д������
    vessQue = [unique(xx2), vessQue_beam];
    for nn2 = 1:1:size(xx2, 1)
        xx2(nn2, :) = vessQue(find(xx2(nn2, 1) == vessQue(:, 1)), 2);
    end
    timeTable_beam(:, 2) = xx2;
    %%  ���㲨���źŽ�������
    [temp, index] = sort(timeTable_beam(:, 3));             % ���շ���ʱ�������֡��������
	timeTable_beam = timeTable_beam(index, :);        % �����д�������ʱ�����ʱ������
end