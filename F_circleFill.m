%��ʾ�źŶ�ȡ�İٷֱȣ��Ͷ�ȡ���ȡ�percentΪ��ȡ�İٷֱȣ� RΪ����Բ�εİ뾶��
function F_circleFill(percent, R, whichaxes)
    gca = whichaxes;
    N = 32;
    X = percent * 2 * R;
    show_percent = sprintf('%.2f%%', percent*100);
    theta_cur = acos((R -X)/R);
    theta = linspace(-pi/2 - theta_cur,-pi/2 + theta_cur, N);
    x = cos(theta);
    y = sin(theta);
    fill(x, y, [229 105 120]/255);
    axis([-1,1,-1,1]);
    text(0,0,show_percent,'HorizontalAlignment','center',...
        'FontSize',18,...
        'FontWeight','bold',...
        'Color',[1 1 1]);
    set(gca, 'visible', 'off');
end