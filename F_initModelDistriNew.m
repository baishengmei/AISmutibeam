function distriMat = F_initModelDistriNew(vesNum)
    % 经纬度对应关系如下:
    % 北纬90°——南纬90°：程序中转换为-90°——90°
    % 西经180°——0°——东经180°：程序中转换成-180°——0°—— 180°
    % 第十七张图     115,-44,158,-22
    global sateLat sateLon sateHeight
    sateLat = -sateLat;
    flagFig = 1;           %1绘制卫星覆盖下船舶分布图 否则0
    ifMove = 0;           %0表示卫星静止，1表示卫星运动

    %%%%%%%%%%%%%%%%%%%%%%获取路径，读取文本过程%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dirPath = pwd;               % 获取当前路径
    picLocFileName = 'position.txt';
    numModelFileName = 'numModel.mat';
    [picPos numModel] = F_loadPicAndNum(dirPath, picLocFileName, numModelFileName);
    %%%%%%%%%%%%%%计算卫星扫描区域内自组织区域总数%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ifMove == 0
        num_state = F_calSateAreaSize(sateHeight);
        %%%%%%%%%%%%%%%%%计算每个小区经纬度%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        stateLatAll = F_calAreasLat(num_state);                        %经度随纬度变化而变化
        stateLonAll = F_calAreasLon(stateLatAll);
        %     stateLatAll = F_calAreasLatNew(num_state);                   %经度不随纬度变化而变化
        %     stateLonAll = F_calAreasLonNew(num_state);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%取内切圆%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        stateLat = F_incircleAreas(stateLatAll);
        stateLon = F_incircleAreas(stateLonAll);
    else
        num_state = F_calSateAreaSize(sateHeight);
        stateLatAll = F_calAreasLatMove(obsStatePos);
    end

    sourcePicDir = '全球地图/';
    % 前3步不必每次都运行, 可运行后保存并在第4步之前读取
    pics = F_readAllPic(sourcePicDir);
    borderLoc = F_getBorderLoc(pics);
    [totVesNum picSize] = F_allPicRecog(pics, numModel, borderLoc);
    clear pics;
    % 建立船舶分布模型
    vesDistriModel = F_buildVesModel(totVesNum, borderLoc, picPos, picSize, stateLon, stateLat);

    %为了跟模拟源经纬度统一，将北纬改为正，南纬改成正，同时统一命名
    N = vesDistriModel;
    sate_EW = sateLon;
    sate_NS = sateLat;
    state_EW = stateLonAll(:, :, 1);
    state_NS = -stateLatAll(:, :, 1);
    save('distributionResult/vessal_stateLonLat_sateLonLat.mat', 'N', 'state_EW', 'state_NS', 'sate_EW', 'sate_NS');
    distriMat = F_initModelDistri(vesNum, N, state_EW, state_NS);
    
    % 绘制船舶分布图
    if flagFig == 1
        [row col] = find(vesDistriModel);
        z_earth = zeros(length(col), 1);
        row = num_state - row;
        figure(2)
        plot(col, row, '*');
        axis([0 num_state 0 num_state]);
        grid;
        title(['(荷兰港口)卫星覆盖区域船舶分布图(船舶总数：' num2str(sum(vesDistriModel(:))) '    覆盖小区数：' num2str(num_state) '*' num2str(num_state) ')']);
        xlabel('横向小区标号');
        ylabel('纵向小区标号');
    end
    sateLat = -sateLat;
    
end

