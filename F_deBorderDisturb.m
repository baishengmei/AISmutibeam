% ȥ����߿�ֶ���ɵ����кż�¼����
% border: ȷ��Ϊ�߿���кŻ��к�
% disturbThr: �ֶ�����
%                        --------- 13.10.10 by Z.x
function border = F_deBorderDisturb(border, disturbThr)
	disturb = find(diff(border) < disturbThr) + 1;
    border(disturb)=[];                            % ȥ����
end