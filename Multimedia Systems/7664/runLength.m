function runSymbols = runLength(qBlock, DCpred)
%Run Length Encoding
%inputs
%qBlock=the quantized image block
%DCpred=DC coefficient of the previous image block
%outputs
%runSymbols= RLE encoded sequence

%first perform zigzag scanning on qblock
qvec=zigzag(qBlock);

d(1)=qvec(1)-DCpred; %DC coefficient is coded seperately
c(1)=0;%run length of DC coefficient is zero

ind=2;
zeros=0; 
for i=2:length(qvec)
    if qvec(i)==0; 
        zeros=zeros+1;
    else
        d(ind)=qvec(i);
        c(ind)=zeros;
        zeros=0;
        ind=ind+1;
    end
    if i==length(qvec) && zeros~=0
        d(ind)=0;
        c(ind)=0;
    end
end

runSymbols=vertcat(d,c);%append symbols and run length on RX2 matrix
end