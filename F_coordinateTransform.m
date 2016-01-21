function [pitch, azimuth] = F_coordinateTransform(coordinateAxis, pointerAxis)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %说明：
    %此处采用
    %卫星飞行方向作为x轴正方向；
    %垂直于卫星飞行方向的方向作为y轴正方向；
    %背向地心的方向作为z轴正方向；

    %输入：
    %coordinate 是转换后的坐标系在当前坐标系当中的表示，采用行向量的方式将坐标轴传入；
    %pointerAxis 是需要转换的向量；

    %输出：
    %pitch 俯仰角, 限定范围为 -pi -- pi
    %azimuth 方位角, 限定范围为 0 -- pi

    %author：候金成
    %date：2015-11-12
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    setCoordinateSystem = coordinateAxis;
    transPointerAxis = pointerAxis / setCoordinateSystem;
    
    parStorage = zeros(size(transPointerAxis, 1), 2);   %用来存每个小区的俯仰角和方位角    第一列为俯仰角； 第二列为方位角
    
    %方位角

    parStorage(find(transPointerAxis(:, 1) >= 0), 2) = atan(transPointerAxis(find(transPointerAxis(:, 1) >= 0), 2) ./ transPointerAxis(find(transPointerAxis(:, 1) >= 0), 1)); 
    parStorage(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) >= 0), 2) = atan(transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) >= 0), 2) ./ ...
        transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) >= 0), 1)) + pi;
    parStorage(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) < 0), 2) = atan(transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) < 0), 2) ./ ...
        transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) < 0), 1)) - pi;
    %俯仰角
    parStorage(find(transPointerAxis(:, 3) >= 0), 1) = atan(sqrt(transPointerAxis(find(transPointerAxis(:, 3) >= 0), 1).^2 + ...
        transPointerAxis(find(transPointerAxis(:, 3) >= 0), 2).^2) ./ transPointerAxis(find(transPointerAxis(:, 3) >= 0), 3));
     parStorage(find(transPointerAxis(:, 3) < 0), 1) = atan(sqrt(transPointerAxis(find(transPointerAxis(:, 3) < 0), 1).^2 + ...
        transPointerAxis(find(transPointerAxis(:, 3) < 0), 2).^2) ./ transPointerAxis(find(transPointerAxis(:, 3) < 0), 3)) + pi;
    
    parStorage(find(parStorage(:,2) < 0), 1) = -1 * parStorage(find(parStorage(:,2) < 0), 1);
    parStorage(find(parStorage(:,2) < 0), 2) = parStorage(find(parStorage(:,2) < 0), 2) + pi;
    
    parStorage(find(isnan(parStorage) == 1 )) = 0;
    
    pitch = parStorage(:, 1);
    azimuth = parStorage(:, 2);
    
    
end