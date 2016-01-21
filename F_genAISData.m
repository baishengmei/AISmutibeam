function [data, zeroNum] = F_genAISData(vesNum)
	dataLen = 184;             % data length, including CRC bits
	crcLen = 16;
	infoLen = dataLen - crcLen;
	
	info = round(rand(vesNum, infoLen));
	% 确保不存在5连1情况, 使数据部分不用做插零操作, 避免插零过多导致信号总长度过长
	% 实际情况时这部分也应使用插零, 但仿真信号使用随机数, 不能保证位填充缓冲位数足够
	for kk = 1 : 1 : vesNum
		for ll = 1 : 1 : infoLen - 4
			if sum(info(kk, ll : 1 : ll+4)) == 5
				info(kk, ll+2) = 0;
			end
		end
	end
	
	% 增加CRC校验bit
	data = zeros(vesNum, dataLen + 4);
	zeroNum = zeros(vesNum, 1);
    for kk=1 : 1 : vesNum
        data(kk, 1:dataLen) = FCS_crc_add(info(kk, :));
	end
	
	% 对校验位插零, 实际信号对数据位也应实行该操作
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