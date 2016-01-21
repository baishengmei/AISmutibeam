function out = bit2sym( x, m )
% out = bit2sym( x, m )
% convert bit stream to symbols
% input:
%     x binary vector
%     m symbol dimension
% output:symbol vector

% by W.Jiang 2005-03

if nargin == 1
    m = length(x);
elseif mod(length(x),m) > 0 % zero padding 
    x(length(x)+1:length(x)+m-mod(length(x),m)) = 0;
end

% % % far from efficiency!!
% out = zeros(1,length(x)/m);
% for ii = 1:length(out)
%     out(ii) = binvec2dec(x((ii-1)*m+1:ii*m));
% end
    
N = round(length(x)/m); %number of symbols
out = sum(reshape(x,m,N).*repmat(2.^[0:m-1].',1,N),1);


% % % wrong.logical index returns vector
% bit_logic = logical(reshape(x,m,N));
% temp = 2.^[0:m-1].';
% temp = temp(:,ones(1,N));
% out = sum(temp(bit_logic));

