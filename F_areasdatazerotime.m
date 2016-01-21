function areasdatazerotime = F_areasdatazerotime(areas, aisData, zeroNum, TimeTable)
    paraNum = nargin; %   输入参数的个数
    areasdatazerotime = cell(paraNum, 1);
    areasdatazerotime(1) = {areas};
    areasdatazerotime(2) = {aisData};
    areasdatazerotime(3) = {zeroNum};
    areasdatazerotime(4) = {TimeTable};
end