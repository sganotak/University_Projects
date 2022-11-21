function qBlock = quantizeJPEG(dctBlock, qTable, qScale)
%Quantization
%inputs
%dctBlock=dct transformed image
%qTable=quantization table
%qScale=quantization Scale
%outputs
%qBlock=the quantized image block
qmat=qTable*qScale;
[n1, n2]= size(dctBlock);
qBlock=cell(n1,n2);

for i=1:n1
    for j=1:n2
        qBlock{i,j}=round(dctBlock{i,j}./qmat); 
    end
end

end

