figure(1);
recGain = reshape(recvGain_dB, 78, 78);
mesh(1:78, 79-(1:78), recGain);
xlabel('经度方向，由西向东');
ylabel('纬度方向，由南向北');
title('小区接收增益');