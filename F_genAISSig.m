function aissig = F_genAISSig(areasdatazerotime, realVesNum, aisData, zeroNum, parTable, timeTable, transFrequency, obTime, resultPath)
    global vEbNo vHeight vVesNum beamNum multibeamMode
    
    % 每分钟的信号生成一个文件
    slotPerMin = 2250;
    blockLen = 256;
    bufferLen = 24;
    os = 4;
    M = 1;  %   天线个数
    cutTime = 12;
    if obTime <= cutTime
        fileNum = 1;
    else
        fileNum = ceil(obTime / cutTime);
    end
    % 	overlap = 5;		% 前后文件重叠5个时隙
    overlap = 0;		% 前后文件重叠0个时隙

    lastEndBit = 0;	% 文件相对bit偏移量
    if multibeamMode == 0           %非多波束模式
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
            endLoc = find(timeTable(:, 3) >= ii * slotPerMin * cutTime / 60 * blockLen, 1) - 1;       %找到每一个切分文件最后发送信号的bit时间所在行号
            if isempty(endLoc)
                endLoc = size(timeTable, 1);
            end
            if startLoc > size( timeTable, 1)
                curFileSigLen = (obTime - (ii -1) * cutTime) * slotPerMin / 60 * blockLen - blockLen;
                sig = zeros(M, (curFileSigLen + blockLen)*os);                           %确定sig信号长度

            else
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%20150502%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                %curFileSigLen = timeTable(endLoc, 3) - timeTable(startLoc, 3) + 1;                 %发送最后一个信号和第一个信号发送比特时间差（间隔），为产生sig长度做准备
                curFileSigLen = timeTable(endLoc, 3) - timeTable(startLoc, 3);
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                sig = zeros(M, (curFileSigLen + blockLen)*os);                           %确定sig信号长度
                for jj = startLoc : 1 : endLoc
                    % 			S_waitbar(timeTable(jj, 3) / timeTable(end, 3) * 0.7 + 0.3, hWaitbar, ...
                    % 				sprintf('信号生成%.1f%%...', timeTable(jj, 3) / timeTable(end, 3) * 100));drawnow;
                    %             F_circleFill(timeTable(jj, 3)/timeTable(end, 3),1, hAxes);drawnow;
                    areaLoc = timeTable(jj, 4);          %在有船小区中的编号
                    vesLoc = timeTable(jj, 2);          %发送船号
                    curPar = parTable(areaLoc, :);		% 1功率 2频偏 3时延 4doa
                    curSig = F_aisModul(aisData(vesLoc, 1:184+zeroNum(vesLoc)), ...
                        bufferLen-zeroNum(vesLoc), ...
                        curPar(1), ceil(curPar(3)*os), curPar(2), ...
                        curPar(4), M, frequency);
    %                                 curStep = (timeTable(jj, 3) - lastEndBit - 1) * os + 1;           %目前此发送信号第一bit在当前文件中的bit（采样后）时间
    %                                 endStep = min(curStep + blockLen * os - 1, size(sig, 2));         %目前此发送信号最后一bit在当前文件中的bit（采样后）时间，考虑时延
                    curStep = (timeTable(jj, 3) - timeTable(startLoc, 3)) * os + 1;           %目前此发送信号第一bit在当前文件中的bit（采样后）时间
                    endStep = curStep + blockLen * os - 1;         %目前此发送信号最后一bit在当前文件中的bit（采样后）时间，考虑时延
                    try
                        sig(:, curStep : endStep) = sig(:, curStep : endStep) + curSig(:, 1 : 1 : endStep - curStep + 1);
                    catch
                        disp('error')
                    end
                end
            end
            % 增加高斯噪声
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
                errordlg('磁盘空间不足', '参数输入无效');
            end
        end
        dataFileName = ['AISData_', sprintf('h%d_t%d_v%d_e%d', vHeight, obTime, vVesNum, vEbNo), '.mat'];
        %dataFileName = 'AISData.mat';
        save([sigDirPath, '/', dataFileName], 'aisData', 'parTable', 'timeTable');
        aissig = sig;
    else                        %多波束模式
        for xx = 1:1:beamNum
            transFrequencyBeam = transFrequency{xx};
            carrier_freq = transFrequencyBeam;
            %   获取点波束信号信息以及参数分布
            realVesNumBeam = realVesNum{xx};
            aisDataBeam = aisData{xx};
            zeroNumBeam = zeroNum{xx};
            parTableBeam = parTable{xx};
            timeTableBeam = timeTable{xx};  
            %   测试用
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
                endLoc = find(timeTableBeam(:, 3) >= ii * slotPerMin * cutTime / 60 * blockLen, 1) - 1;       %找到每一个切分文件最后发送信号的bit时间所在行号
                if isempty(endLoc)
                    endLoc = size(timeTableBeam, 1);
                end 
                if startLoc > size( timeTableBeam, 1)
                    curFileSigLen = (obTime - (ii -1) * cutTime) * slotPerMin / 60 * blockLen - blockLen;
                    sig = zeros(M, (curFileSigLen + blockLen)*os);                           %确定sig信号长度
                else
                    curFileSigLen = timeTableBeam(endLoc, 3) - timeTableBeam(startLoc, 3) + 1;                 %发送最后一个信号和第一个信号发送比特时间差（间隔），为产生sig长度做准备
                    sig = zeros(M, (curFileSigLen + blockLen)*os);                           %确定sig信号长度
                    for jj = startLoc : 1 : endLoc
                    % 			S_waitbar(timeTable(jj, 3) / timeTable(end, 3) * 0.7 + 0.3, hWaitbar, ...
                    % 				sprintf('信号生成%.1f%%...', timeTable(jj, 3) / timeTable(end, 3) * 100));drawnow;
                    %             F_circleFill(timeTable(jj, 3)/timeTable(end, 3),1, hAxes);drawnow;
                    
                    %   测试用
