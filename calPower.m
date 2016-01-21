function power = ...
    calPower(transPower, sateAnglesOnVes, distance_vesSate, vector_SatToArea,  transFrequency, sateThriftAngle, coordinateBeforeThrift)
%这个函数主要是用来计算各小区的功率
%各个小区的功率主要分为以下几个部分：
%发送功率：这部分是固定的，对于不同的船舶有差别，功率分别为2W和12.5W
%在项目中，船舶的发送功率选择为12.5W，主要的研究对象为远海船舶；
%发送天线增益：安装在船舶上的发送天线为半波偶极振子天线，其对应方向的增益可以通过公式计算得出；
%损耗：在目前的模拟源项目中，这部分的损耗主要是自由空间损耗；
%接收天线增益：通过实际测量的天线数据，进行适当的数据处理；
%输入及输出参数的意义：
%输出参数：
%power:接收信号的功率(dBm)
%输入参数：
%transPower:发送信号的功率(dBm),
%这个参数可能会被设置为全局变量，可以从全局变量的函数定义文件中查找；
%sateAngleOnVes:船舶到卫星的连线与海平面的夹角(弧度)
%distance_vesSate:卫星到船舶的距离(km)
%vector_SatToArea:卫星到各小区的向量
%transFrequency:发送信号的频率(Hz)
%sateThriftAngle:卫星实际偏移角度(弧度)
%coordinateBeforeThrift:这个参数是当前的坐标系x，y，z所在方向的方向向量（为单位向量）

%船舶发送功率
vesTransPower = transPower;
%发送天线增益
%warning：此处用的是evaluation所计算出来的仰角；
patternGain_dB = 10*log10(0.964*16/3/pi*(sin((90-sateAnglesOnVes)*pi/180)).^3 + eps*1e10);  
%传输损耗
freeSpaceLoss_dB = -(32.44 + 20*log10(distance_vesSate/1000) + 20*log10(transFrequency/1e6));   %自由空间损耗(dB)
totalLoss_dB = freeSpaceLoss_dB;    %信号总损耗
%接收天线增益
recvGain_dB = calRecvGain(vector_SatToArea, coordinateBeforeThrift, sateThriftAngle);
%接收信号功率
power = vesTransPower + patternGain_dB + totalLoss_dB + recvGain_dB';
end