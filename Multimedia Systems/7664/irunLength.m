function qBlock = irunLength(runSymbols, DCpred)
%Inverse Run Length Encoding
%inputs
%runSymbols=the RLE encoded sequence
%DCpred=DC coefficient of previous block
%qBlock=the quantized DCT image block

d=runSymbols(1,:);%data stream
c=runSymbols(2,:);%number of appereance of each symbol
dccoeff=runSymbols(1,1)+DCpred;%first decode the DC coefficient separately
x=[dccoeff];

ind=2;
for i=2:length(d) %start from 1st AC coefficient (index 2)
    if c(i)==0 && d(i)~=0  %if there are no preceding zeros add symbol to stream
        x(ind)=d(i);
        ind=ind+1;
    elseif c(i)~=0 % if there are preceding zeros add their number to stream
        for k=1:c(i);
            x(ind)=0;
            ind=ind+1;
        end
        x(ind)=d(i);
        ind=ind+1;     
    elseif c(i)==0 && d(i)==0 %special case for EOB (0,0) add zeros until length of original stream is reached 
        for j=ind:64 %upper limit is 64 since we work on 8x8 blocks
            x(j)=0;
        end
    end
end

qBlock=invzigzag(x,8,8);%perform inverse zigzag scan on data stream to create 8x8 block
end