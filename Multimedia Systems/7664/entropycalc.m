function entropycell = entropycalc( img,subimg,qScale )
%inputs
%img=the image data
%subimg=chroma subsampling mode
%qScale= quantization scale
%outputs
%entropycell=cell matrix containing entropy data
%cell 1=RGB entropy
%cell 2=Quantization entropy
%cell 3=Run Length Encoding entropy

[r ,c]=size(img(:,:,1));
%Resize image for Block Partinioning
img=img(1:r-mod(r,8),1:c-mod(c,8),:); 


%convert image  to YCbCr 
[y,cb,cr]=convert2ycbcr(img,subimg);

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

%create cell array of RLE 

 runsymbolsY=cell(size(qy,1),size(qy,2));
 runsymbolsCb=cell(size(qcb,1),size(qcb,2));
 runsymbolsCr=cell(size(qcr,1),size(qcr,2));


%Perform Run Length encoding on each block
%Y
[r, col]=size(qy);
for i=1:r
    for j=1:col
        block=qy{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        runsymbolsY{i,j}=runLength(block,DCpred);
        DCpred=block(1,1);
    end
end

%Cb
[r, col]=size(qcb);
for i=1:r
    for j=1:col
        block=qcb{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        runsymbolsCb{i,j}=runLength(block,DCpred);
        DCpred=block(1,1);
    end
end

%Cr
[r, col]=size(qcr);
for i=1:r
    for j=1:col
        block=qcr{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        runsymbolsCr{i,j}=runLength(block,DCpred);
        DCpred=block(1,1);
    end
end

entropycell=cell(1,3);

%Calculate entropy for Spatial Domain
R=img(:,:,1);
G=img(:,:,2);
B=img(:,:,3);

%vectorize color matrices
R=reshape(R,1,[]);
G=reshape(G,1,[]);
B=reshape(B,1,[]);

%entropy for color RED
p = arrayfun(@(x)length(find(R==x)), unique(R)) / length(R);
ER= -sum(p.*log2(p));

%entropy for color GREEN
p = arrayfun(@(x)length(find(G==x)), unique(G)) / length(G);
EG= -sum(p.*log2(p));

%entropy for color BLUE
p = arrayfun(@(x)length(find(B==x)), unique(B)) / length(B);
EB= -sum(p.*log2(p));

%Calculate entropy for Quantized DCT Coefficients
[r1, col1]=size(qy);
[r2, col2]=size(qcb);
[r3, col3]=size(qcr);

entropyY=zeros(r1,col1);
entropyCb=zeros(r2,col2);
entropyCr=zeros(r3,col3);

entropyYrs=zeros(r1,col1);
entropyCbrs=zeros(r2,col2);
entropyCrrs=zeros(r3,col3);

%calculate entropy of each quantized block, then average out the entropies
%of all blocks
for i=1:r1
    for j=1:col1
        y=reshape(qy{i,j},1,[]);
        p = arrayfun(@(x)length(find(y==x)), unique(y)) / length(y);
        entropyY(i,j)=-sum(p.*log2(p));
    end
end

entropyY=mean2(entropyY);

for i=1:r2
    for j=1:col2
        y=reshape(qcb{i,j},1,[]);
        p = arrayfun(@(x)length(find(y==x)), unique(y)) / length(y);
        entropyCb(i,j)=-sum(p.*log2(p));
    end
end

entropyCb=mean2(entropyCb);

for i=1:r3
    for j=1:col3
        y=reshape(qcr{i,j},1,[]);
        p = arrayfun(@(x)length(find(y==x)), unique(y)) / length(y);
        entropyCr(i,j)=-sum(p.*log2(p));
    end
end

entropyCr=mean2(entropyCr);

entropyCb=mean2(entropyCb);

%Calculate entropy of each Run Length encoded sequence block then average
%out the entropies of all blocks
for i=1:r1
    for j=1:col1
        y=runsymbolsY{i,j}(1,:);
        p = arrayfun(@(x)length(find(y==x)), unique(y)) / length(y);
        entropyYrs(i,j)=-sum(p.*log2(p));
    end
end

entropyYrs=mean2(entropyYrs);

for i=1:r2
    for j=1:col2
        y=runsymbolsCb{i,j}(1,:);
        p = arrayfun(@(x)length(find(y==x)), unique(y)) / length(y);
        entropyCbrs(i,j)=-sum(p.*log2(p));
    end
end

entropyCbrs=mean2(entropyCbrs);

for i=1:r3
    for j=1:col3
        y=runsymbolsCr{i,j}(1,:);
        p = arrayfun(@(x)length(find(y==x)), unique(y)) / length(y);
        entropyCrrs(i,j)=-sum(p.*log2(p));
    end
end

entropyCrrs=mean2(entropyCrrs);

entropycell{1}=[ER EG EB];
entropycell{2}=[entropyY entropyCb entropyCr];
entropycell{3}=[entropyYrs entropyCbrs entropyCrrs];


end

