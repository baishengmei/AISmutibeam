function CB_fileChose1(hFileEdit)
    global vPath1 hMode
    if(get(hMode,'value') == 2)
        [filename, filePath] = uigetfile('.', 'ѡ��AIS�����ֲ��ļ�...');
        vPath1 = [filePath, filename];
        if filePath ~= 0
            set(hFileEdit, 'string', [filePath, filename]);
        else
            vPath1 = '';
        end
    end
end