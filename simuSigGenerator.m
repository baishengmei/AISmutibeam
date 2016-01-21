%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 生成卫星接收到的AIS模拟信号
% 功能: 绘制程序界面, 可通过界面输入接口参数后生成模拟信号
% 输入参数: 
%	储存路径: 信号文件储存位置
%	卫星高度: 正整数, 单位为km
%	船舶数量: 卫星覆盖范围内的总船舶数
%	观测时间: 卫星观测时间(假设在观测时间内卫星位置不变)
% 输出参数:
%	在储存路径下生成模拟信号的mat文件, 由于解调时间较长, 
%	信号被分为10个mat文件分别保存, 每个mat文件的内容为:
%		data: 所有船舶发送的二进制信息
%		sig: 模拟生成的信号
%		freqShift: 各发送信号时隙的频偏(Hz)
%		sendTime: 各发送信号时隙相对当前文件中的发送时间(采样点)
%		power: 各发送信号时隙的功率(dB)
%		sendTime_abs: 各发送信号时隙的实际发送时间(采样点)
%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
clc;

% 初始化变量
global isRunning isLegal vPath vHeight vVesNum vTime vEbNo ...
    hPathEdit hHeightEdit hVesNumEdit hTimeEdit hEbNoEdit hPathBtn hGenBtn hAxes hMode hPathEdit1 hPathBtn1 vPath1
isRunning = 0;			% 正在生成标志
vPath = '';
vHeight = 0;			% 卫星高度值
vVesNum = 0;			% 船舶数量值
vTime = 0;					% 观测时间值
vEbNo = 0;
isLegal = 0;
F_initPar;

% 颜色变量、字体变量声明
totalBackgroundColor =[78 172 255]/255;
% totalBackgroundColor =[237 237 237]/255;
frameBackgroundColor = [145 198 255]/255;
titleBackgroundColor =  [78 172 255]/255;
buttonColor = [86 134 180]/255;

fontColor = [255 255 255]/255;

figMain = figure;
figLoc = [100, 100, 600, 450];
set(figMain, 'unit','pixels','position',figLoc,...
    'color',totalBackgroundColor,'resize','off',...
    'name', 'AIS模拟信号生成器','numbertitle', 'off');
hm = findall(figMain, 'type', 'uimenu');		% 查找标准菜单
delete(hm);	
S_changeLogo(figMain, 'logo.jpg');			% 更改logo


figTitleLoc =[0, 372, 600, 80];
hFigTitle = uicontrol(figMain, 'style', 'text',...
    'unit', 'pixels', 'position', figTitleLoc,...
    'string', 'AIS模拟信号生成器','fontSize',35, ...
    'HorizontalAlignment', 'center',...
    'backgroundColor',[0.043 0.518 0.78],...
    'ForegroundColor', [255 255 255]/255);
% 
% frmSigProcssLoc = [20,80,260,260];
% hFrmSigProcess = uicontrol(figMain, 'style','frame',...
%         'unit','pixels', 'position', frmSigProcssLoc, ...
%         'backgroundColor', [0.757 867 0.776],...
%         'foregroundColor', [1,0,0]);

frmSigInfoLoc = [320,112,260,260];
hFrmSigInfo = uicontrol(figMain, 'style', 'frame',...
         'unit','pixels','position', frmSigInfoLoc, ...
        'backgroundColor',frameBackgroundColor,...
        'foregroundColor',frameBackgroundColor);
    
frmPathLoc = [20,58,560,45];
hFrmPath = uicontrol(figMain, 'style', 'frame',...
         'unit','pixels','position', frmPathLoc, ...
        'backgroundColor', frameBackgroundColor,...
         'foregroundColor',frameBackgroundColor);
    
% 信号信息的选择按钮的设置：   
textDistance = 40;
btn_x = 130;
btn_y = 40;
btnInitLoc = [320,280,btn_x ,btn_y];
editInitLoc = [450,280,btn_x ,btn_y];

buttonBackgroundColor = [145 198 255]/255;
buttonBackgroundColor2 = [41 169 255]/255;


 % 信息选择的标题  
