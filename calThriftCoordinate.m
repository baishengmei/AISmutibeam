function coorAfterThrift = calThriftCoordinate(coordinateBeforeThrift, sateThriftAngle)
%����˵����
%�˴�������ƫ�ƽǶȽ�����yozƽ����ƫ�ƣ����������Ҳ�֧�֣�
%���������
%coordinateBeforeThrift: ƫ��֮ǰ������ϵ��ʾ
%sateThriftAngle: ����ƫ�ƽǶ�(��)
%���������
%coorAfterThrift: ƫ��֮�������ϵ��ʾ
coor_x = coordinateBeforeThrift(1, :);
coor_y = coordinateBeforeThrift(2, :) * cos(sateThriftAngle * pi/180) + coordinateBeforeThrift(3, :) * sin(sateThriftAngle * pi/ 180);
coor_z = -1 * coordinateBeforeThrift(2, :) * sin(sateThriftAngle * pi/ 180) + coordinateBeforeThrift(3, :) * cos(sateThriftAngle * pi/ 180);
coorAfterThrift = [coor_x; coor_y; coor_z];
end