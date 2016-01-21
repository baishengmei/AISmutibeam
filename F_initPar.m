function F_initPar
	global Start_pos BlockLength os DecodLenth Rb TrainingLength FlagLength ...
		locSig state_all state_in state_number decision_delay Kf L BT qt ...
		Training StartFlag EndFlag RisingLength DataLength symbols ...
		next_out_diff next_state_diff terminate_diff m_diff truncate FrameLength ...
		h0 ant_num mode c transPower
	
	Start_pos = 1;				% 信号开始位置
	BlockLength = 256;			% 帧长度
	os = 4;						% 抽样白绿
	DecodLenth = 2*BlockLength;	% 解2个时隙, 含冲突信号时需修改F_singleAntDemod中的sicStartLoc
	Rb = 9600;					% 码元速率
	TrainingLength = 24;        % 同步序列24bit
	FlagLength = 8;             % 标志位长度8bit
	decision_delay = 9;			% VA判决长度
	Kf = 0.5;					% 调制系数
	L = 3;						% 高斯滤波器脉冲宽度, 单位为码元周期
	BT = 0.4;					% 带宽时延积, 此BT用于调制, 25kHz带宽设置值为0.4
	RisingLength = 8;			% 信号上升时间
	DataLength = 184;			% 数据长度
	symbols = [1 -1];			% 符号映射
	truncate = 0;				% GMSK调制的截断模式
	FrameLength = TrainingLength+FlagLength+DataLength+FlagLength+4; % frame length uncertain
	ant_num = 0;				% 天线号
	mode = 'nodiff';			% 解调是否含差分

	[gt, qt] = gauss_flt_gen(BT, Rb, os, L);	% qt高斯滤波器冲激响应积分
	
	C = zeros(1,2*L*os);
	C(L*os+1:end) = sin(pi*(0.5-qt));
	C(1:L*os) = fliplr(C(L*os+1:end));
	h0 = C(1:(L+1)*os).*C(os+1:(L+2)*os).*C(2*os+1:(L+3)*os);
	
	terminate_diff = 0;
	g_diff = 2;%[1 0]
	g_diff_feedback = 3;%[1 1]
	[k0_diff, n0_diff] = size(g_diff);
	m_diff = floor(log2(max(g_diff(:)))); % register grades
	[next_out_diff, next_state_diff, last_in_diff, last_out_diff, last_state_diff]...
		= trellis_recursive(g_diff,g_diff_feedback);
	
	Training = ones(1,TrainingLength);  % 同步序列 第一位为0
	Training(1:2:end) = 0;
	StartFlag = [0 1 1 1 1 1 1 0];      % 开始和结束标记
	EndFlag = [0 1 1 1 1 1 1 0];
	
    c = 3e8;                            %光速
    transPower = 41;                    %远海船舶发送功率
% 	if Kf == 0.5
% 		% load local synchronization signal
% 		load local_time_frequency_synchronization_signal_Delay_897_4os.mat
% 		load parameter_for_VA2_0R5Kf.mat
% 	elseif Kf == 0.25
% 		% load local synchronization signal
% 		load local_time_frequency_synchronization_signal_Delay_4os_12R5kHz.mat
% 		load parameter_for_VA2_0R25Kf.mat
% 	end
% 	locSig = local_time_frequency_synchronization_signal;
end