InfoTitleLoc = [320 330 260 35];
hInfoTitle = uicontrol(figMain, 'style', 'text',...
    'unit', 'pixels', 'position', InfoTitleLoc,...
    'string', '生成信号选择','fontSize',16, ...
    'HorizontalAlignment', 'center',...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor', fontColor);
 
 % 卫星高度
hHeightStr = uicontrol(figMain,  'style', 'text', ...
	'unit', 'pixels', 'position', btnInitLoc, ...
	'fontsize', 14, 'string', '卫星高度(km)',...
    'backgroundColor',buttonBackgroundColor2,...
    'ForegroundColor',fontColor);
hHeightEdit = uicontrol(figMain,  'style', 'edit', ...
	'unit', 'pixels', 'position', editInitLoc, ...
	'fontsize', 14, 'string','600',...
    'backgroundColor',buttonBackgroundColor2,...
    'ForegroundColor',fontColor);
% 船舶数量   
hVesNumStr = uicontrol(figMain,  'style', 'text', ...
	'unit', 'pixels', 'position', [320, 280 - textDistance, btn_x, btn_y], ...
	'fontsize', 14, 'string', '船舶数量(艘)',...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor',fontColor);   
hVesNumEdit = uicontrol(figMain,  'style', 'edit', ...
	'unit', 'pixels', 'position', [450, 280 - textDistance, btn_x, btn_y], ...
	'fontsize', 14,'string', '2000',...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor',fontColor);
% 观测时间   
hTimeStr = uicontrol(figMain,  'style', 'text', ...
	'unit', 'pixels', 'position', [320, 280 - 2*textDistance, btn_x, btn_y], ...
	'fontsize', 14, 'string', '观测时间(s)',...
    'backgroundColor',buttonBackgroundColor2,...
    'ForegroundColor',fontColor);   
hTimeEdit = uicontrol(figMain,  'style', 'edit', ...
	'unit', 'pixels', 'position', [450, 280 - 2*textDistance, btn_x, btn_y], ...
	'fontsize', 14,'string', '60',...
    'backgroundColor',buttonBackgroundColor2,...
    'ForegroundColor',fontColor);  
% 信噪比 
hEbNoStr = uicontrol(figMain,  'style', 'text', ...
	'unit', 'pixels', 'position', [320, 280 - 3*textDistance, btn_x, btn_y], ...
	'fontsize', 14, 'string', '信噪比(dB)',...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor',fontColor);  
hEbNoEdit = uicontrol(figMain,  'style', 'edit', ...
	'unit', 'pixels', 'position', [450, 280 - 3*textDistance, btn_x, btn_y], ...
	'fontsize', 14,'string', '20', ...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor',fontColor); 
% 确定按钮    
hGenBtn = uicontrol(figMain, 'style', 'push', ...
	'unit', 'pixels', 'position', [400,125,100,30], ...
	'string', '生成信号','fontSize',14,...
    'backgroundColor',buttonColor,...
    'ForegroundColor',fontColor); 

% 信号存储位置的设置：
pathStrLoc = [39,63,100,30];
pathEditLoc = [150,65,300,30];
pathBtnLoc = [460,65,100,30];
hPathStr = uicontrol(figMain, 'style', 'text', ...
	'unit', 'pixels', 'position', pathStrLoc, ...
	'fontsize', 13, 'string', '储存路径',...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor', fontColor);
hPathEdit = uicontrol(figMain, 'style', 'edit', ...
	'unit', 'pixels', 'position', pathEditLoc,...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor', fontColor,...
    'selectionhighlight','off',...
    'fontSize',13);
hPathBtn = uicontrol(figMain, 'style', 'push', ...
	'unit', 'pixels', 'position', pathBtnLoc, ...
	'string', '浏览...','fontsize',13,...
    'backgroundColor',buttonColor,...
    'ForegroundColor', fontColor);   

% 信号生成球状图
hBallTitle = uicontrol(figMain, 'style','text',...
        'unit','pixels','position',[92,340,120,30],...
        'string','信号生成进度','fontsize',14,...
        'backgroundColor',titleBackgroundColor,...
        'ForegroundColor', fontColor );
    
hAxes = axes('unit','pixels', 'position', [50, 140, 200, 200]);
axis([-1,1,-1,1]);
F_circleFill(0 , 1, hAxes);

%选择平均分船或者随即分船
frmPathLoc = [20,8,560,45];
hFrmPath = uicontrol(figMain, 'style', 'frame',...
         'unit','pixels','position', frmPathLoc, ...
        'backgroundColor', frameBackgroundColor,...
         'foregroundColor',frameBackgroundColor);

pathStrLoc = [30,15,100,30];
pathEditLoc = [150,15,300,30];
pathBtnLoc = [460,15,100,30];

hMode= uicontrol(figMain, 'style', 'popup', ...
	'unit', 'pixels', 'position', pathStrLoc, ...
    'foregroundColor',fontColor,...
    'fontWeight','bold',...
    'BackgroundColor',frameBackgroundColor,...
    'fontSize',12,...
	'string', '船舶均匀分布|选择分布模型');
hPathEdit1 = uicontrol(figMain, 'style', 'edit', ...
	'position', pathEditLoc, ...
    'backgroundColor',buttonBackgroundColor,...
    'ForegroundColor', fontColor,...
    'selectionhighlight','off',...
    'fontSize',13);
hPathBtn1 = uicontrol(figMain, 'style', 'push', ...
	'unit', 'pixels', 'position', pathBtnLoc, ...
	'string', '浏览...','fontsize',13,...
    'backgroundColor',buttonColor,...
    'ForegroundColor', fontColor);   

% for i = 1:0.1:10
%     percent = i/10;
%     F_circleFill(percent, 1, hAxes );
%     pause(0.1);
% end

%添加事件处理程序！ 
set(hPathBtn, 'callback', 'CB_choose(hPathEdit);');
set(hPathBtn1, 'callback', 'CB_fileChose1(hPathEdit1)');
set(hGenBtn, 'callback', 'CB_run(hPathEdit, hHeightEdit, hVesNumEdit, hTimeEdit, hEbNoEdit, hPathBtn, hGenBtn, hAxes)');




