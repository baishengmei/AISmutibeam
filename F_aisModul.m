function sig = F_aisModul(data, buffer, pow, delay, doppler, DoA, M, frequency)
% ----
% 此函数对二进制信息进行AIS调制, 含NRZI编码、GMSK调制并增加信号频偏和幅值
% 输入:
%	data:二进制信息序列
%	delay:信号时延
%	doppler:信号频偏
%	h:信道响应幅值
%	buffer:缓冲区长度
% 输出:
%	sig:AIS信号
% ----
	if ~exist('delay', 'var')
		delay = 0;
	end
	if ~exist('doppler', 'var')
		doppler = 0;
	end
	global symbols next_out_diff next_state_diff m_diff terminate_diff ...
		RisingLength os Rb BT L Kf truncate Training StartFlag EndFlag
	
% 	symbols = [1 -1];			% 符号映射
% 	next_out_diff = initPar.next_out_diff;
% 	next_state_diff = initPar.next_state_diff;
% 	m_diff = initPar.m_diff;
% 	terminate_diff = initPar.terminate_diff;
% 	
% 	RisingLength = 8;			% 信号上升时间
% 	os = 4;						% 抽样白绿
% 	Rb = 9600;					% 码元速率
% 	Kf = 0.5;					% 调制系数
% 	L = 3;						% 高斯滤波器脉冲宽度, 单位为码元周期
% 	BT = 0.4;					% 带宽时延积, 此BT用于调制, 25kHz带宽设置值为0.4
% 	truncate = 0;				% GMSK调制的截断模式
% 	TrainingLength = 24;
% 	Training = ones(1,TrainingLength);  % 同步序列 第一位为0
% 	Training(1:2:end) = 0;
% 	StartFlag = [0 1 1 1 1 1 1 0];      % 开始和结束标记
% 	EndFlag = [0 1 1 1 1 1 1 0];
	
	%%
	data = [Training, StartFlag, data, EndFlag];
	% NRZI编码
	data_r = 1 - data;
	% differential encoder
	data_diff_r = encode_trellis(data_r, next_out_diff, next_state_diff, ...
		m_diff, terminate_diff);
	% NRZI
	sym_nrzi_r = symbols(data_diff_r + 1);
	% GMSK调制
	sig_gmsk_r = F_gmskMod(sym_nrzi_r, os, Rb, BT, L, Kf, truncate);
	sig_gmsk_ext_r = [zeros(1,RisingLength*os), sig_gmsk_r, zeros(1,buffer*os)];	% 增加信号上升沿
	% 增加频偏
	t = (delay + (0 : length(sig_gmsk_ext_r) - 1)) / os / Rb;
	CarrierOffset = exp(1j * 2 * pi * doppler * t);
	% 计算功率和doa影响
% 	carrier_freq = 162 * 1e6; % Hz
    carrier_freq = frequency;
    lambda = 3 * 1e8 / carrier_freq;
    ant_distance = lambda;
    DoA = DoA * pi / 180;
    rand_phase = 2 * pi * rand;
    phase_offset = 2*pi*(0:M-1).' * ant_distance * sin(DoA) / lambda;
    phase_all = repmat(rand_phase,M,1) + phase_offset;
    H = repmat(10 .^ (pow/10), M, 1) .* exp(1j * phase_all);
	
	sig = H * CarrierOffset .* repmat(sig_gmsk_ext_r, M, 1);
end