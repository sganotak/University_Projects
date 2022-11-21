function header = createHeader(row,col,subimg,qTableL,qTableC)
%inputs
%row=number of rows of image
%col=number of columns of image
%subimg= chroma subsampling mode
%qTableL=Luminance Quantization Table
%qTableC=Chrominance Quantization Table

%Start of image Marker
SOI(1) = hex2dec('FF');
SOI(2) = hex2dec('D8');

%JFIF Header
JFIF(1)=hex2dec('FF');
JFIF(2)=hex2dec('E0');
JFIF(3)=0;
JFIF(4)=16; %JFIF header length (always 16 bytes)
JFIF(5)=hex2dec('4A');
JFIF(6)=hex2dec('46');
JFIF(7)=hex2dec('49');
JFIF(8)=hex2dec('46');
JFIF(9)=hex2dec('00'); %JFIF identifier
JFIF(10)=1;
JFIF(11)=2; %version
JFIF(12)=0; %units
JFIF(13)=0;
JFIF(14)=1;% X density
JFIF(15)=0;
JFIF(16)=1;% Y density
JFIF(17)=0;% X thumnbail
JFIF(18)=0;% Y thumbnail

%Quantization Tables (DQT) header
%Luminance Table
DQT(1)=hex2dec('FF');
DQT(2)=hex2dec('DB');
DQT(3)=0;
DQT(4)=67; %we use 8 bit tables so length is always 67 bytes
DQT(5)=00; %table id, 0: Luminance 1:Chrominance
DQT=[DQT zigzag(qTableL)]; %apply zig zag scanning on Quantization table and fill out the sequence
%Chrominance Table
DQT2(1)=hex2dec('FF');
DQT2(2)=hex2dec('DB');
DQT2(3)=0;
DQT2(4)=67; 
DQT2(5)=01; 
DQT2=[DQT2 zigzag(qTableC)];


Y = dec2hex(row,4);
X = dec2hex(col,4);
%Start of Frame (SOF) header
 SOF(1) = hex2dec('FF');
 SOF(2) = hex2dec('C0'); %baseline sequential DCT
 SOF(3) = 0;
 SOF(4) = 17;%length
 SOF(5) = 8; %precision 
 SOF(6) = hex2dec(Y(1,1:2));%next 2 bytes represent image height
 SOF(7) = hex2dec(Y(1,3:4));
 SOF(8) = hex2dec(X(1,1:2));%next 2 bytes represent image width
 SOF(9) = hex2dec(X(1,3:4));
 SOF(10) = 3; %3 components (YCbCr)
 index = 11;
 CompID = [1 2 3]; %vector of component ids 1:Y 2:Cb 3:Cr
 QtableNumber = [0 1 1]; % Quantization Table ids 0:Luminance 1:Chrominance

 if subimg==[4 4 4] %sampling factor Hmax/H, Vmax/V
    HsampFactor = [1 1 1];
    VsampFactor = [1 1 1];
 elseif subimg== [4 2 2]
    HsampFactor = [2 1 1];
    VsampFactor = [1 1 1];
 elseif subimg == [4 2 0]
    HsampFactor = [2 1 1];
    VsampFactor = [2 1 1];
 end
 for i = 1:SOF(10) 
        SOF(index) = CompID(i);
        index = index + 1;
        SOF(index) = bitshift(HsampFactor(i), 4) + VsampFactor(i);
        index = index + 1;
        SOF(index) = QtableNumber(i);
        index = index + 1;
 end
 
 %Define Huffman Table (DHT) header
 DHT=encodeDHTheader();
 
 %Start of Scan (SOS) header
SOS(1) = hex2dec('FF');
SOS(2) = hex2dec('DA');
SOS(3) = 0;
SOS(4) = 12; %length, always 12 for Color images
SOS(5) = 3; %3 components (YCbCr) same as one defined in SOF
SOS(6)= 1; %Component id 1:Y
SOS(7)=0; %Huffman Tables used for Y DC/AC
SOS(8)= 2; %Component id 2:Cb
SOS(9)=bitshift(1, 4) + 1; %Huffman Tables used for Cb DC/AC
SOS(10)= 3; %Component id 2:Cr
SOS(11)=bitshift(1, 4) + 1; %Huffman Tables used for Cr DC/AC
SOS(12)=0; %start of selection= 0 for baseline JPEG
SOS(13)=63;%end of selection=63 for baseline JPEG
SOS(14)=0;% succesive approcimation, always 0

%Join headers together
header=[SOI JFIF DQT DQT2 SOF  DHT SOS];


end

