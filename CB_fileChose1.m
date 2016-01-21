function CB_fileChose1(hFileEdit)
    global vPath1 hMode
    if(get(hMode,'value') == 2)
        [filename, filePath] = uigetfile('.', '选择AIS船舶分布文件...');
        vPath1 = [filePath, filename];
        if filePath ~= 0
            set(hFileEdit, 'string', [filePath, filename]);
        else
            vPath1 = '';
        end
    end
end