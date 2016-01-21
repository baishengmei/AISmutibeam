function state_trans_matrix = state_trans_build(state_number,L,state_all)
%--------------------------------------------------------------------------
%¹¹Ôì×´Ì¬×ªÒÆ¾ØÕó
state_trans_matrix = zeros(state_number,state_number);
for i = 1:state_number
    index = mod(i-1,4);
    index2 = mod((state_all(i,L+1) + state_all(i,L)*pi/2)/(pi/2),4);
    state_trans_matrix(i,index2*2^L+index*2+1:index2*2^L+index*2+2) = 1;
end
%**************************************************************************
