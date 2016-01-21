function coorAfterThrift = calThriftCoordinate(coordinateBeforeThrift, sateThriftAngle)
%参数说明：
%此处的卫星偏移角度仅限在yoz平面中偏移，其他的暂且不支持；
%输入参数：
%coordinateBeforeThrift: 偏移之前的坐标系表示
%sateThriftAngle: 卫星偏移角度(度)
%输出参数：
%coorAfterThrift: 偏移之后的坐标系表示
coor_x = coordinateBeforeThrift(1, :);
coor_y = coordinateBeforeThrift(2, :) * cos(sateThriftAngle * pi/180) + coordinateBeforeThrift(3, :) * sin(sateThriftAngle * pi/ 180);
coor_z = -1 * coordinateBeforeThrift(2, :) * sin(sateThriftAngle * pi/ 180) + coordinateBeforeThrift(3, :) * cos(sateThriftAngle * pi/ 180);
coorAfterThrift = [coor_x; coor_y; coor_z];
end