function sig = F_aisModul(data, buffer, pow, delay, doppler, DoA, M, frequency)
% ----
% �˺����Զ�������Ϣ����AIS����, ��NRZI���롢GMSK���Ʋ������ź�Ƶƫ�ͷ�ֵ
% ����:
%	data:��������Ϣ����
%	delay:�ź�ʱ��
%	doppler:�ź�Ƶƫ
%	h:�ŵ���Ӧ��ֵ
%	buffer:����������
% ���:
%	sig:AIS�ź�
% ----
	if ~exist('delay', 'var')
		delay = 0;
	end
	if ~exist('doppler', 'var')
		doppler = 0;
	end
	global symbols next_out_diff next_state_diff m_diff terminate_diff ...
		RisingLength os Rb BT L Kf truncate Training StartFlag EndFlag
	
% 	symbols = [1 -1];			% ����ӳ��
% 	next_out_diff = initPar.next_out_diff;
% 	next_state_diff = initPar.next_state_diff;
% 	m_diff = initPar.m_diff;
% 	terminate_diff = initPar.terminate_diff;
% 	
% 	RisingLength = 8;			% �ź�����ʱ��
% 	os = 4;						% ��������
% 	Rb = 9600;					% ��Ԫ����
% 	Kf = 0.5;					% ����ϵ��
% 	L = 3;						% ��˹�˲���������, ��λΪ��Ԫ����
% 	BT = 0.4;					% ����ʱ�ӻ�, ��BT���ڵ���, 25kHz��������ֵΪ0.4
% 	truncate = 0;				% GMSK���ƵĽض�ģʽ
% 	TrainingLength = 24;
% 	Training = ones(1,TrainingLength);  % ͬ������ ��һλΪ0
% 	Training(1:2:end) = 0;
% 	StartFlag = [0 1 1 1 1 1 1 0];      % ��ʼ�ͽ������
% 	EndFlag = [0 1 1 1 1 1 1 0];
	
	%%
	data = [Training, StartFlag, data, EndFlag];
	% NRZI����
	data_r = 1 - data;
	% differential encoder
	data_diff_r = encode_trellis(data_r, next_out_diff, next_state_diff, ...
		m_diff, terminate_diff);
	% NRZI
	sym_nrzi_r = symbols(data_diff_r + 1);
	% GMSK����
	sig_gmsk_r = F_gmskMod(sym_nrzi_r, os, Rb, BT, L, Kf, truncate);
	sig_gmsk_ext_r = [zeros(1,RisingLength*os), sig_gmsk_r, zeros(1,buffer*os)];	% �����ź�������
	% ����Ƶƫ
	t = (delay + (0 : length(sig_gmsk_ext_r) - 1)) / os / Rb;
	CarrierOffset = exp(1j * 2 * pi * doppler * t);
	% ���㹦�ʺ�doaӰ��
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