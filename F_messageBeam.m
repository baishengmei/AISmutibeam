function [timeDlay_beam, timeTable_beam, aisData_beam, zeroNum_beam, realVesNum_beam] = F_messageBeam( timeDelay, timeTable, arrBeam, diameter, aisData, zeroNum )
    
    %%%%%%%%%%%%%%%测试timeTable游戏船小区编号是否等于有船小区数,与zeronum的维度比较
    aa = max(timeTable(:, 4));
    
    %   timeTable_beam
    %   小区编号； 
    areasNo = reshape(1:1:diameter*diameter, diameter, diameter);  
    %   点波束内的小区编号（用一列表示）；
    areasNoBeam = arrBeam .* areasNo;   %   areasNoBeam将非点波束内的小区编号置零；
    areasNo_beam = areasNoBeam(areasNoBeam~=0);
    
    %%   获取点波束内的timeTable_beam
    timeTable_beam = [];    
    for temp = 1:1:size(areasNo_beam, 1)
        timeTable_temp = timeTable(all(repmat(areasNo_beam(temp),size(timeTable,1),1) == timeTable(:,1), 2), :);
        
        timeTable_beam = [timeTable_beam; timeTable_temp];
    end
%     %%  将点波束信号进行排序
%     [temp, index] = sort(timeTable_beam(:, 3));             % 按照发送时间对所有帧进行排序
% 	timeTable_beam = timeTable_beam(index, :);        % 将所有船舶发送时间矩阵按时间排序

%%   点波束时延计算
    areaRealNo_beam = unique(timeTable_beam(:, 4));    %   点波束内有船小区编号
    timeDlay_beam = timeDelay(1, areaRealNo_beam');
    
    %%   获取实际船舶的个数
    realVesNum_beam = length(unique(timeTable_beam(:, 2)));
    
    %%   获取点波束的areaData、zeroNum
    vesNum_beam = unique(timeTable_beam(:,2)); %   点波束内的船号
    aisData_beam = aisData(vesNum_beam, :);
    zeroNum_beam = zeroNum(vesNum_beam,:);
    %%%%%%%%%%%测试timeTable游戏船小区编号是否等于有船小区数,与zeronum的维度比较
    aa = max(timeTable_beam(:, 4)); 
    
    %%   将timeTable小区号，船号，有船小区编号按照点波束规则进行重新编号
    %   将timeTable第四列有船小区编号改为波束范围内的有船小区编号
    areasOfVess = unique(timeTable_beam(:, 4));                                                %   点波束内有船小区，在总区域有船小区中的排号
    areaOfVessNum_beam = size(areasOfVess, 1);                                                 %   点波束内有船小区个数
    areaOfVess_beam = [1:1:areaOfVessNum_beam]';    %   点波束内有船小区单独编号
    areasNum = [areasOfVess, areaOfVess_beam];                                                    %   将点波束内有船小区编号与在总区域中的编号对应两列
    xx4 = timeTable_beam(:, 4);
    for nn4 = 1:1:size(xx4, 1)
        
        xx4(nn4, :) = areasNum(find(xx4(nn4, 1) == areasNum(:, 1)), 2);
    end
    timeTable_beam(:, 4) = xx4;
    %   将timeTable第一列小区号，重新进行编号
    xx1 = timeTable_beam(:, 1);
    areasNum_beam = size(areasNo_beam, 1);%  点波束内所有小区的个数
    areasQue_beam = [1:1:areasNum_beam]';%   点波束内所有小区编号
    areasQue = [areasNo_beam, areasQue_beam];
    for nn1 = 1:1:size(xx1, 1)
        xx1(nn1, :) = areasQue(find(xx1(nn1, 1) == areasNo_beam(:, 1)), 2);
    end
    timeTable_beam(:, 1) = xx1;
    %   将timeTable_beam第二列船号，重新进行编号
    xx2 = timeTable_beam(:, 2);
    vessNum_beam = size(unique(xx2), 1);%   点波束内所有船的个数
    vessQue_beam = [1:1:vessNum_beam]';% 点波束所有船舶编号
    vessQue = [unique(xx2), vessQue_beam];
    for nn2 = 1:1:size(xx2, 1)
        xx2(nn2, :) = vessQue(find(xx2(nn2, 1) == vessQue(:, 1)), 2);
    end
    timeTable_beam(:, 2) = xx2;
    %%  将点波束信号进行排序
    [temp, index] = sort(timeTable_beam(:, 3));             % 按照发送时间对所有帧进行排序
	timeTable_beam = timeTable_beam(index, :);        % 将所有船舶发送时间矩阵按时间排序
end