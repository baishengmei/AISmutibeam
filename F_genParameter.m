function [distriMat, realVesNum] = F_genParameter(sateHeight, vesNum)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 随机均匀分布计算各船舶的功率差、频偏、时延差和DOA.
%
% 输入参数:
%   areas:                各小区经纬度及船舶分布情况矩阵
%   satelliteSwath:       卫星扫描宽度
%	areaWidth:            小区宽度
%	satelliteAltitude:    卫星高度
%	plotProb:             是否是计算概率所用, 如果是则无需计算功率差、频偏和DOA
% 输出参数:
%	powDopDelayDOAOfAreas:	有船小区的各参数矩阵, 第一列为功率差, 第二列为
%                           频偏, 第三列为时延差, 第四列为DOA
%	delayOfAreas_bit:       所有小区信号到达卫星的时延, 以bit为单位, 用来计算检
%                           测概率时生成各帧实际接收时间
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    global ModleORRand sateLat
	numOfAreas_sqrt = ceil(acos(6371/(6371+sateHeight))*6371* 2/1.852/40);    % 计算覆盖区域直径
%     if(~exist('vPath1', 'var') || isempty(vPath1))
    if ModleORRand == 0
        sateLat = -sateLat;
        distriMat = F_initRandDistri(vesNum, numOfAreas_sqrt);			% 生成船舶分布矩阵_均匀
        sateLat = -sateLat;
    else
        % 以分布模型生成时, 高度输入无效
        distriMat = F_initModelDistriNew(vesNum);			% 生成船舶分布矩阵_实际
    end
%     %测试用
%     distriMat(:, : , 1) = ones(78, 78);
%     distriMat(36, 18, 1) = 1;
%     distriMat(18, 36, 1) = 1;
%     distriMat(36, 12, 1) = 1;
%     distriMat(12, 36, 1) = 1;
    
% 	parTable = F_calAreaPar(distriMat, sateHeight);
	realVesNum = sum(sum(distriMat(:, :, 1)));
end