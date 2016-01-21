function h= S_waitbar(x, whichbar, varargin)
% 1 h = S_waitbar(p, 'title' , h_figure, loc)
% 在窗口h_figure内的指定位置[x,y]创建一个进度为p，进度标题为title的进度条。p的值在[0,1]范围内，loc为进度条左下角在当前窗口内的位置，单位由窗口h_figure的Units属性指定。
% 2 S_waitbar(p, h)
% 更新进度条h的进度为p。
% 3 S_waitbar(p, h, 'title')
% 更新进度条h的进度为p，进度标题为title。
% 
% 例如，在命令行输入：
% >> h=S_waitbar(0.1,'请等待...',gcf,100,200);
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