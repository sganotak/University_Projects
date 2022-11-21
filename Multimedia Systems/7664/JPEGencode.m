 function JPEGenc = JPEGencode(img, subimg, qScale)
 %JPEG encoder
 %inputs
 %img=the image
 %subimg=chroma subsampling mode
 %qScale=quantization scale
 %output
 %JPEGenc= cell vector containing encoded image data
 
  load HuffmanTables;
 
[r ,c]=size(img(:,:,1));
%Resize image for Block Partinioning
%img=img(1:r-mod(r,8),1:c-mod(c,8),:);

%Resize image until dimensions are divisible by 8
while mod(r,8)~=0
    r=r-1;
end

while mod(c,8)~=0
    c=c-1;
end

img=img(1:r,1:c,:);

%convert image  to YCbCr 
[y,cb,cr]=convert2ycbcr(img,subimg);

%repeat image resize procedure for cb,cr components in case we have
%subsampling

[r,c]=size(cb);

while mod(r,8)~=0
    r=r-1;
end

while mod(c,8)~=0
    c=c-1;
end
cb=cb(1:r,1:c);
cr=cr(1:r,1:c);


%Divide Luminance and Chrominance Elements of  image into 8x8 Blocks
[r,col] = size(y);
yblocks= mat2cell(y, 8*ones(1,r/8), 8*ones(1,col/8));
[r,col] = size(cb);
cbblocks= mat2cell(cb, 8*ones(1,r/8), 8*ones(1,col/8));
[r,col] = size(cr);
crblocks= mat2cell(cr, 8*ones(1,r/8), 8*ones(1,col/8));

%Perform DCT Transformation on each 8x8 block of the elements of each image
ydct=blockDCT(yblocks);
cbdct=blockDCT(cbblocks);
crdct=blockDCT(crblocks);

q_y =     [16 11 10 16 24 40 51 61; %luminance quantization matrix
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56; 
            14 17 22 29 51 87 80 62;
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];
        
 q_cbcr =  [17 18 24 47 99 99 99 99; %chrominance quantization matrix
            18 21 26 66 99 99 99 99;
            24 26 56 99 99 99 99 99; 
            49 66 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99];
        
%Perform Quantization on the DCT coefficients of each image block
%image 1
qy=quantizeJPEG(ydct,q_y,qScale);
qcb=quantizeJPEG(cbdct,q_cbcr,qScale);
qcr=quantizeJPEG(crdct,q_cbcr,qScale);

%create cell array for output
n1=size(qy,1)*size(qy,2);
n2=size(qcb,1)*size(qcb,2);
n3=size(qcr,1)*size(qcr,2);

%initialize
JPEGenc=cell(1,n1+n2+n3+1);

%first cell contents
hufftable1=cell(1,1);
hufftable2=cell(1,1);
hufftable3=cell(1,1);
hufftable4=cell(1,1);
hufftable1{1,1}=DC_L;
hufftable2{1,1}=DC_C;
hufftable3{1,1}=AC_L;
hufftable4{1,1}=AC_C;
s=struct('qTableL',q_y*qScale,'qTableC',q_cbcr*qScale,'DCL',hufftable1,'DCC',hufftable2,'ACC',hufftable4,'ACL',hufftable3);
JPEGenc{1,1}=s;
index=2;
%Perform Run Length encoding on each block
%Y
 DC=DC_L;
 AC=AC_L;
[r, col]=size(qy);
for i=1:r
    for j=1:col
        block=qy{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        runsymbols=runLength(block,DCpred);
        DCpred=block(1,1);
        huffstreamY{i,j}=huffEnc(runsymbols,DC_L,AC_L);
        s=struct('blkType','Y','indHor',i,'indVer',j,'huffStream',huffstreamY{i,j});
        JPEGenc{1,index}=s;
        index=index+1;
    end
end
 DC=DC_C;
 AC=AC_C;
%Cb
[r, col]=size(qcb);
for i=1:r
    for j=1:col
        block=qcb{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        runsymbols=runLength(block,DCpred);
        DCpred=block(1,1);
        huffstreamCb{i,j}=huffEnc(runsymbols,DC_C,AC_C);
       s=struct('blkType','Cb','indHor',i,'indVer',j,'huffStream',huffstreamCb{i,j});
        JPEGenc{1,index}=s;
        index=index+1;
    end
end

[r, col]=size(qcr);

for i=1:r
    for j=1:col
        block=qcr{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        runsymbols=runLength(block,DCpred);
        DCpred=block(1,1);
        huffstreamCr{i,j}=huffEnc(runsymbols,DC_C,AC_C);
        s=struct('blkType','Cr','indHor',i,'indVer',j,'huffStream',huffstreamCr{i,j});
        JPEGenc{1,index}=s;
        index=index+1;
    end
end


        



end

