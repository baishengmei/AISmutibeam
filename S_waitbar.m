function h= S_waitbar(x, whichbar, varargin)
% 1 h = S_waitbar(p, 'title' , h_figure, loc)
% �ڴ���h_figure�ڵ�ָ��λ��[x,y]����һ������Ϊp�����ȱ���Ϊtitle�Ľ�������p��ֵ��[0,1]��Χ�ڣ�locΪ���������½��ڵ�ǰ�����ڵ�λ�ã���λ�ɴ���h_figure��Units����ָ����
% 2 S_waitbar(p, h)
% ���½�����h�Ľ���Ϊp��
% 3 S_waitbar(p, h, 'title')
% ���½�����h�Ľ���Ϊp�����ȱ���Ϊtitle��
% 
% ���磬�����������룺
% >> h=S_waitbar(0.1,'��ȴ�...',gcf,100,200);
	if ischar(whichbar) || iscellstr(whichbar)
		if nargin == 4
			h_f = waitbar(x, whichbar, 'visible', 'off');
			h1 = findall(h_f, 'type','axes');
			h_axs = copyobj(h1, varargin{1});
			set(h_axs, 'unit', 'normalized');
% 			pos = get(h_axs, 'position');
% 			set(h_axs, 'position', [varargin{2}, varargin{3}, pos(3:4)])
			set(h_axs, 'position', varargin{2});
		end
	elseif isnumeric(whichbar)
		h_axs = whichbar;
		p = findobj(h_axs, 'Type', 'patch');
		set(p, 'XData', [0 100*x 100*x 0])
		if nargin==3
			hTitle = get(h_axs, 'title');
			set(hTitle, 'string', varargin{1});
		end
	end
	if nargout==1
		h = h_axs;
	end
end