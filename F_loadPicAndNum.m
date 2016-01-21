% 读取各海图图片坐标文件和数字模板文件
% dirPath: 保存文件的路径
% picLocFile: 记录各图片坐标文件名
% numModelFile: 数字模板文件名
% picPos: 图片位置信息
% data: 数字模板
% 程序说明:
% 图片截取自www.MarineTraffic.com
% picLocFile文件中数据的行数应与图片数量相同, 第1、2列为图片左上角的经度和纬度
% 第3、4列为图片右下角的经度和纬度, 经纬度对应关系如下:
%		北纬90°——南纬90°：程序中转换为-90°——90°
%		西经180°——0°——东经180°：程序中转换成-180°——0°—— 180°
% numModelFile中储存的data变量为0-9各数字的模板
%												------2013.10.9 by Z.x
function [picPos data] = F_loadPicAndNum(dirPath, picLocFileName, numModelFileName)
	picLocFilePath = [dirPath '/' picLocFileName];
	numModelFilePath = [dirPath '/' numModelFileName];
	load(numModelFilePath, 'data');
	picPos = csvread(picLocFilePath);
end