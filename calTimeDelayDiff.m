function delayCenterDiff = calTimeDelayDiff(bitsPerSecond, distance_SatArea, sateAlt, c)
%   �����������˵����
%   �������˵����
%   bitsPerSecond ��AIS�������ʣ�bps��
%   distance_SatArea ���������С���ľ���(m)
%   sateAlt : ���Ǹ߶ȣ�km��
%   c �� ����
    delayOfAreas = distance_SatArea ./ c;           % ��С��ʱ��(s)
    delayOfAreas_bit = bitsPerSecond * delayOfAreas;    % ��С��ʱ��(bit)
    satLocDelay = sateAlt * 1e3 ./ c;     % �������·�ʱ��(s)
    satLocDelay_bit = bitsPerSecond * satLocDelay;  % �������·�ʱ��(bit)
    delayCenterDiff = delayOfAreas_bit - satLocDelay_bit;     % ��С��ʱ�Ӳ�(bit)
end