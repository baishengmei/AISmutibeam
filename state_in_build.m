function state_in=state_in_build(state_number,state_trans_matrix)
%--------------------------------------------------------------------------
%ͳ��ת�뵽ÿ��״̬�е�״̬���
state_in = zeros(state_number,2);
for i = 1:state_number
    k = 1;
    for j = 1:state_number
        if state_trans_matrix(j,i) == 1
            state_in(i,k) = j;
            k = k+1;
        end
    end
end
%**************************************************************************
