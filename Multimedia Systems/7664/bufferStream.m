function [streambuffer,huffStream] = bufferStream( huffStream,DC,AC )
%inputs
%huffStream=Huffman encoded bitstream
%DC=DC Huffman Table
%AC=AC Huffman Table
%outputs
%streambuffer=buffer containing the bitstream of the block
%HuffStream= the remaining stream

%first add the DC component to the buffer
streambuffer=[];
mat1 = DC;
for i=1:length(mat1) 
    if strncmp(mat1{i,1},huffStream,length(mat1{i,1}))
        if i==1
            size=0;
            streambuffer=huffStream(1:3);
            huffStream=huffStream(4:end);
            break;
        else
        index=length(mat1{i,1});
        siz=i-1;
        streambuffer=huffStream(1:index+siz);
       huffStream=huffStream(index+siz+1:end);%delete decoded number from bitstream
       break;
        end
    end
end

%locate AC components until EOB and add to buffer
flag=1;
mat2=AC;
while flag==1
for i=1:length(mat2)
    if strncmp(mat2{i,1},huffStream,length(mat2{i,1}))
        if i==1 %special case EOB (0,0)
            flag=0;
            size=0;
            streambuffer=[streambuffer huffStream(1:length(mat2{i,1})+size)];
            huffStream=huffStream(length(mat2{i,1})+size+1:end); 
            break;
        elseif i<152
                if mod(i-1,10)==0
                    size=10;
                else
                    size=mod(i-1,10);
                end
         elseif i>152
                if mod(i-2,10)==0
                    size=10;
                else
                    size=mod(i-2,10);
                end
        elseif i==152
            size=0;
        end
       streambuffer=[streambuffer huffStream(1:length(mat2{i,1})+size)];
       huffStream=huffStream(length(mat2{i,1})+size+1:end); 
    end
 end
end

end

