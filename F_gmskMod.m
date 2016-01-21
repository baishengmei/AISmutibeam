function sig_gmsk = F_gmskMod(data, os, Rb, BT, L, Kf, truncate)
% gmsk调制, 较gmsk_mod_new函数降低了运行时间
% data: 原信号, 行向量
% os: 抽样倍率
% Rb: 码元速率
% BT: 带宽时延积
% L: 高斯滤波器点数, 一般取3即可
% Kf: 调制系数, 一般取0.5
% truncate: 调制后的截断方式, 默认为0
%                          张昕 13.9.11
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