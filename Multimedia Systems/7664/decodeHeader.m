function [encodedstream,rows,cols,subimg,qTableL,qTableC,DC_L,DC_C,AC_L,AC_C] = decodeHeader( JPEGencStream )
%input
%JPEGencStream= the encoded image bitstsream
%outputs
%encodedstream=the entropy encoded segment portion of the stream
%rows=number of rows
%cols=number of columns
%subimg=chroma subsampling mode
%qTableL=Luminance Quantization Table
%qTableC=Chrominance Quantization Table
%DC_L= DC Luminance Huffman Table
%DC_C= DC Chrominance Huffman Table
%AC_L= AC Luminance Huffman Table
%AC_C= AC Chrominance Huffman Table

if JPEGencStream(1:2)==[ 255 216]
    %Begin Decoding
    index=3;
    decoding=1; %boolean value,1:decoding in progress 0;decoding finished
    while decoding==1
        if JPEGencStream(index:index+1)==[255 224] %JFIF header
            index=index+2;
            length=hex2dec(strcat(dec2hex(JPEGencStream(index)),dec2hex(JPEGencStream(index+1))));
            index=index+length; %skip through JFIF marker
     
        elseif JPEGencStream(index:index+1)==[255 219] %DQT header
         index=index+2;
         length=hex2dec(strcat(dec2hex(JPEGencStream(index)),dec2hex(JPEGencStream(index+1))));
         index=index+2;
         if JPEGencStream(index)==0 %Luminance Table
             index=index+1;
             qTableL=invzigzag(JPEGencStream(index:index+63),8,8);
             index=index+64;
         elseif JPEGencStream(index)==1 %Chrominance Q Table
             index=index+1;
             qTableC=invzigzag(JPEGencStream(index:index+63),8,8);
             index=index+64;
         end
        elseif JPEGencStream(index:index+1)==[255 192] %SOF Header
            index=index+2;
         length=hex2dec(strcat(dec2hex(JPEGencStream(index)),dec2hex(JPEGencStream(index+1))));
         index=index+3; %find image dimensions
         rows=hex2dec(strcat(dec2hex(JPEGencStream(index),2),dec2hex(JPEGencStream(index+1),2)));
         index=index+2;
         cols=hex2dec(strcat(dec2hex(JPEGencStream(index),2),dec2hex(JPEGencStream(index+1),2)));
         index=index+2; 
         comps=JPEGencStream(index);
         index=index+1;
         compid=zeros(1,comps);
         sampling=zeros(1,comps);
         qtableid=zeros(1,comps);
         for i=1:comps %calculate chroma subsampling used
             compid(i)=JPEGencStream(index);
             sampling(i)=JPEGencStream(index+1);
             qtableid(i)=JPEGencStream(index+2);
             index=index+3;
         end
         if sampling==[17 17 17]
            subimg=[4 4 4];
         elseif sampling==[33 17 17]
            subimg=[4 2 2];
         elseif sampling ==[34 17 17]
            subimg=[4 2 0];
         end
        elseif JPEGencStream(index:index+1)==[255 196] %DHT Header
            index=index+2;
            length=hex2dec(strcat(dec2hex(JPEGencStream(index)),dec2hex(JPEGencStream(index+1))));
            dht=JPEGencStream(index+2:index+length-1); %sequence containing all the DHT symbols
            [DC_L,DC_C,AC_L,AC_C]=decodeDHTheader(dht); %decode the Huffman Tables
            index=index+length;
        elseif JPEGencStream(index:index+1)==[255 218] %SOS Header
            index=index+2;
            length=hex2dec(strcat(dec2hex(JPEGencStream(index)),dec2hex(JPEGencStream(index+1))));
            index=index+length;
            if JPEGencStream(end-1:end)==[255 217]
                encodedstream=JPEGencStream(index:end-2); %isolate the entropy encoded segment
            else
              error('EOI marker missing');  
            end
            decoding=0;
        end
    end
else
    error('Invalid Header');
end

end

