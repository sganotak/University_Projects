function block = iBlockDCT(dctBlock)
%inputs
%dctBlock=DCT transformed image
%output 
%block=cell containing original image segmented into 8x8 blocks

[n1 n2]= size(dctBlock);
block=cell(n1,n2);
p=8; %precision parameter

for i=1:n1
    for j=1:n2
        block{i,j}=idct2(dctBlock{i,j});
        %block{i,j}=block{i,j}+2^(p-1); %level shift samples to signed representation
        block{i,j}=uint8(block{i,j});
    end
end

end

