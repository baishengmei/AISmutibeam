% ��ȡ����ͼͼƬ�����ļ�������ģ���ļ�
% dirPath: �����ļ���·��
% picLocFile: ��¼��ͼƬ�����ļ���
% numModelFile: ����ģ���ļ���
% picPos: ͼƬλ����Ϣ
% data: ����ģ��
% ����˵��:
% ͼƬ��ȡ��www.MarineTraffic.com
% picLocFile�ļ������ݵ�����Ӧ��ͼƬ������ͬ, ��1��2��ΪͼƬ���Ͻǵľ��Ⱥ�γ��
% ��3��4��ΪͼƬ���½ǵľ��Ⱥ�γ��, ��γ�ȶ�Ӧ��ϵ����:
%		��γ90�㡪����γ90�㣺������ת��Ϊ-90�㡪��90��
%		����180�㡪��0�㡪������180�㣺������ת����-180�㡪��0�㡪�� 180��
% numModelFile�д����data����Ϊ0-9�����ֵ�ģ��
%												------2013.10.9 by Z.x
function [picPos data] = F_loadPicAndNum(dirPath, picLocFileName, numModelFileName)
	picLocFilePath = [dirPath '/' picLocFileName];
	numModelFilePath = [dirPath '/' numModelFileName];
	load(numModelFilePath, 'data');
	picPos = csvread(picLocFilePath);
end