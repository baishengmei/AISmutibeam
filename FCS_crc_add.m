function [ output ] = FCS_crc_add( input )
%  the function is proposed for adding crc bits to the input sequence
k = size(input,2);
crc_no=16;

output = zeros(1,k+crc_no);
generator = [1 0 0 0 1 0 0 0 0 0 0 1 0 0 0 0 1]; %D^16+D^12+D^5+1
output(1:crc_no)=mod((input(1:crc_no)+1),2); %x^16*G(x)+x^k(x^15+x^14+...+x+1)
output(crc_no+1:k)=input(crc_no+1:k);
for ii = 1:k
    if(output(1) == 1)
        output(1:crc_no+1) = mod((output(1:crc_no+1)+generator),2);
    end
    output = [output(2:end) output(1)];
end
output(1:crc_no)=mod((output(1:crc_no)+1),2);%FCS是余数的反码
output = [input output(1:crc_no)];
end
