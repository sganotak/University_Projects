function runSymbols = huffDec(huffStream,DC,AC)
%inputs
%huffStream=the huffman encoded bitstream
%AC=AC Huffman table
%DC=DC Huffman Table
%output
%runSymbols=run length encoded sequence

%first decode the DC coefficient
runSymbols=[];
mat1 = DC;
for i=1:length(mat1) 
    if strncmp(mat1{i,1},huffStream,length(mat1{i,1}))
        if i==1
            dccoeff2=0;
            huffStream=huffStream(4:end);
            break;
        end
        index=length(mat1{i,1})+1;
        siz=i-1;
        dccoeff=huffStream(index:index+siz-1);
        if dccoeff(1)=='1' %check if positive or negative via ones complement
            dccoeff2=bin2dec(dccoeff);
        elseif dccoeff(1)=='0';
            binvalue=dccoeff;
            binvalue=num2str(not(binvalue-'0'));  % if number is negative calculate one's complement
            binvalue=binvalue(~isspace(binvalue));
            dccoeff2=-bin2dec(binvalue);
            
        end
        huffStream=huffStream(index+siz:end);%delete decoded number from bitstream
        break;
    end
end
rs=[dccoeff2;0];
runSymbols=[runSymbols rs];

%decode the remaining AC coefficients
flag=0;
mat2=AC;
while ~isempty(huffStream)
for i=1:length(mat2)
    if strncmp(mat2{i,1},huffStream,length(mat2{i,1}))
         if i==1 %special case EOB (0,0)
            accoeff2=0;
            zeros=0;
            huffStream=[];
            rs=[accoeff2;zeros];
            runSymbols=[runSymbols rs];
            flag=0;
            break;
         end
         if i==152 %special case ZRL (15,0)
            flag=1; %add 16 zeros to total zero amount and remove ZRL code from stream
            huffStream=huffStream(length(mat2{i,1})+1:end);
         end
         if i<152 %indexing is different for i>152 due to the ZRL element
                if mod(i-1,10)==0
                    zeros=((i-1)/10)-1;
                    size=10;
                else
                    zeros=(i-1 -mod(i-1,10))/10;
                    size=mod(i-1,10);
                end
                if flag==1
                    zeros=zeros+16;
                    flag=0;
                end
         huffStream=huffStream(length(mat2{i,1})+1:end);
         accoeff=huffStream(1:size);
         if accoeff(1)=='1' %check if positive or negative via ones complement
            accoeff2=bin2dec(accoeff);
        else 
            binvalue=accoeff;
            binvalue=num2str(not(binvalue-'0'));  % if number is negative calculate one's complement
            binvalue=binvalue(~isspace(binvalue));
            accoeff2=-bin2dec(binvalue);
         end
         huffStream=huffStream(size+1:end);
         rs=[accoeff2;zeros];
         runSymbols=[runSymbols rs];
         elseif i>152
                if mod(i-2,10)==0
                    zeros=((i-2)/10)-1;
                    size=10;
                else
                    zeros=(i-2 -mod(i-2,10))/10;
                    size=mod(i-2,10);
                end
                if flag==1
                    zeros=zeros+16;
                    flag=0;
                end
                huffStream=huffStream(length(mat2{i,1})+1:end);
                accoeff=huffStream(1:size);
                if accoeff(1)=='1' %check if positive or negative via ones complement
            accoeff2=bin2dec(accoeff);
        else 
            binvalue=accoeff;
            binvalue=num2str(not(binvalue-'0'));  % if number is negative calculate one's complement
            binvalue=binvalue(~isspace(binvalue));
            accoeff2=-bin2dec(binvalue);
                end
         huffStream=huffStream(size+1:end);
         rs=[accoeff2;zeros];
         runSymbols=[runSymbols rs];
         end
         
    end
end
end

end

