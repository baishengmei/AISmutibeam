% 去除因边框粗度造成的行列号记录错误
% border: 确定为边框的行号或列号
% disturbThr: 粗度门限
%                        --------- 13.10.10 by Z.x
function border = F_deBorderDisturb(border, disturbThr)
	disturb = find(diff(border) < disturbThr) + 1;
    border(disturb)=[];                            % 去干扰
end