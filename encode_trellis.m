function out = encode_trellis(x,next_out,next_state,m,terminated)
% out = encode_trellis(x,next_state,next_out,m,terminated)
% convolutional encoder based on trellis diagram
% next_state begins with 1
% next_out begins with 0
% m -- number of stages, not number of registers
% set terminated > 0 to terminate the coding. m*k0 tailing bits is padded,
% though less bits may be sufficient,especially for out-buffer structure.
% This may lead to many ways to terminate,thus different output tails,
% depending on the search methord.


% by W.Jiang , 2005.5

nstates = size(next_out,1);          % number of states in the trellis
k0 = round(log2(size(next_out,2)));
n0 = round(log2(max(next_out(:))+1));

N = round(length(x)/k0); % Length of the trellis,excluding tail bits

out = zeros(1,n0*N);
state = 1;%[0 0 0 ... 0]
for ii = 1:N
    input = bit2sym(x((ii-1)*k0+1:ii*k0))+1;
    out((ii-1)*n0+1:ii*n0) = sym2bit(next_out(state,input),n0);
    state = next_state(state,input);
end

%terminate
if terminated > 0
    tail_input = zeros(1,m);
    tail_out = zeros(1,m*n0);
    for ii = 1:2^k0^m
        temp_state = state;
        temp_input = reshape(sym2bit(ii-1,k0*m),m,k0);
        for jj = 1:m
            tail_input(jj) = bit2sym(temp_input(jj,:))+1;
            temp_state = next_state(temp_state,tail_input(jj));
        end
        if temp_state == 1
            for jj = 1:m
                tail_out((jj-1)*n0+1:jj*n0) = sym2bit(next_out(state,tail_input(jj)),n0);
                state = next_state(state,tail_input(jj));
            end
            out = [out tail_out];
            return;
        end
    end
end
