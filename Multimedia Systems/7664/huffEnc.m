function  huffStream = huffEnc(runSymbols,DC,AC)
%inputs
%runSymbols=the Run Length encoded sequence
%DC=DC Huffman Table
%AC=AC Huffman Table
%output
%huffStream= the huffman encoded bitstream

 mat1 = DC;
huffStream=[];
%first encode the DC coefficient
dccoeff=runSymbols(1,1);
binvalue=dec2bin(abs(dccoeff)); 
if dccoeff<0
    binvalue=num2str(not(binvalue-'0'));  % if number is negative calculate one's complement
binvalue=binvalue(~isspace(binvalue));
end
index=length(dec2bin(abs(dccoeff)))+1; %scan the DC matrix for prefix code
if dccoeff==0
    index=1;
end
huffStream=[huffStream strcat(mat1{index,1},binvalue)]; %append bit code to bitstream

mat2=AC;
%encode the remaining AC coefficients
for i=2:length(runSymbols)
    accoeff=runSymbols(1,i);
    rl=runSymbols(2,i);
    while rl>15 %special case for ZRL (15,0)
        rl=rl-16;
        huffStream=[huffStream mat2{152,1}];
    end
    binvalue=dec2bin(abs(accoeff)); 
if accoeff<0
    binvalue=num2str(not(binvalue-'0'));
    binvalue=binvalue(~isspace(binvalue));% if number is negative calculate one's complement
end
if accoeff==0 && rl==0; %special case for EOB(0,0)
    huffStream=[huffStream mat2{1,1}];
elseif accoeff~=0
size=length(binvalue);
index=10*rl+size+1; %scan AC matrix for prefix code
if rl==15
    index=10*rl+size+2; 
end
huffStream=[huffStream strcat(mat2{index,1},binvalue)];
end
end

end

