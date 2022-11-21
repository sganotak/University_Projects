function dctBlock = dequantizeJPEG(qBlock, qTable, qScale)
%inputs
%qBlock=quantized image
%qTable=quantization table
%qScale=quantization scale
%output
%dctBlock=DCT transformed image

qmat=qTable*qScale;
[n1, n2]= size(qBlock);
dctBlock=cell(n1,n2);

for i=1:n1
    for j=1:n2
        dctBlock{i,j}=qBlock{i,j}.*qmat; 
    end
end

end

