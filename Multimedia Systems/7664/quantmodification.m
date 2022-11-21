%Project for Multimedia Systems and Virtual Reality 
%JPEG Compression/Decompression Algorithm
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%Quantization Table modification

%This script tests what result the zeroing of a variable number of AC coefficients has on the
%reconstructed image


clear all
close all
load img1_down;
load img2_down;

[n1 ,n12]=size(img1_down(:,:,1));
[n2 ,n22]=size(img2_down(:,:,1));
%Resize images for Block Partinioning
img1=img1_down(1:n1-mod(n1,8),1:n12-mod(n12,8),:); 
img2=img2_down(1:n2-mod(n2,8),1:n22-mod(n22,8),:); 

%convert image 1 to YCbCr using 4:2:2 Chroma Subsampling
[y1,cb1,cr1]=convert2ycbcr(img1,[4 2 2]);
%convert image 2 to YCbCr 
[y2,cb2,cr2]=convert2ycbcr(img2,[4 4 4]);

%Segment Luminance and Chrominance Elements of each image into 8x8 Blocks
%image 1
[r,col] = size(y1);
y1blocks= mat2cell(y1, 8*ones(1,r/8), 8*ones(1,col/8));
[r,col] = size(cb1);
cb1blocks= mat2cell(cb1, 8*ones(1,r/8), 8*ones(1,col/8));
[r,col] = size(cr1);
cr1blocks= mat2cell(cr1, 8*ones(1,r/8), 8*ones(1,col/8));
%image 2
[r,col] = size(y2);
y2blocks= mat2cell(y2, 8*ones(1,r/8), 8*ones(1,col/8));
[r,col] = size(cb2);
cb2blocks= mat2cell(cb2, 8*ones(1,r/8), 8*ones(1,col/8));
[r,col] = size(cr2);
cr2blocks= mat2cell(cr2, 8*ones(1,r/8), 8*ones(1,col/8));

%Perform DCT Transformation on each 8x8 block of the elements of each image
%image 1
y1dct=blockDCT(y1blocks);
cb1dct=blockDCT(cb1blocks);
cr1dct=blockDCT(cr1blocks);
%image 2
y2dct=blockDCT(y2blocks);
cb2dct=blockDCT(cb2blocks);
cr2dct=blockDCT(cr2blocks);

%vector with desired zero AC coefficients
zeroACs=[20 40 50 60 63];

mat1=abs(cell2mat(y1dct));
mat2=abs(cell2mat(y2dct));
mat3=abs(cell2mat(cb1dct));
mat4=abs(cell2mat(cb2dct));
mat5=abs(cell2mat(cr1dct));
mat6=abs(cell2mat(cr2dct));

max1=max(mat1(:));
max2=max(mat2(:));
max3=max(mat3(:));
max4=max(mat4(:));
max5=max(mat5(:));
max6=max(mat6(:));

maxlum=max(max1,max2);
maxchrom=max([max3 max4 max5 max6]);

%store modified quantization tables in cell array
quantmaty=cell(1,length(zeroACs));
quantmatc=cell(1,length(zeroACs));

                  
qscale1=1; % quantification scale for img1
qscale2=1; %quantification scale for img2

%cell arrays for MSE
MSEvec1=cell(1,length(zeroACs));
MSEvec2=cell(1,length(zeroACs));

for i=1:length(zeroACs)
    len=63-zeroACs(i); 
    
    dcy=16;
    dcq=17;
    
    quantmaty{i}=[dcy ones(1,len) 1024*ones(1,zeroACs(i))];
    quantmaty{i}=vec2mat(quantmaty{i},8);
    quantmatc{i}=[dcq ones(1,len) 1024*ones(1,zeroACs(i))];
    quantmatc{i}=vec2mat(quantmatc{i},8);


%Perform Quantization on the DCT coefficients of each image block
%image 1
qy1=quantizeJPEG(y1dct,quantmaty{i},qscale1);
qcb1=quantizeJPEG(cb1dct,quantmatc{i},qscale1);
qcr1=quantizeJPEG(cr1dct,quantmatc{i},qscale1);
%image 2
qy2=quantizeJPEG(y2dct,quantmaty{i},qscale2);
qcb2=quantizeJPEG(cb2dct,quantmatc{i},qscale2);
qcr2=quantizeJPEG(cr2dct,quantmatc{i},qscale2);

%Dequantize each quantized block
%image 1
dqy1=dequantizeJPEG(qy1,quantmaty{i},qscale1);
dqcb1=dequantizeJPEG(qcb1,quantmatc{i},qscale1);
dqcr1=dequantizeJPEG(qcr1,quantmatc{i},qscale1);
%image 2
dqy2=dequantizeJPEG(qy2,quantmaty{i},qscale2);
dqcb2=dequantizeJPEG(qcb2,quantmatc{i},qscale2);
dqcr2=dequantizeJPEG(qcr2,quantmatc{i},qscale2);

%Peform inverse DCT transform on each dequantized block
%image 1
y11=cell2mat(iBlockDCT(dqy1));
cb11=cell2mat(iBlockDCT(dqcb1));
cr11=cell2mat(iBlockDCT(dqcr1));
%image 2
y22=cell2mat(iBlockDCT(dqy2));
cb22=cell2mat(iBlockDCT(dqcb2));
cr22=cell2mat(iBlockDCT(dqcr2));

%Convert each image back to RGB
%Convert image 1 back to RGB 
rgb1final=convert2rgb(y11,cb11,cr11,[4 2 2]);
%Convert image 2 back to RGB 
rgb2final=convert2rgb(y22,cb22,cr22,[4 4 4]);

MSEvec1{i}=MSEcalc(img1,rgb1final);
MSEvec2{i}=MSEcalc(img2,rgb2final);
%display reconstructed images
figure(i)
subplot(2,2,1)
imshow(img1);
title('Original Image 1');
subplot(2,2,2)
imshow(rgb1final);
title(strcat('Reconstructed Image 1: ',num2str(zeroACs(i)),' Zero AC Coeffs'));
subplot(2,2,3)
imshow(img2);
title('Original Image 2');
subplot(2,2,4)
imshow(rgb2final);
title(strcat('Reconstructed Image 2: ',num2str(zeroACs(i)),' Zero AC Coeffs'));
end

R = @(x) x(1);
G =@(x) x(2);
B=@(x) x(3);

MSER1 = cellfun(R,MSEvec1);
MSEG1 = cellfun(G,MSEvec1);
MSEB1 = cellfun(B,MSEvec1);

MSER2 = cellfun(R,MSEvec2);
MSEG2 = cellfun(G,MSEvec2);
MSEB2 = cellfun(B,MSEvec2);

figure(6)

plot(zeroACs,MSER1,'-.r*')
hold on
plot(zeroACs,MSEG1,'-.g*')
hold on
plot(zeroACs,MSEB1,'-.b*')
hold off

title('Image 1:Zero AC Coefficient/Enc.Image MSE Correlation')
xlabel('Zero AC Coefficients in Quantization tables')
ylabel('MSE')

figure(7)

plot(zeroACs,MSER2,'-.r*')
hold on
plot(zeroACs,MSEG2,'-.g*')
hold on
plot(zeroACs,MSEB2,'-.b*')
hold off

title('Image 2:Zero AC Coefficient/Enc.Image MSE Correlation')
xlabel('Zero AC Coefficients in Quantization tables')
ylabel('MSE')


