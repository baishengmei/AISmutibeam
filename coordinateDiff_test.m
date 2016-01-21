figure(1);
quiver3(0, 0, 0, coordinateBeforeThrift(1, 1), coordinateBeforeThrift(1, 2), coordinateBeforeThrift(1, 3));
text(coordinateBeforeThrift(1, 1), coordinateBeforeThrift(1, 2), coordinateBeforeThrift(1, 3), '偏移之前x轴的方向');
hold on;
quiver3(0, 0, 0, coordinateBeforeThrift(2, 1), coordinateBeforeThrift(2, 2), coordinateBeforeThrift(2, 3));
text(coordinateBeforeThrift(2, 1), coordinateBeforeThrift(2, 2), coordinateBeforeThrift(2, 3), '偏移之前y轴的方向');
hold on;
quiver3(0, 0, 0, coordinateBeforeThrift(3, 1), coordinateBeforeThrift(3, 2), coordinateBeforeThrift(3, 3));
text(coordinateBeforeThrift(3, 1), coordinateBeforeThrift(3, 2), coordinateBeforeThrift(3, 3), '偏移之前z轴的方向');
hold on;
quiver3(0, 0, 0, coor_x(1, 1), coor_x(1, 2), coor_x(1, 3));
text(coor_x(1, 1), coor_x(1, 2), coor_x(1, 3), '偏移之后x轴的方向');
hold on;
quiver3(0, 0, 0, coor_y(1, 1), coor_y(1, 2), coor_y(1, 3));
text(coor_y(1, 1), coor_y(1, 2), coor_y(1, 3), '偏移之后y轴的方向');
hold on;
quiver3(0, 0, 0, coor_z(1, 1), coor_z(1, 2), coor_z(1, 3));
text(coor_z(1, 1), coor_z(1, 2), coor_z(1, 3), '偏移之后z轴的方向');
xlabel('x轴');
ylabel('y轴');
zlabel('z轴');
xlim([-1 1]);
ylim([-1 1]);
zlim([-1 1]);
title('偏移之前和偏移之后坐标对比');
