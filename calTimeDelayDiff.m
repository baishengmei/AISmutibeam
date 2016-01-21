function delayCenterDiff = calTimeDelayDiff(bitsPerSecond, distance_SatArea, sateAlt, c)
%   输入输出参数说明：
%   输入参数说明：
%   bitsPerSecond ：AIS数据速率（bps）
%   distance_SatArea ：卫星与各小区的距离(m)
%   sateAlt : 卫星高度（km）
%   c ： 光速
    delayOfAreas = distance_SatArea ./ c;           % 各小区时延(s)
    delayOfAreas_bit = bitsPerSecond * delayOfAreas;    % 各小区时延(bit)
    satLocDelay = sateAlt * 1e3 ./ c;     % 卫星正下方时延(s)
    satLocDelay_bit = bitsPerSecond * satLocDelay;  % 卫星正下方时延(bit)
    delayCenterDiff = delayOfAreas_bit - satLocDelay_bit;     % 各小区时延差(bit)
end