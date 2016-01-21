function doaOfAreas = cal_doa(areas)
    [~, distance_SatArea, vector_AreaSat, ~, ~, ~, vector_SatAnt] = genSateVector(areas);
    doaOfAreas = sum((-1 * vector_AreaSat .* vector_SatAnt), 2)' ./ (distance_SatArea) ./ sqrt(sum(vector_SatAnt .* vector_SatAnt, 2))';
end