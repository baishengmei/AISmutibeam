figure(1);
recGain = reshape(recvGain_dB, 78, 78);
mesh(1:78, 79-(1:78), recGain);
xlabel('���ȷ���������');
ylabel('γ�ȷ���������');
title('С����������');