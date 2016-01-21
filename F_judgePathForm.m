function flag = F_judgePathForm( path, flag_IorO)
%--------------------------------------------------
%�������ܣ��ж�����·���Ƿ���Ч
% ���룺
%     path:����·��
% �����
%     flag:����·����Чflag��1������·����Ч��flag��0
%                                   --xb 2014.10.30
% -------------------------------------------------
    flag = 1;
    match = ':[\\ /]';
    result = regexp(path,match, 'once');
    if isempty(result)
        flag = 0;
        if strcmp(flag_IorO,'IN')
            errordlg('�����ļ�·����Ч, ������ѡ�񴢴�·��', '����·����Ч');
        end
        if strcmp(flag_IorO,'OUT')
            errordlg('����ļ�·����Ч, ������ѡ�񴢴�·��', '����·����Ч');
        end
    else
        try
            tempPath = [path, '/' ,'test'];
            mkdir(tempPath);
        catch
            flag = 0;
            if strcmp(flag_IorO,'IN')
                errordlg('�����ļ�·����Ч, ������ѡ�񴢴�·��', '����·����Ч');
            end
            if strcmp(flag_IorO,'OUT')
                errordlg('����ļ�·����Ч, ������ѡ�񴢴�·��', '����·����Ч');
            end
        end
        if exist(tempPath,'dir')
            rmdir(tempPath);
        end
    end
end

