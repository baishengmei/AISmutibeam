function [data, zeroNum] = F_genAISData(vesNum)
	dataLen = 184;             % data length, including CRC bits
	crcLen = 16;
	infoLen = dataLen - crcLen;
	
	info = round(rand(vesNum, infoLen));
	% ȷ��������5��1���, ʹ���ݲ��ֲ������������, ���������ർ���ź��ܳ��ȹ���
	% ʵ�����ʱ�ⲿ��ҲӦʹ�ò���, �������ź�ʹ�������, ���ܱ�֤λ��仺��λ���㹻
	for kk = 1 : 1 : vesNum
		for ll = 1 : 1 : infoLen - 4
			if sum(info(kk, ll : 1 : ll+4)) == 5
				info(kk, ll+2) = 0;
			end
		end
	end
	
	% ����CRCУ��bit
	data = zeros(vesNum, dataLen + 4);
	zeroNum = zeros(vesNum, 1);
    for kk=1 : 1 : vesNum
        data(kk, 1:dataLen) = FCS_crc_add(info(kk, :));
	end
	
	% ��У��λ����, ʵ���źŶ�����λҲӦʵ�иò���
	for kk = 1 : 1 : vesNum
		ll = infoLen + 1;
		while ll <= dataLen
			if sum(data(kk, ll : 1 : ll+4)) == 5
				data(kk, ll + 5 : end) = [0, data(kk, ll + 5 : end - 1)];
				zeroNum(kk) = zeroNum(kk) + 1;
				ll = ll + 5;
			end
			ll = ll + 1;
		end
	end
end