function aissig = F_genAISSig(areasdatazerotime, realVesNum, aisData, zeroNum, parTable, timeTable, transFrequency, obTime, resultPath)
    global vEbNo vHeight vVesNum beamNum multibeamMode
    
    % ÿ���ӵ��ź�����һ���ļ�
    slotPerMin = 2250;
    blockLen = 256;
    bufferLen = 24;
    os = 4;
    M = 1;  %   ���߸���
    cutTime = 12;
    if obTime <= cutTime
        fileNum = 1;
    else
        fileNum = ceil(obTime / cutTime);
    end
    % 	overlap = 5;		% ǰ���ļ��ص�5��ʱ϶
    overlap = 0;		% ǰ���ļ��ص�0��ʱ϶

    lastEndBit = 0;	% �ļ����bitƫ����
    if multibeamMode == 0           %�Ƕನ��ģʽ
        for ii = 1 : 1 : fileNum
            if ii ~= 1
                startLoc = endLoc - overlap + 1;
                if startLoc < size( timeTable, 1)
                    lastEndBit = timeTable(startLoc, 3) - 1;
                end
            else
                startLoc = 1;
            end
            %endLoc = find(timeTable(:, 3) >= ii * slotPerMin * cutTime / 60 * blockLen, 1);
            endLoc = find(timeTable(:, 3) >= ii * slotPerMin * cutTime / 60 * blockLen, 1) - 1;       %�ҵ�ÿһ���з��ļ�������źŵ�bitʱ�������к�
            if isempty(endLoc)
                endLoc = size(timeTable, 1);
            end
            if startLoc > size( timeTable, 1)
                curFileSigLen = (obTime - (ii -1) * cutTime) * slotPerMin / 60 * blockLen - blockLen;
                sig = zeros(M, (curFileSigLen + blockLen)*os);                           %ȷ��sig�źų���

            else
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20150502%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %curFileSigLen = timeTable(endLoc, 3) - timeTable(startLoc, 3) + 1;                 %�������һ���źź͵�һ���źŷ��ͱ���ʱ���������Ϊ����sig������׼��
                curFileSigLen = timeTable(endLoc, 3) - timeTable(startLoc, 3);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                sig = zeros(M, (curFileSigLen + blockLen)*os);                           %ȷ��sig�źų���
                for jj = startLoc : 1 : endLoc
                    % 			S_waitbar(timeTable(jj, 3) / timeTable(end, 3) * 0.7 + 0.3, hWaitbar, ...
                    % 				sprintf('�ź�����%.1f%%...', timeTable(jj, 3) / timeTable(end, 3) * 100));drawnow;
                    %             F_circleFill(timeTable(jj, 3)/timeTable(end, 3),1, hAxes);drawnow;
                    areaLoc = timeTable(jj, 4);          %���д�С���еı��
                    vesLoc = timeTable(jj, 2);          %���ʹ���
                    curPar = parTable(areaLoc, :);		% 1���� 2Ƶƫ 3ʱ�� 4doa
                    curSig = F_aisModul(aisData(vesLoc, 1:184+zeroNum(vesLoc)), ...
                        bufferLen-zeroNum(vesLoc), ...
                        curPar(1), ceil(curPar(3)*os), curPar(2), ...
                        curPar(4), M, frequency);
    %                                 curStep = (timeTable(jj, 3) - lastEndBit - 1) * os + 1;           %Ŀǰ�˷����źŵ�һbit�ڵ�ǰ�ļ��е�bit��������ʱ��
    %                                 endStep = min(curStep + blockLen * os - 1, size(sig, 2));         %Ŀǰ�˷����ź����һbit�ڵ�ǰ�ļ��е�bit��������ʱ�䣬����ʱ��
                    curStep = (timeTable(jj, 3) - timeTable(startLoc, 3)) * os + 1;           %Ŀǰ�˷����źŵ�һbit�ڵ�ǰ�ļ��е�bit��������ʱ��
                    endStep = curStep + blockLen * os - 1;         %Ŀǰ�˷����ź����һbit�ڵ�ǰ�ļ��е�bit��������ʱ�䣬����ʱ��
                    try
                        sig(:, curStep : endStep) = sig(:, curStep : endStep) + curSig(:, 1 : 1 : endStep - curStep + 1);
                    catch
                        disp('error')
                    end
                end
            end
            % ���Ӹ�˹����
            sigma = sqrt(0.5*os/10^(vEbNo/10));
            noise = sigma*randn(size(sig)) + 1j*sigma*randn(size(sig)) ;
            sig = sig + noise;

            try
                fileName = ['AISsig_', sprintf('h%d_t%d_v%d_e%d_%d', vHeight, obTime, vVesNum, vEbNo, ii), '.mat'];
                % 			fileName = sprintf('AISsig_%d.mat', ii);
                sigDirPath = [resultPath, '/' ,sprintf('h%d_t%d_v%d_e%d', vHeight, obTime, vVesNum, vEbNo)];
                mkdir(sigDirPath);
                save([sigDirPath, '/', fileName], 'sig');
            catch
                errordlg('���̿ռ䲻��', '����������Ч');
            end
        end
        dataFileName = ['AISData_', sprintf('h%d_t%d_v%d_e%d', vHeight, obTime, vVesNum, vEbNo), '.mat'];
        %dataFileName = 'AISData.mat';
        save([sigDirPath, '/', dataFileName], 'aisData', 'parTable', 'timeTable');
        aissig = sig;
    else                        %�ನ��ģʽ
        for xx = 1:1:beamNum
            transFrequencyBeam = transFrequency{xx};
            carrier_freq = transFrequencyBeam;
            %   ��ȡ�㲨���ź���Ϣ�Լ������ֲ�
            realVesNumBeam = realVesNum{xx};
            aisDataBeam = aisData{xx};
            zeroNumBeam = zeroNum{xx};
            parTableBeam = parTable{xx};
            timeTableBeam = timeTable{xx};  
            %   ������
            aa = length(unique(timeTableBeam(:,2)));
            
            for ii = 1 : 1 : fileNum
                if ii ~= 1
                    startLoc = endLoc - overlap + 1;
                    if startLoc < size( timeTableBeam, 1)
                        lastEndBit = timeTableBeam(startLoc, 3) - 1;
                    end
                else
                    startLoc = 1;
                end
                %endLoc = find(timeTable(:, 3) >= ii * slotPerMin * cutTime / 60 * blockLen, 1);
                endLoc = find(timeTableBeam(:, 3) >= ii * slotPerMin * cutTime / 60 * blockLen, 1) - 1;       %�ҵ�ÿһ���з��ļ�������źŵ�bitʱ�������к�
                if isempty(endLoc)
                    endLoc = size(timeTableBeam, 1);
                end 
                if startLoc > size( timeTableBeam, 1)
                    curFileSigLen = (obTime - (ii -1) * cutTime) * slotPerMin / 60 * blockLen - blockLen;
                    sig = zeros(M, (curFileSigLen + blockLen)*os);                           %ȷ��sig�źų���
                else
                    curFileSigLen = timeTableBeam(endLoc, 3) - timeTableBeam(startLoc, 3) + 1;                 %�������һ���źź͵�һ���źŷ��ͱ���ʱ���������Ϊ����sig������׼��
                    sig = zeros(M, (curFileSigLen + blockLen)*os);                           %ȷ��sig�źų���
                    for jj = startLoc : 1 : endLoc
                    % 			S_waitbar(timeTable(jj, 3) / timeTable(end, 3) * 0.7 + 0.3, hWaitbar, ...
                    % 				sprintf('�ź�����%.1f%%...', timeTable(jj, 3) / timeTable(end, 3) * 100));drawnow;
                    %             F_circleFill(timeTable(jj, 3)/timeTable(end, 3),1, hAxes);drawnow;
                    
                    %   ������
