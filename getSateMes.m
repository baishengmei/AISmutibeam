function [sateLong, sateLat] = getSateMes(areas)
	numberOfAreas_sqrt = size(areas, 1);
	mid = floor(numberOfAreas_sqrt / 2);
    sateLat = areas(mid, mid, 2);
    sateLong = areas(mid, mid, 3);
end