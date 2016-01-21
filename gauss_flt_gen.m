function [gt,qt] = gauss_flt_gen(BT, Rb, os, L)
% Generate Gaussian filter
%
% Input: 
%     BT 	 -	3-dB bandwidth times symbol interval
%     Rb     -  bit rate, in bps
%     os     -  oversample rate
%     L      -  length of trancated filter, in T, default is 3
% Output:
%     gt     -  frequency shaping filter
%     qt     -  phase shaping filter, integration of gt
%
% by Wei Jiang (w.z.jiang@gmail.com), 2011-06


if (exist('L','var')~=1)||isempty(L),                 L = 3; end

T = 1/Rb;                   % symbol interval
B = BT/T;                   % 3-dB bandwidth
fs = Rb*os;                 % sample rate

%--------------------------------------------------------------------------
% g(t)
n = L * os;
mid = n/2;
t = (-mid:1:mid-1)/fs;
gt = 1/2*( erf(-sqrt(2/log(2))*pi*B*(t-1/2*T)) + ...
           erf(sqrt(2/log(2))*pi*B*(t+1/2*T)) );
gt = gt./os./2;

%--------------------------------------------------------------------------
% q(t)
qt = cumsum(gt);
