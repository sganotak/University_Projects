function dctBlock = blockDCT(block)
%inputs
%block=8x8 image block
%output
%dctBlock=8x8 image block after DCT transform
[n1 , n2]= size(block);

dctBlock=cell(n1,n2);
p=8; %precision parameter

for i=1:n1
    for j=1:n2
        dctBlock{i,j}=block{i,j}-2^(p-1); %level shift samples to signed representation
        dctBlock{i,j}=dct2(block{i,j});
    end
end



end