%                     aa = max(timeTableBeam(:, 4));
%                     bb = length(unique(timeTableBeam(:, 4)));
                    
                        areaLoc = timeTableBeam(jj, 4);          %在有船小区中的编号
                        vesLoc = timeTableBeam(jj, 2);          %发送船号
                        curPar = parTableBeam(areaLoc, :);		% 1功率 2频偏 3时延 4doa
                        curSig = F_aisModul(aisDataBeam(vesLoc, 1:184+zeroNumBeam(vesLoc)), ...
                            bufferLen-zeroNumBeam(vesLoc), ...
                            curPar(1), ceil(curPar(3)*os), curPar(2), ...
                            curPar(4), M, carrier_freq);
    %                                 curStep = (timeTable(jj, 3) - lastEndBit - 1) * os + 1;           %目前此发送信号第一bit在当前文件中的bit（采样后）时间
    %                                 endStep = min(curStep + blockLen * os - 1, size(sig, 2));         %目前此发送信号最后一bit在当前文件中的bit（采样后）时间，考虑时延
                        curStep = (timeTableBeam(jj, 3) - timeTableBeam(startLoc, 3)) * os + 1;           %目前此发送信号第一bit在当前文件中的bit（采样后）时间
                        endStep = curStep + blockLen * os - 1;         %目前此发送信号最后一bit在当前文件中的bit（采样后）时间，考虑时延
                        try
                            sig(:, curStep : endStep) = sig(:, curStep : endStep) + curSig(:, 1 : 1 : endStep - curStep + 1);
                        catch
                            disp('error')
                        end
                    end
                end
                try
                    fileName = ['AISsig_', sprintf('h%d_t%d_v%d_v%d_e%d_%d', vHeight, obTime, vVesNum, realVesNumBeam, vEbNo, ii), '.mat']; % 点波束文件名
                    % 			fileName = sprintf('AISsig_%d.mat', ii);
                    sigDirPath1 = [resultPath, '/' ,sprintf('h%d_t%d_v%d_b%d_e%d', vHeight, obTime, vVesNum, beamNum, vEbNo)];   % 多波束的文件夹名

%                     sigDirPath2 = [sigDirPath1, '/' ,sprintf('h%d_t%d_v%d_v%d_e%d', vHeight, obTime, vVesNum, realVesNumBeam, vEbNo)];   % 点波束的文件夹名
                    mkdir(sigDirPath1);
                    save([sigDirPath1, '/', fileName], 'sig');
                catch
                    errordlg('磁盘空间不足', '参数输入无效');
                end
            end
            dataFileName = ['AISData_', sprintf('h%d_t%d_v%d_v%d_e%d', vHeight, obTime, vVesNum, realVesNumBeam, vEbNo), '.mat'];

            %dataFileName = 'AISData.mat';
            save([sigDirPath1, '/', dataFileName], 'aisDataBeam', 'parTableBeam', 'timeTableBeam');
        end
        reservefileName = ['AISreservePara_', sprintf('h%d_t%d_v%d_b%d_e%d', vHeight, obTime, vVesNum, beamNum, vEbNo), '.mat']; %   预留参数变量的文件名
        save([sigDirPath1, '/', reservefileName], 'areasdatazerotime');
    end
end