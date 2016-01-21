function [pitch, azimuth] = F_coordinateTransform(coordinateAxis, pointerAxis)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %˵����
    %�˴�����
    %���Ƿ��з�����Ϊx��������
    %��ֱ�����Ƿ��з���ķ�����Ϊy��������
    %������ĵķ�����Ϊz��������

    %���룺
    %coordinate ��ת���������ϵ�ڵ�ǰ����ϵ���еı�ʾ�������������ķ�ʽ�������ᴫ�룻
    %pointerAxis ����Ҫת����������

    %�����
    %pitch ������, �޶���ΧΪ -pi -- pi
    %azimuth ��λ��, �޶���ΧΪ 0 -- pi

    %author������
    %date��2015-11-12
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    setCoordinateSystem = coordinateAxis;
    transPointerAxis = pointerAxis / setCoordinateSystem;
    
    parStorage = zeros(size(transPointerAxis, 1), 2);   %������ÿ��С���ĸ����Ǻͷ�λ��    ��һ��Ϊ�����ǣ� �ڶ���Ϊ��λ��
    
    %��λ��

    parStorage(find(transPointerAxis(:, 1) >= 0), 2) = atan(transPointerAxis(find(transPointerAxis(:, 1) >= 0), 2) ./ transPointerAxis(find(transPointerAxis(:, 1) >= 0), 1)); 
    parStorage(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) >= 0), 2) = atan(transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) >= 0), 2) ./ ...
        transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) >= 0), 1)) + pi;
    parStorage(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) < 0), 2) = atan(transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) < 0), 2) ./ ...
        transPointerAxis(find(transPointerAxis(:, 1) < 0 & transPointerAxis(:, 2) < 0), 1)) - pi;
    %������
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