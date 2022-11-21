function bytes = interleave(encstream,subimg,row,col )
%inputs
%encstream=the entropy encoded sequence containing the image data
%subimg=chroma subsampling mode
%row=number of rows of image blocks
%col=number of columns of image blocks
%output
%bytes=the sequence encoded into bytes

%Convertion of huffman binary bitstream to byte sequence
stream=cell(1,length(encstream)-1);
%Encode MCUs depending on chroma subsampling
if subimg ==[4 4 4]
    indexY=2;
    indexCb=indexY+row*col;
    indexCr=indexCb+row*col;
elseif subimg ==[4 2 2]
    indexY=2;
    indexCb=indexY+row*col;
    indexCr=indexCb+(row*col)/2;
elseif subimg == [4 2 0]
     indexY=2;
    indexCb=indexY+row*col;
    indexCr=indexCb+(row*col)/4;
end

streamy=encstream(indexY:indexCb-1);
streamCb=encstream(indexCb:indexCr-1);
streamCr=encstream(indexCr:end);

indexY=1;
indexCb=1;
indexCr=1;
index=1;

% 4:4:4 encoding: Y1 Cb1 Cr1 ...
while index<=length(encstream)-1
    if subimg ==[ 4 4 4]
        stream{index}=streamy{indexY}.huffStream;
        index=index+1;
        indexY=indexY+1;
        stream{index}=streamCb{indexCb}.huffStream;
        index=index+1;
        indexCb=indexCb+1;
        stream{index}=streamCr{indexCr}.huffStream;
        index=index+1;
        indexCr=indexCr+1;
    elseif subimg == [4 2 2] % 4:2:2 encoding Y1 Y2 Cb1 Cr1 ...
        for i=1:2
         stream{index}=streamy{indexY}.huffStream;
        index=index+1;
        indexY=indexY+1;
        end
        stream{index}=streamCb{indexCb}.huffStream;
        index=index+1;
        indexCb=indexCb+1;
        stream{index}=streamCr{indexCr}.huffStream;
        index=index+1;
        indexCr=indexCr+1;
    elseif subimg == [4 2 0] %4:2:0 encoding Y1 Y2 Y3 Y4 Cb1 Cr1....
        for i=1:4
         stream{index}=streamy{indexY}.huffStream;
        index=index+1;
        indexY=indexY+1;
        end
        stream{index}=streamCb{indexCb}.huffStream;
        index=index+1;
        indexCb=indexCb+1;
        stream{index}=streamCr{indexCr}.huffStream;
        index=index+1;
        indexCr=indexCr+1;
    end
end
%convert bits to bytes
stream=cell2mat(stream); 
while mod(length(stream),8)>0 %if bitstream length is not evenly divisible by 8 pad 1s at the end of the stream
 stream=strcat(stream,'1');
end
bytes=reshape(stream,8,[]);
bytes=bin2dec(bytes')';
%indexes=find(bytes==255)';
bytes = strrep(bytes, 255, [255, 0]); %insert 0 next to 'FF' byte so that it can't be mistaken as a header during decoding

end

