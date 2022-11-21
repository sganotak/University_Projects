function JPEGencStream = JPEGencodeStream(img, subimg, qScale)
%JPEG syntax encoder
 %inputs
 %img=the image
 %subimg=chroma subsampling mode
 %qScale=quantization scale
 %output
 %JPEGencStream= bitstream containing encoded image data (JFIF template)
 
[row ,col]=size(img(:,:,1));
%img=img(1:r-mod(r,8),1:c-mod(c,8),:); 
if subimg==[4 4 4]
while mod(row,8)~=0
    row=row-1;
end

while mod(col,8)~=0
    col=col-1;
end
elseif subimg==[4 2 2]
   
while mod(row,8)~=0
    row=row-1;
end

while mod(col,8)~=0 || mod(col,16)~=0
    col=col-1;
end

elseif subimg==[4 2 0]
    
while mod(row,8)~=0 || mod(row,16)~=0
    row=row-1;
end

while mod(col,8)~=0 || mod(col,16)~=0
    col=col-1;
end
end

img=img(1:row,1:col,:);
JPEGenc = JPEGencode(img, subimg, qScale);

qTableL=JPEGenc{1}.qTableL;
qTableC=JPEGenc{1}.qTableC;
DCL=JPEGenc{1}.DCL;
DCC=JPEGenc{1}.DCC;
ACL=JPEGenc{1}.ACL;
ACC=JPEGenc{1}.ACC;

header=createHeader(row,col,subimg,qTableL,qTableC);

%MCU dimension
blockrow=row/8;
blockcol=col/8;

%Bytes of Huffman Encoded Sequence
bytestream=interleave(JPEGenc,subimg,blockrow,blockcol );

% End of image marker
 eoi(1) = hex2dec('FF');
 eoi(2) = hex2dec('D9');

 %Concatenate Coding + Header
 JPEGencStream=[header bytestream eoi];

end

