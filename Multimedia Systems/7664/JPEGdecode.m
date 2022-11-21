function imgRec = JPEGdecode(JPEGenc)
%JPEG decoder
%input
%JPEGenc=cell vector containing encoded image data
%output
%imgRec=the reconstructed image


%Quantization and Huffman Tables
qTableL=JPEGenc{1,1}.qTableL;
qTableC=JPEGenc{1,1}.qTableC;
DCL=JPEGenc{1,1}.DCL;
DCC=JPEGenc{1,1}.DCC;
ACL=JPEGenc{1,1}.ACL;
ACC=JPEGenc{1,1}.ACC;

rowy=1;
coly=1;
rowcb=1;
colcb=1;
rowcr=1;
colcr=1;

for i=2:length(JPEGenc)
    if strcmp(JPEGenc{1,i}.blkType,'Y')
        rowy=max(JPEGenc{1,i}.indHor,rowy);
        coly=max(JPEGenc{1,i}.indVer,coly);
    elseif strcmp(JPEGenc{1,i}.blkType,'Cb')
        rowcb=max(JPEGenc{1,i}.indHor,rowcb);
        colcb=max(JPEGenc{1,i}.indVer,colcb);
    elseif strcmp(JPEGenc{1,i}.blkType,'Cr')
         rowcr=max(JPEGenc{1,i}.indHor,rowcr);
        colcr=max(JPEGenc{1,i}.indVer,colcr);
    end
end


%calculate chroma subsampling
if  rowy/rowcb==1 && coly/colcb==1
    subimg=[4 4 4];
elseif floor(rowy/rowcb)==1 && floor(coly/colcb)==2
    subimg= [4 2 2];
elseif floor(rowy/rowcb)==2 && floor(coly/colcb)==2
    subimg= [4 2 0];
end

%initialize entropy encoded tables
huffstreamY=cell(rowy,coly);
huffstreamCb=cell(rowcb,colcb);
huffstreamCr=cell(rowcr,colcr);


%fill in entropy encoded tables
for i=2:length(JPEGenc)
    if strcmp(JPEGenc{1,i}.blkType,'Y')
        huffstreamY{JPEGenc{1,i}.indHor,JPEGenc{1,i}.indVer}=JPEGenc{1,i}.huffStream;
    elseif strcmp(JPEGenc{1,i}.blkType,'Cb')
        huffstreamCb{JPEGenc{1,i}.indHor,JPEGenc{1,i}.indVer}=JPEGenc{1,i}.huffStream;
    elseif strcmp(JPEGenc{1,i}.blkType,'Cr')
        huffstreamCr{JPEGenc{1,i}.indHor,JPEGenc{1,i}.indVer}=JPEGenc{1,i}.huffStream;
    end
end
qy=cell(rowy,coly);
qcb=cell(rowcb,colcb);
qcr=cell(rowcr,colcr);

%inverse Run Length Encoding
%Y Coefficient
for i=1:rowy
    for j=1:coly
        stream=huffstreamY{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        symbols=huffDec(stream,DCL,ACL);
        qy{i,j}=irunLength(symbols,DCpred);
        DCpred=qy{i,j}(1,1);
        
    end
end

%Cb Coefficient
for i=1:rowcb
    for j=1:colcb
        stream=huffstreamCb{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        symbols=huffDec(stream,DCC,ACC);
        qcb{i,j}=irunLength(symbols,DCpred);
        DCpred=qcb{i,j}(1,1);
        
    end
end

%Cr Coefficient
for i=1:rowcr
    for j=1:colcr
        stream=huffstreamCr{i,j};
        if i==1 && j==1
            DCpred=0;     
        end
        symbols=huffDec(stream,DCC,ACC);
        qcr{i,j}=irunLength(symbols,DCpred);
        DCpred=qcr{i,j}(1,1);
        
    end
end

%Dequantize each quantized block
dqy=dequantizeJPEG(qy,qTableL,1);
dqcb=dequantizeJPEG(qcb,qTableC,1);
dqcr=dequantizeJPEG(qcr,qTableC,1);

%Peform inverse DCT transform on each dequantized block
y1=cell2mat(iBlockDCT(dqy));
cb1=cell2mat(iBlockDCT(dqcb));
cr1=cell2mat(iBlockDCT(dqcr));

imgRec=convert2rgb(y1,cb1,cr1,subimg);
end