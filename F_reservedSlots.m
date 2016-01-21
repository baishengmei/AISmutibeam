% This function assigns transmission slots to all vessels within an
% organized area
% 为一个小区内的每艘船分配传输时隙
function reserved = F_reservedSlots(NumberOfVessels, TransmissionInterval, ...
	ObservationTime)
%     tic;
%     disp('开始分配时隙');
    ReportRate = 60./TransmissionInterval;                  % 位置报告率, 即每分钟报告信息的次数
    NominalIncrement = round(2250./ReportRate);    % 计划时隙增量, 即用来表示一艘船在一帧中所占各时隙的间隔
    MaxNumberOfVessels = NominalIncrement;                  % 船的最大数量, 因为所有船采用同一传输间隔, 所以NI即船的最大数量
    TotalNumberOfSlots = round(2250.*ObservationTime./60);     % 观测时间内的时隙总数
    if NumberOfVessels <= MaxNumberOfVessels
    % 若小区内船数小于等于最大船数, 则开始为所有船分配时隙
        reserved = zeros(2, TotalNumberOfSlots);
%         reserved(1,1:TotalNumberOfSlots) = 0;               % 初始化reserved矩阵
%         reserved(2,1:TotalNumberOfSlots) = 0;
        % Assign Nominal Transmission Slots for all vessels
        % within the organized area
        for i=1:1:NumberOfVessels
%             disp('分配各发送中心时隙');
%             disp(i);
%             if i == 430
%                 disp('stop');
%             end
            occupied = 1;           % 为了进入循环做的初始化
            while occupied == 1
            % Pick (random choice) Nominal Slots for vessel #i
            % 为i号船随机选择计划时隙
%                 tic;
                FirstSlot=unidrnd(NominalIncrement);        % 在NI范围内随机均匀分配i号船的第一个时隙
                %FirstSlot = unidrnd(TotalNumberOfSlots);
                
                NominalSlot = FirstSlot .* ones(1, ceil((TotalNumberOfSlots - FirstSlot + 1) / NominalIncrement));
                if FirstSlot > NominalIncrement
                    NominalSlot(2 : 1 : end) = NominalSlot(2 : 1 : end) - (1 : 1 : length(NominalSlot) - 1) .* NominalIncrement;
                end
                
                if FirstSlot <= TotalNumberOfSlots - NominalIncrement
                    NominalSlot(2 : 1 : end) = NominalSlot(2 : 1 : end) + (1 : 1 : length(NominalSlot) - 1) .* NominalIncrement;
                end
                
%                 NominalSlot(1) = FirstSlot;                 % 计划时隙向量分配为第一个时隙
%                 
%                 Slot = FirstSlot;
%                 j = 2;
%                 while Slot > NominalIncrement
%                 % 当前时隙大于NI时, 将当前时隙减去NI???????
%                     Slot = Slot - NominalIncrement;
%                     NominalSlot(j) = Slot;
%                     j = j+1;
%                 end
%                 
%                 Slot = FirstSlot;
%                 while Slot <= (TotalNumberOfSlots - NominalIncrement)
%                 % ????
%                     Slot = Slot + NominalIncrement;
%                     NominalSlot(j) = Slot;
%                     j=j+1;
%                 end
%                 toc;
%                 
%                 tic;
%                 disp('测试发送范围是否全被占用');
                NominalSlot=sort(NominalSlot);              % 各船的计划时隙升序排列
                NominalSlot_trans = NominalSlot+2.*NominalIncrement;    % 为了保护SI_low和SI_high不越界而设置
                NumberOfNominalSlots = length(NominalSlot);                 % 传送时隙数量
                % Check if there are available slots within the Selection
                % Intervals for vessel #i
                delta_SelectionInterval = round(0.1.*NominalIncrement);
                if delta_SelectionInterval == 0
                    delta_SelectionInterval = 1;
                end
                SelectionInterval_low = NominalSlot_trans - delta_SelectionInterval;
                SelectionInterval_high = NominalSlot_trans + delta_SelectionInterval;
                occupied = 0;
                m=1;
                while (occupied == 0) & (m <= NumberOfNominalSlots)
