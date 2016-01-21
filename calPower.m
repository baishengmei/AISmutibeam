function power = ...
    calPower(transPower, sateAnglesOnVes, distance_vesSate, vector_SatToArea,  transFrequency, sateThriftAngle, coordinateBeforeThrift)
%���������Ҫ�����������С���Ĺ���
%����С���Ĺ�����Ҫ��Ϊ���¼������֣�
%���͹��ʣ��ⲿ���ǹ̶��ģ����ڲ�ͬ�Ĵ����в�𣬹��ʷֱ�Ϊ2W��12.5W
%����Ŀ�У������ķ��͹���ѡ��Ϊ12.5W����Ҫ���о�����ΪԶ��������
%�����������棺��װ�ڴ����ϵķ�������Ϊ�벨ż���������ߣ����Ӧ������������ͨ����ʽ����ó���
%��ģ���Ŀǰ��ģ��Դ��Ŀ�У��ⲿ�ֵ������Ҫ�����ɿռ���ģ�
%�����������棺ͨ��ʵ�ʲ������������ݣ������ʵ������ݴ���
%���뼰������������壺
%���������
%power:�����źŵĹ���(dBm)
%���������
%transPower:�����źŵĹ���(dBm),
%����������ܻᱻ����Ϊȫ�ֱ��������Դ�ȫ�ֱ����ĺ��������ļ��в��ң�
%sateAngleOnVes:���������ǵ������뺣ƽ��ļн�(����)
%distance_vesSate:���ǵ������ľ���(km)
%vector_SatToArea:���ǵ���С��������
%transFrequency:�����źŵ�Ƶ��(Hz)
%sateThriftAngle:����ʵ��ƫ�ƽǶ�(����)
%coordinateBeforeThrift:��������ǵ�ǰ������ϵx��y��z���ڷ���ķ���������Ϊ��λ������

%�������͹���
vesTransPower = transPower;
%������������
%warning���˴��õ���evaluation��������������ǣ�
patternGain_dB = 10*log10(0.964*16/3/pi*(sin((90-sateAnglesOnVes)*pi/180)).^3 + eps*1e10);  
%�������
freeSpaceLoss_dB = -(32.44 + 20*log10(distance_vesSate/1000) + 20*log10(transFrequency/1e6));   %���ɿռ����(dB)
totalLoss_dB = freeSpaceLoss_dB;    %�ź������
%������������
recvGain_dB = calRecvGain(vector_SatToArea, coordinateBeforeThrift, sateThriftAngle);
%�����źŹ���
power = vesTransPower + patternGain_dB + totalLoss_dB + recvGain_dB';
end