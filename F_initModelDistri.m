function distriMat = F_initModelDistri(vesNum, N, state_EW, state_NS)
%     global vPath1
%     load(vPath1);
    N = N * (vesNum / sum(N(:)));
    N(N > 400) = 400;           % 防止船数过多导致的时隙无法分配, 今后考虑在时隙分配函数中增加判断避免该情况
    distriMat(:, :, 1) = round(N);
    distriMat(:, :, 2) = state_NS;     % 原生成模型程序北纬为负, 此程序中北纬为正, 今后的程序可能修改
    distriMat(:, :, 3) = state_EW;
end