%                     aa = max(timeTableBeam(:, 4));
%                     bb = length(unique(timeTableBeam(:, 4)));
                    
                        areaLoc = timeTableBeam(jj, 4);          %���д�С���еı��
                        vesLoc = timeTableBeam(jj, 2);          %���ʹ���
                        curPar = parTableBeam(areaLoc, :);		% 1���� 2Ƶƫ 3ʱ�� 4doa
                        curSig = F_aisModul(aisDataBeam(vesLoc, 1:184+zeroNumBeam(vesLoc)), ...
                            bufferLen-zeroNumBeam(vesLoc), ...
                            curPar(1), ceil(curPar(3)*os), curPar(2), ...
                            curPar(4), M, carrier_freq);
    %                                 curStep = (timeTable(jj, 3) - lastEndBit - 1) * os + 1;           %Ŀǰ�˷����źŵ�һbit�ڵ�ǰ�ļ��е�bit��������ʱ��
    %                                 endStep = min(curStep + blockLen * os - 1, size(sig, 2));         %Ŀǰ�˷����ź����һbit�ڵ�ǰ�ļ��е�bit��������ʱ�䣬����ʱ��
                        curStep = (timeTableBeam(jj, 3) - timeTableBeam(startLoc, 3)) * os + 1;           %Ŀǰ�˷����źŵ�һbit�ڵ�ǰ�ļ��е�bit��������ʱ��
                        endStep = curStep + blockLen * os - 1;         %Ŀǰ�˷����ź����һbit�ڵ�ǰ�ļ��е�bit��������ʱ�䣬����ʱ��
                        try
                            sig(:, curStep : endStep) = sig(:, curStep : endStep) + curSig(:, 1 : 1 : endStep - curStep + 1);
                        catch
                            disp('error')
                        end
                    end
                end
                try
                    fileName = ['AISsig_', sprintf('h%d_t%d_v%d_v%d_e%d_%d', vHeight, obTime, vVesNum, realVesNumBeam, vEbNo, ii), '.mat']; % �㲨���ļ���
                    % 			fileName = sprintf('AISsig_%d.mat', ii);
                    sigDirPath1 = [resultPath, '/' ,sprintf('h%d_t%d_v%d_b%d_e%d', vHeight, obTime, vVesNum, beamNum, vEbNo)];   % �ನ�����ļ�����

%                     sigDirPath2 = [sigDirPath1, '/' ,sprintf('h%d_t%d_v%d_v%d_e%d', vHeight, obTime, vVesNum, realVesNumBeam, vEbNo)];   % �㲨�����ļ�����
                    mkdir(sigDirPath1);
                    save([sigDirPath1, '/', fileName], 'sig');
                catch
                    errordlg('���̿ռ䲻��', '����������Ч');
                end
            end
            dataFileName = ['AISData_', sprintf('h%d_t%d_v%d_v%d_e%d', vHeight, obTime, vVesNum, realVesNumBeam, vEbNo), '.mat'];

            %dataFileName = 'AISData.mat';
            save([sigDirPath1, '/', dataFileName], 'aisDataBeam', 'parTableBeam', 'timeTableBeam');
        end
        reservefileName = ['AISreservePara_', sprintf('h%d_t%d_v%d_b%d_e%d', vHeight, obTime, vVesNum, beamNum, vEbNo), '.mat']; %   Ԥ�������������ļ���
        save([sigDirPath1, '/', reservefileName], 'areasdatazerotime');
    end
end