%                     SelectionInterval_low(m) = ...
%                         NominalSlot_trans(m)-delta_SelectionInterval;
%                     SelectionInterval_high(m) = ...
%                         NominalSlot_trans(m)+delta_SelectionInterval;
                    NominalTransmissionSlot_test = SelectionInterval_low(m);
                % Check availability within Selection Interval for Nominal
                % Slot #m
                    while NominalTransmissionSlot_test <= SelectionInterval_high(m)
                        NTS_test = NominalTransmissionSlot_test -...
                            2.*NominalIncrement;
                        if NTS_test <= 0
                            NTS_test = NTS_test + TotalNumberOfSlots;
                        end
                        if NTS_test > TotalNumberOfSlots;
                            NTS_test = NTS_test - TotalNumberOfSlots;
                        end
                        if reserved(1, NTS_test) == 1;
                            NominalTransmissionSlot_test = ...
                                NominalTransmissionSlot_test + 1;
                            occupied = 1;
%                         if (reserved(1, NTS_test) == 1) & (NIS_test >0);
%                             NominalTransmissionSlot_test = ...
%                                 NominalTransmissionSlot_test + 1;
%                             occupied = 1;
                        else
                            NominalTransmissionSlot_test = ...
                                SelectionInterval_high(m) + 1;
                            occupied = 0;
                        end
                    end
                    m = m + 1;
                end
%                 toc
            end
            % Assign Nominal Transmisson Slots to vessel #i
%             tic;
%             disp('分配所有时隙');
            range = 2.*delta_SelectionInterval + 1;
            NominalTransmissionSlot_random = unidrnd(range, 1, NumberOfNominalSlots);
            
            
            NominalTransmissionSlot_trans = SelectionInterval_low + NominalTransmissionSlot_random - 1;
            NTS = NominalTransmissionSlot_trans - 2 .* NominalIncrement;
                
            index_low = find(NTS <= 0);
            NTS(index_low) = NTS(index_low) + TotalNumberOfSlots;
            index_high = find(NTS > TotalNumberOfSlots);
            NTS(index_high) = NTS(index_high) - TotalNumberOfSlots;
            
            test_occupied = reserved(1, NTS);
            reSelect = find(test_occupied == 1);
                
            while(~isempty(reSelect))
                NominalTransmissionSlot_random = unidrnd(range, 1, length(reSelect));
                NominalTransmissionSlot_trans(reSelect) = SelectionInterval_low(reSelect) + NominalTransmissionSlot_random - 1;
                NTS(reSelect) = NominalTransmissionSlot_trans(reSelect) - 2 .* NominalIncrement;
                    
                index_low = find(NTS <= 0);
                NTS(index_low) = NTS(index_low) + TotalNumberOfSlots;
                index_high = find(NTS > TotalNumberOfSlots);
                NTS(index_high) = NTS(index_high) - TotalNumberOfSlots;
                    
                test_occupied = reserved(1, NTS);
                reSelect = find(test_occupied == 1);
            end
            reserved(1, NTS) = 1;
            reserved(2, NTS) = i;
%             for m = 1:1:NumberOfNominalSlots
%                 range = 2.*delta_SelectionInterval + 1;
%                 test_occupied = 1;
%                 while test_occupied == 1
%                     NominalTransmissionSlot_random = unidrnd(range);
%                     NominalTransmissionSlot_trans(m) = ...
%                     SelectionInterval_low(m) + ...
%                     NominalTransmissionSlot_random-1;
%                     NTS = NominalTransmissionSlot_trans(m) - ...
%                     2.*NominalIncrement;
%                     if NTS <= 0
%                         NTS = NTS + TotalNumberOfSlots;
%                     end
%                     if NTS > TotalNumberOfSlots
%                         NTS = NTS - TotalNumberOfSlots;
%                     end
%                     test_occupied = reserved(1,NTS);
%                 end
%                 % Mark slot #NTS as occupied by vessel #i
%                 reserved(1,NTS) = 1;
%                 reserved(2,NTS) = i;
%             end
%             toc;
        end
    else
        fprintf('\n\n');
        fprintf('Error!! The given number of vessels is larger\n');
        fprintf('than the possible maximum number of vessels.\n\n');
        fprintf('Maximum possible number of vessels per channel\');
        fprintf('within an area is');
        fprintf('%6d', MaxNumberOfVessels);
        fprintf('\n\n');
    end
end