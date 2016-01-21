function recvAntGain_dB = calRecvGain(vector_SatToArea, coordinateBeforeThrift, sateThriftAngle)
global antPar;
if exist('antPar', 'var') && ~isempty(antPar)
    xls_data = xlsread(antPar);
else
   xls_data = xlsread('.\接收天线增益\AIS_gain_data(public).xlsx'); 
end

coordinateThrifted = calThriftCoordinate(coordinateBeforeThrift, sateThriftAngle);
[pitch, azimuth] = F_coordinateTransform(coordinateThrifted, vector_SatToArea);
recvAntGain_dB = genRecvGain(pitch, azimuth, xls_data); 
end