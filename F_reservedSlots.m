% This function assigns transmission slots to all vessels within an
% organized area
% Ϊһ��С���ڵ�ÿ�Ҵ����䴫��ʱ϶
function reserved = F_reservedSlots(NumberOfVessels, TransmissionInterval, ...
	ObservationTime)
%     tic;
%     disp('��ʼ����ʱ϶');
    ReportRate = 60./TransmissionInterval;                  % λ�ñ�����, ��ÿ���ӱ�����Ϣ�Ĵ���
    NominalIncrement = round(2250./ReportRate);    % �ƻ�ʱ϶����, ��������ʾһ�Ҵ���һ֡����ռ��ʱ϶�ļ��
    MaxNumberOfVessels = NominalIncrement;                  % �����������, ��Ϊ���д�����ͬһ������, ����NI�������������
    TotalNumberOfSlots = round(2250.*ObservationTime./60);     % �۲�ʱ���ڵ�ʱ϶����
    if NumberOfVessels <= MaxNumberOfVessels
    % ��С���ڴ���С�ڵ��������, ��ʼΪ���д�����ʱ϶
        reserved = zeros(2, TotalNumberOfSlots);
%         reserved(1,1:TotalNumberOfSlots) = 0;               % ��ʼ��reserved����
%         reserved(2,1:TotalNumberOfSlots) = 0;
        % Assign Nominal Transmission Slots for all vessels
        % within the organized area
        for i=1:1:NumberOfVessels
%             disp('�������������ʱ϶');
%             disp(i);
%             if i == 430
%                 disp('stop');
%             end
            occupied = 1;           % Ϊ�˽���ѭ�����ĳ�ʼ��
            while occupied == 1
            % Pick (random choice) Nominal Slots for vessel #i
            % Ϊi�Ŵ����ѡ��ƻ�ʱ϶
%                 tic;
                FirstSlot=unidrnd(NominalIncrement);        % ��NI��Χ��������ȷ���i�Ŵ��ĵ�һ��ʱ϶
                %FirstSlot = unidrnd(TotalNumberOfSlots);
                
                NominalSlot = FirstSlot .* ones(1, ceil((TotalNumberOfSlots - FirstSlot + 1) / NominalIncrement));
                if FirstSlot > NominalIncrement
                    NominalSlot(2 : 1 : end) = NominalSlot(2 : 1 : end) - (1 : 1 : length(NominalSlot) - 1) .* NominalIncrement;
                end
                
                if FirstSlot <= TotalNumberOfSlots - NominalIncrement
                    NominalSlot(2 : 1 : end) = NominalSlot(2 : 1 : end) + (1 : 1 : length(NominalSlot) - 1) .* NominalIncrement;
                end
                
%                 NominalSlot(1) = FirstSlot;                 % �ƻ�ʱ϶��������Ϊ��һ��ʱ϶
%                 
%                 Slot = FirstSlot;
%                 j = 2;
%                 while Slot > NominalIncrement
%                 % ��ǰʱ϶����NIʱ, ����ǰʱ϶��ȥNI???????
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
%                 disp('���Է��ͷ�Χ�Ƿ�ȫ��ռ��');
                NominalSlot=sort(NominalSlot);              % �����ļƻ�ʱ϶��������
                NominalSlot_trans = NominalSlot+2.*NominalIncrement;    % Ϊ�˱���SI_low��SI_high��Խ�������
                NumberOfNominalSlots = length(NominalSlot);                 % ����ʱ϶����
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
%             disp('��������ʱ϶');
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