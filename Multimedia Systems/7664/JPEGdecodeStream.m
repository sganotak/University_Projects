function imgCmp = JPEGdecodeStream(JPEGencStream)
%JPEG Syntax decoder
%input
%JPEGencStream=bitstream containing encoded image data
%output
%imgCmp =the reconstructed image

%first decode the Header
[encodedstream,rows,cols,subimg,qTableL,qTableC,DC_L,DC_C,AC_L,AC_C] = decodeHeader( JPEGencStream );

%Find Block Dimensions of each Component according to subsampling
  yrows=rows/8;
  ycols=cols/8;
if subimg==[4 4 4]
    cbcrrows=rows/8;
    cbcrcols=cols/8;
elseif subimg==[4 2 2]
    cbcrrows=rows/8;
    cbcrcols=cols/16;
elseif subimg==[4 2 0]
    cbcrrows=rows/16;
    cbcrcols=cols/16;
end

%first cell contents (Quantization and Huffman Tables)
hufftable1=cell(1,1);
hufftable2=cell(1,1);
hufftable3=cell(1,1);
hufftable4=cell(1,1);
hufftable1{1,1}=DC_L;
hufftable2{1,1}=DC_C;
hufftable3{1,1}=AC_L;
hufftable4{1,1}=AC_C;
s=struct('qTableL',qTableL,'qTableC',qTableC,'DCL',hufftable1,'DCC',hufftable2,'ACC',hufftable4,'ACL',hufftable3);

JPEGenc=cell(1,yrows*ycols+cbcrrows*cbcrcols+cbcrrows*cbcrcols+1);
JPEGenc{1}=s;

%First convert to binary bitsream
stream = strrep(encodedstream, [255 0], 255);
stream=dec2bin(stream,8);
stream=reshape(stream',1,[]);

%decode the entropy encoded stream
%initialize indexes
indHorY=1;
indVerY=1;
indHorCb=1;
indVerCb=1;
indHorCr=1;
indVerCr=1;
index=2; %index of final struct
%Decoding order depends on subsampling
%decoding finishes when the last block of the Cr component is decoded
decoding=1;%boolean value
if subimg==[4 4 4]
    while decoding==1;
        %decode Y first
        [Ystream,stream]=bufferStream(stream,DC_L,AC_L);
        s=struct('blkType','Y','indHor',indHorY,'indVer',indVerY,'huffStream',Ystream);
        JPEGenc{index}=s;
        index=index+1;
        indVerY=indVerY+1;
        if indVerY>ycols;
            indVerY=1;
            indHorY=indHorY+1;
        end
        %then decode Cb
        [Cbstream,stream]=bufferStream(stream,DC_C,AC_C);
        s=struct('blkType','Cb','indHor',indHorCb,'indVer',indVerCb,'huffStream',Cbstream);
        JPEGenc{index}=s;
        index=index+1;
        indVerCb=indVerCb+1;
        if indVerCb>cbcrcols;
            indVerCb=1;
            indHorCb=indHorCb+1;
        end
        %finally decode Cr
        [Crstream,stream]=bufferStream(stream,DC_C,AC_C);
        s=struct('blkType','Cr','indHor',indHorCr,'indVer',indVerCr,'huffStream',Crstream);
        JPEGenc{index}=s;
        index=index+1;
        indVerCr=indVerCr+1;
        if indVerCr>cbcrcols;
            indVerCr=1;
            indHorCr=indHorCr+1;
            if indHorCr>cbcrrows
                decoding=0;
            end
        end
    end
elseif subimg==[4 2 2]
 while decoding==1
     for i=1:2
        %decode Y first
        [Ystream,stream]=bufferStream(stream,DC_L,AC_L);
        s=struct('blkType','Y','indHor',indHorY,'indVer',indVerY,'huffStream',Ystream);
        JPEGenc{index}=s;
        index=index+1;
        indVerY=indVerY+1;
        if indVerY>ycols;
            indVerY=1;
            indHorY=indHorY+1;
        end
     end
        %then decode Cb
        [Cbstream,stream]=bufferStream(stream,DC_C,AC_C);
        s=struct('blkType','Cb','indHor',indHorCb,'indVer',indVerCb,'huffStream',Cbstream);
        JPEGenc{index}=s;
        index=index+1;
        indVerCb=indVerCb+1;
        if indVerCb>cbcrcols;
            indVerCb=1;
            indHorCb=indHorCb+1;
        end
        %finally decode Cr
        [Crstream,stream]=bufferStream(stream,DC_C,AC_C);
        s=struct('blkType','Cr','indHor',indHorCr,'indVer',indVerCr,'huffStream',Crstream);
        JPEGenc{index}=s;
        index=index+1;
        indVerCr=indVerCr+1;
        if indVerCr>cbcrcols;
            indVerCr=1;
            indHorCr=indHorCr+1;
            if indHorCr>cbcrrows
                decoding=0;
            end
        end
    end
elseif subimg==[4 2 0]
   while decoding==1
     for i=1:4
        %decode Y first
        [Ystream,stream]=bufferStream(stream,DC_L,AC_L);
        s=struct('blkType','Y','indHor',indHorY,'indVer',indVerY,'huffStream',Ystream);
        JPEGenc{index}=s;
        index=index+1;
        indVerY=indVerY+1;
        if indVerY>ycols;
            indVerY=1;
            indHorY=indHorY+1;
        end
     end
        %then decode Cb
        [Cbstream,stream]=bufferStream(stream,DC_C,AC_C);
        s=struct('blkType','Cb','indHor',indHorCb,'indVer',indVerCb,'huffStream',Cbstream);
        JPEGenc{index}=s;
        index=index+1;
        indVerCb=indVerCb+1;
        if indVerCb>cbcrcols;
            indVerCb=1;
            indHorCb=indHorCb+1;
        end
        %finally decode Cr
        [Crstream,stream]=bufferStream(stream,DC_C,AC_C);
        s=struct('blkType','Cr','indHor',indHorCr,'indVer',indVerCr,'huffStream',Crstream);
        JPEGenc{index}=s;
        index=index+1;
        indVerCr=indVerCr+1;
        if indVerCr>cbcrcols;
            indVerCr=1;
            indHorCr=indHorCr+1;
            if indHorCr>cbcrrows
                decoding=0;
            end
        end
    end  
end


imgCmp=JPEGdecode(JPEGenc);

end

