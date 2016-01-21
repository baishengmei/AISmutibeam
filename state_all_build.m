function state_all = state_all_build(L,phase_state)
%--------------------------------------------------------------------------
%构造所有状态
state_number = 2^L*4;                   %计算状态数
for i = 1:L
    for j = 1:state_number/2^(i-1)
        state_all(((j-1)*2^(i-1)+1):j*2^(i-1),i) = 2*mod(j,2)-1;
    end
end
for j = 1:state_number/2^L
    state_all(((j-1)*2^L+1):j*2^L,L+1) = phase_state(j);
end
end
%**************************************************************************
