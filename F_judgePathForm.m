function flag = F_judgePathForm( path, flag_IorO)
%--------------------------------------------------
%函数功能：判断输入路径是否有效
% 输入：
%     path:输入路径
% 输出：
%     flag:输入路径有效flag置1，输入路径无效，flag置0
%                                   --xb 2014.10.30
% -------------------------------------------------
    flag = 1;
    match = ':[\\ /]';
    result = regexp(path,match, 'once');
    if isempty(result)
        flag = 0;
        if strcmp(flag_IorO,'IN')
            errordlg('输入文件路径无效, 请重新选择储存路径', '储存路径无效');
        end
        if strcmp(flag_IorO,'OUT')
            errordlg('输出文件路径无效, 请重新选择储存路径', '储存路径无效');
        end
    else
        try
            tempPath = [path, '/' ,'test'];
            mkdir(tempPath);
        catch
            flag = 0;
            if strcmp(flag_IorO,'IN')
                errordlg('输入文件路径无效, 请重新选择储存路径', '储存路径无效');
            end
            if strcmp(flag_IorO,'OUT')
                errordlg('输出文件路径无效, 请重新选择储存路径', '储存路径无效');
            end
        end
        if exist(tempPath,'dir')
            rmdir(tempPath);
        end
    end
end

