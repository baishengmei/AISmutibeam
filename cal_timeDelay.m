function timeDelayDiffOfAreas = cal_timeDelay(areas)
    global sateHeight c
    sateAlt = sateHeight;
    bitsPerSecond = 9600;           % AIS��������(bps)
    [~, distance_SatArea, ~, ~, ~, ~, ~] = genSateVector(areas);
    timeDelayDiffOfAreas = calTimeDelayDiff(bitsPerSecond, distance_SatArea, sateAlt, c);
end