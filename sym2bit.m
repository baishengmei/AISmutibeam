function out = sym2bit( x, m )
% out = sym2bit( x, m)
% convert symbols to bit stream
% input:
%     x -- symbol vector
%     m -- symbol dimension
% output:binary vector

% by W.Jiang 2005-03

N = length(x); %number of symbols

if nargin == 1
    m = ceil(log2(max(x)+1));
elseif max(x) > 2^m-1
    error('Error:maximum value of x exceeds 2^m-1.');
end

% % % % % % % % % far from efficiency!!
% out = zeros(1,N*m);
% for ii = 1:N
%     bits = dec2binvec(x(ii));
%     out((ii-1)*m+1:(ii-1)*m+length(bits)) = bits;
% end

% % % % % % % % % efficient enough
% temp = repmat(2.^[0:m-1]',1,N);
% out = reshape(bitand(repmat(x,m,1),temp)./temp,1,N*m);

out = zeros(1,N*m);
for ii = 1:m
    out(ii:m:N*m) = bitget(x,ii);
end
 