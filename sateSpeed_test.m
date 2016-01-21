vector_Sat_normalise = vector_Sat ./ (sqrt(sum(vector_Sat .* vector_Sat, 2)) * ones(1, 3));
figure(1);
title('���Ƿ��з���ʾ��ͼ');
quiver3(0, 0, 0, vector_Sat_normalise(1, 1), vector_Sat_normalise(1, 2), vector_Sat_normalise(1, 3));
text(vector_Sat_normalise(1, 1), vector_Sat_normalise(1, 2), vector_Sat_normalise(1, 3), '����ָ�����ǵ�ʸ��');
hold on;
quiver3(vector_Sat_normalise(1, 1), vector_Sat_normalise(1, 2), vector_Sat_normalise(1, 3),...
    vector_latTangent(1, 1), vector_latTangent(1, 2), vector_latTangent(1, 3));
text(vector_latTangent(1, 1)+ vector_Sat_normalise(1, 1), vector_latTangent(1, 2)+ vector_Sat_normalise(1, 2),...
    vector_latTangent(1, 3)+ vector_Sat_normalise(1, 3), 'γ�����߷���');
hold on;
quiver3(vector_Sat_normalise(1, 1), vector_Sat_normalise(1, 2), vector_Sat_normalise(1, 3),...
    vector_lonTangent(1, 1), vector_lonTangent(1, 2), vector_lonTangent(1, 3));
text(vector_lonTangent(1, 1)+ vector_Sat_normalise(1, 1), vector_lonTangent(1, 2)+ vector_Sat_normalise(1, 2),...
    vector_lonTangent(1, 3)+ vector_Sat_normalise(1, 3), '�������߷���');
hold on;
quiver3(vector_Sat_normalise(1, 1), vector_Sat_normalise(1, 2), vector_Sat_normalise(1, 3),...
    vector_SatSpeed(1, 1), vector_SatSpeed(1, 2), vector_SatSpeed(1, 3));
text(vector_SatSpeed(1, 1)+ vector_Sat_normalise(1, 1), vector_SatSpeed(1, 2)+ vector_Sat_normalise(1, 2),...
    vector_SatSpeed(1, 3)+ vector_Sat_normalise(1, 3), '���������ٶȷ���');

xlabel('x��');
ylabel('y��');
zlabel('z��');