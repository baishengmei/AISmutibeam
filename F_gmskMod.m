function sig_gmsk = F_gmskMod(data, os, Rb, BT, L, Kf, truncate)
% gmsk����, ��gmsk_mod_new��������������ʱ��
% data: ԭ�ź�, ������
% os: ��������
% Rb: ��Ԫ����
% BT: ����ʱ�ӻ�
% L: ��˹�˲�������, һ��ȡ3����
% Kf: ����ϵ��, һ��ȡ0.5
% truncate: ���ƺ�ĽضϷ�ʽ, Ĭ��Ϊ0
%                          ��� 13.9.11
	if ~exist('L', 'var')
		L = 3;
	end
	if ~exist('Kf', 'var')
		Kf = 0.5;
	end
	if ~exist('truncate', 'var')
		truncate = 0;
	end
	Tb = 1/Rb;
	B = BT/Tb;
	Fs = Rb*os;
	len = length(data);
	
	t = (-L*os/2 : 1 : L*os/2-1) / Fs;
	coef = sqrt(2/log(2))*pi*B;
	gt = 1/(4*os) * (erfc(coef*(t-Tb/2)) - erfc(coef*(t+Tb/2)));
% 		figure;
% 		plot(t, gt, '-o');grid on;
	data_high = reshape([data; zeros(os-1, len)], 1, len*os);
	phase = 2*pi*Kf*cumsum(conv(gt, data_high(1:end-os+1)));

	switch truncate
		case 0
			phase = phase((L-1)/2*os+1:(len+(L-1)/2)*os);
		case 1
			phase = phase((L-1)*os+1:(len+(L-1))*os);
		otherwise
			phase = phase((L-1)*os+1:(len+(L-1))*os);
	end
	sig_gmsk = exp(1j*phase);
end