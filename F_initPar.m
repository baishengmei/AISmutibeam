function F_initPar
	global Start_pos BlockLength os DecodLenth Rb TrainingLength FlagLength ...
		locSig state_all state_in state_number decision_delay Kf L BT qt ...
		Training StartFlag EndFlag RisingLength DataLength symbols ...
		next_out_diff next_state_diff terminate_diff m_diff truncate FrameLength ...
		h0 ant_num mode c transPower
	
	Start_pos = 1;				% �źſ�ʼλ��
	BlockLength = 256;			% ֡����
	os = 4;						% ��������
	DecodLenth = 2*BlockLength;	% ��2��ʱ϶, ����ͻ�ź�ʱ���޸�F_singleAntDemod�е�sicStartLoc
	Rb = 9600;					% ��Ԫ����
	TrainingLength = 24;        % ͬ������24bit
	FlagLength = 8;             % ��־λ����8bit
	decision_delay = 9;			% VA�о�����
	Kf = 0.5;					% ����ϵ��
	L = 3;						% ��˹�˲���������, ��λΪ��Ԫ����
	BT = 0.4;					% ����ʱ�ӻ�, ��BT���ڵ���, 25kHz��������ֵΪ0.4
	RisingLength = 8;			% �ź�����ʱ��
	DataLength = 184;			% ���ݳ���
	symbols = [1 -1];			% ����ӳ��
	truncate = 0;				% GMSK���ƵĽض�ģʽ
	FrameLength = TrainingLength+FlagLength+DataLength+FlagLength+4; % frame length uncertain
	ant_num = 0;				% ���ߺ�
	mode = 'nodiff';			% ����Ƿ񺬲��

	[gt, qt] = gauss_flt_gen(BT, Rb, os, L);	% qt��˹�˲����弤��Ӧ����
	
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
	
	Training = ones(1,TrainingLength);  % ͬ������ ��һλΪ0
	Training(1:2:end) = 0;
	StartFlag = [0 1 1 1 1 1 1 0];      % ��ʼ�ͽ������
	EndFlag = [0 1 1 1 1 1 1 0];
	
    c = 3e8;                            %����
    transPower = 41;                    %Զ���������͹���
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