function distriMat = F_initModelDistriNew(vesNum)
    % ��γ�ȶ�Ӧ��ϵ����:
    % ��γ90�㡪����γ90�㣺������ת��Ϊ-90�㡪��90��
    % ����180�㡪��0�㡪������180�㣺������ת����-180�㡪��0�㡪�� 180��
    % ��ʮ����ͼ     115,-44,158,-22
    global sateLat sateLon sateHeight
    sateLat = -sateLat;
    flagFig = 1;           %1�������Ǹ����´����ֲ�ͼ ����0
    ifMove = 0;           %0��ʾ���Ǿ�ֹ��1��ʾ�����˶�

    %%%%%%%%%%%%%%%%%%%%%%��ȡ·������ȡ�ı�����%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dirPath = pwd;               % ��ȡ��ǰ·��
    picLocFileName = 'position.txt';
    numModelFileName = 'numModel.mat';
    [picPos numModel] = F_loadPicAndNum(dirPath, picLocFileName, numModelFileName);
    %%%%%%%%%%%%%%��������ɨ������������֯��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ifMove == 0
        num_state = F_calSateAreaSize(sateHeight);
        %%%%%%%%%%%%%%%%%����ÿ��С����γ��%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        stateLatAll = F_calAreasLat(num_state);                        %������γ�ȱ仯���仯
        stateLonAll = F_calAreasLon(stateLatAll);
        %     stateLatAll = F_calAreasLatNew(num_state);                   %���Ȳ���γ�ȱ仯���仯
        %     stateLonAll = F_calAreasLonNew(num_state);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%ȡ����Բ%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        stateLat = F_incircleAreas(stateLatAll);
        stateLon = F_incircleAreas(stateLonAll);
    else
        num_state = F_calSateAreaSize(sateHeight);
        stateLatAll = F_calAreasLatMove(obsStatePos);
    end

    sourcePicDir = 'ȫ���ͼ/';
    % ǰ3������ÿ�ζ�����, �����к󱣴沢�ڵ�4��֮ǰ��ȡ
    pics = F_readAllPic(sourcePicDir);
    borderLoc = F_getBorderLoc(pics);
    [totVesNum picSize] = F_allPicRecog(pics, numModel, borderLoc);
    clear pics;
    % ���������ֲ�ģ��
    vesDistriModel = F_buildVesModel(totVesNum, borderLoc, picPos, picSize, stateLon, stateLat);

    %Ϊ�˸�ģ��Դ��γ��ͳһ������γ��Ϊ������γ�ĳ�����ͬʱͳһ����
    N = vesDistriModel;
    sate_EW = sateLon;
    sate_NS = sateLat;
    state_EW = stateLonAll(:, :, 1);
    state_NS = -stateLatAll(:, :, 1);
    save('distributionResult/vessal_stateLonLat_sateLonLat.mat', 'N', 'state_EW', 'state_NS', 'sate_EW', 'sate_NS');
    distriMat = F_initModelDistri(vesNum, N, state_EW, state_NS);
    
    % ���ƴ����ֲ�ͼ
    if flagFig == 1
        [row col] = find(vesDistriModel);
        z_earth = zeros(length(col), 1);
        row = num_state - row;
        figure(2)
        plot(col, row, '*');
        axis([0 num_state 0 num_state]);
        grid;
        title(['(�����ۿ�)���Ǹ������򴬲��ֲ�ͼ(����������' num2str(sum(vesDistriModel(:))) '    ����С������' num2str(num_state) '*' num2str(num_state) ')']);
        xlabel('����С�����');
        ylabel('����С�����');
    end
    sateLat = -sateLat;
    
end

