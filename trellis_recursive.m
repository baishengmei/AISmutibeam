function [next_out, next_state, last_in, last_out, last_state] = trellis_recursive(g_numerator,g_denominator)
% [next_out, next_state, last_out, last_state] = trellis_recursive(g_numerator,g_denominator)
% set up the trellis for recursive convolutional code given code generator,
% no systematic output
% 
% g given in integer matrix form.
% g_denominator represents the feedback connection
% g_numerator and g_denominator have same number of rows;g_denominaor should be a collum vector
% suit for code rsc code rate k0/n0;non-systematic outputs share the same feedback
% output:
%         next_out: matrix, the output in the trellis given current state and input
%                   row index--current state,collum index--input
%         next_state: matrix, the next state given current state and input
%                   row index--current state,collum index--input
%         last_in:  matrix, the input of one edge given the ending state of the edge and edge index
%                   row index--ending state,collum index--edge index.Each state ends 2^k edges.
%         last_out: matrix, the output of one edge given the ending state of the edge and edge index
%                   row index--ending state,collum index--edge index
%         last_state: matrix, the starting state of one edge given the ending state of the edge and edge index
%                   row index--ending state,collum index--edge index
% e.g:
%        __________________________
%        |                        |
%        V       ____    ____     |             g_denominator = [5;7]
% ------(+)------|   |---|   |-----
%              | ----  | ----   
%              |       |        
%              -------(+)----------->--------
%                                           |
%        __________________________        (+)---->
%        |             |          |         |
%        V       ____  | ____     |         |    
% ------(+)------|   |---|   |-----         |
%              | ----    ----  |            |
%              |               |            |
%              ---------------(+)--->--------
%                                               g_numerator = [6;
%                                                              5];
% 
% by Wei Jiang (w.z.jiang@gmail.com), 2011-06
% modified from trellis_rsc.m


% [k0,K] = size(g_numerator);
% n0 = k0+1;
% m = K - 1;
% max_state = 2^m^k0;

[k0,n0] = size(g_numerator);
m = floor(log2(max([g_numerator(:);g_denominator(:)])));
max_state = 2^m^k0;%possiblly no so many states, consider the parallel path 
K = m+1;

% convert g to binary form
g_denominator_mat = zeros(k0,K);
for ii = 1:k0
    g_denominator_mat(ii,:) = fliplr(dec2binvec(g_denominator(ii),K));
end

g_numerator_mat = zeros(k0,K,n0);
for ii = 1:k0
    for jj = 1:n0
        g_numerator_mat(ii,:,jj) = fliplr(dec2binvec(g_numerator(ii,jj),K));
    end
end


% set up next_out and next_state matrices
next_out = zeros(max_state,2^k0);
next_state = zeros(max_state,2^k0);
for state=1:max_state
    state_mat = fliplr(reshape(dec2binvec( state-1, m*k0 ),k0,m));
    for ii = 1:2^k0;%input bit
        input_vec = dec2binvec(ii-1,k0);
        a = mod(sum(g_denominator_mat.*[input_vec.' state_mat],2),2);%feedback
        temp_out = zeros(n0);
        for jj = 1:n0
            out_vec = mod(sum(g_numerator_mat(:,:,jj).*[a state_mat],2),2);
            temp_out(jj) = mod(sum(out_vec),2);
        end
        next_out(state,ii) = binvec2dec(temp_out);
        next_state(state,ii) = binvec2dec(reshape(fliplr([a state_mat(:,1:m-1)]),1,k0*m)) + 1;
    end
end


% % % find out last_state , last_in and last_out
last_in = -ones(max_state,2^k0);
last_state = -ones(max_state,2^k0);
temp_count = zeros(1,max_state);% count the edges have been searched 
for state=1:max_state%start state
    for ii = 1:2^k0;%input bit
        state2 = next_state(state,ii);
        temp_count(state2) = temp_count(state2) + 1;
        last_state(state2,temp_count(state2)) = state;
        last_in(state2,temp_count(state2)) = ii - 1;
        last_out(state2,temp_count(state2)) = next_out(state, ii);
    end 
end
