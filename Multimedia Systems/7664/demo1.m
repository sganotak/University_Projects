%Project for Multimedia Systems and Virtual Reality 
%JPEG Compression/Decompression Algorithm
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%demo 1

clear all
close all
%% PART 1
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

%YCbCr elements of image 1
figure(1);
y11=imresize(y1,[496 248]);
ycbcr1= cat(3, y11,cb1,cr1);

lb={'Y','Cb','Cr'};

for channel=1:3
h=subplot(1,3,channel);
YCBCR_C=ycbcr1;
YCBCR_C(:,:,setdiff(1:3,channel))=intmax(class(YCBCR_C))/2;
if channel==1
    imshow(y1)
else
imshow(ycbcr2rgb(YCBCR_C))
end
title([lb{channel} ' component'],'FontSize',15);
end

%image 2 YCbCr color space representation
ycbcr2= cat(3, y2,cb2,cr2);
figure(2)
imshow(ycbcr2);
title('image 2:YCbCr Color Space','FontSize',15);

%YCbCr elements of image 2
figure(3);

lb={'Y','Cb','Cr'};

for channel=1:3
subplot(1,3,channel)
YCBCR_C=ycbcr2;
YCBCR_C(:,:,setdiff(1:3,channel))=intmax(class(YCBCR_C))/2;
imshow(ycbcr2rgb(YCBCR_C))
title([lb{channel} ' component'],'FontSize',18);
end

%Convert image 1 back to RGB 
rgb1=convert2rgb(y1,cb1,cr1,[4 2 2]);
%Convert image 2 back to RGB 
rgb2=convert2rgb(y2,cb2,cr2,[4 4 4]);

figure(4)
imshow(rgb1);
title('Image 1','FontSize',15);

figure(5)
imshow(rgb2);
title('Image 2','FontSize',15);


%% PART 2 

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

q_y =     [16 11 10 16 24 40 51 61; %luminance quantization matrix
            12 12 14 19 26 58 60 55;
            14 13 16 24 40 57 69 56; 
            14 17 22 29 51 87 80 62;
            18 22 37 56 68 109 103 77;
            24 35 55 64 81 104 113 92;
            49 64 78 87 103 121 120 101;
            72 92 95 98 112 100 103 99];
           
          
        
 q_cbcr =  [17 18 24 47 99 99 99 99; %chrominance quantization matrix
            18 21 26 66 99 99 99 99;
            24 26 56 99 99 99 99 99; 
            49 66 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99;
            99 99 99 99 99 99 99 99];
           
        
qscale1=0.6; % quantification scale for img1
qscale2=5; %quantification scale for img2

%Perform Quantization on the DCT coefficients of each image block
%image 1
qy1=quantizeJPEG(y1dct,q_y,qscale1);
qcb1=quantizeJPEG(cb1dct,q_cbcr,qscale1);
qcr1=quantizeJPEG(cr1dct,q_cbcr,qscale1);
%image 2
qy2=quantizeJPEG(y2dct,q_y,qscale2);
qcb2=quantizeJPEG(cb2dct,q_cbcr,qscale2);
qcr2=quantizeJPEG(cr2dct,q_cbcr,qscale2);

%Dequantize each quantized block
%image 1
dqy1=dequantizeJPEG(qy1,q_y,qscale1);
dqcb1=dequantizeJPEG(qcb1,q_cbcr,qscale1);
dqcr1=dequantizeJPEG(qcr1,q_cbcr,qscale1);
%image 2
dqy2=dequantizeJPEG(qy2,q_y,qscale2);
dqcb2=dequantizeJPEG(qcb2,q_cbcr,qscale2);
dqcr2=dequantizeJPEG(qcr2,q_cbcr,qscale2);

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

%% PLOTS
%Block Segmentation
figure(6)
[rows, columns, numberOfColorChannels] = size(img1);
subplot(1,2,1)
imshow(rgb1);
title('Image 1 Block Segmentation','FontSize',11);
hold on;
for row = 8:8:rows
        line([1, columns], [row, row], 'Color', 'k');
end
for col = 8:8:columns
        line([col, col], [1, rows], 'Color', 'k');
end
subplot(1,2,2)
imshow(rgb2);
title('Image 2 Block Segmentation','FontSize',11);
[rows, columns, numberOfColorChannels] = size(img2);
hold on;
for row = 8:8:rows
        line([1, columns], [row, row], 'Color', 'k');
end
for col = 8:8:columns
        line([col, col], [1, rows], 'Color', 'k');
end


%plot image 2 DCT transform
dctim2=cat(3,cell2mat(y2dct),cell2mat(cb2dct),cell2mat(cr2dct));
[rows, columns, numberOfColorChannels] = size(img2);
figure(7)
imshow(dctim2);
title('Image 2:Block DCT Transformation','FontSize',15);
hold on;
for row = 8:8:rows
        line([1, columns], [row, row], 'Color', 'k');
end
for col = 8:8:columns
        line([col, col], [1, rows], 'Color', 'k');
end

qim2=cat(3,cell2mat(qy2),cell2mat(qcb2),cell2mat(qcr2));
[rows, columns, numberOfColorChannels] = size(img2);

figure(8)
imshow(qim2);
title('Image 2:Quantized DCT Blocks','FontSize',15);
hold on;
for row = 8:8:rows
        line([1, columns], [row, row], 'Color', 'k');
end
for col = 8:8:columns
        line([col, col], [1, rows], 'Color', 'k');
end

%display reconstructed images
figure(9)
subplot(1,2,1)
imshow(rgb1);
title('Original Image 1','FontSize',15);
subplot(1,2,2)
imshow(rgb1final);
title('Reconstructed Image 1','FontSize',15);

figure(10)
subplot(1,2,1)
imshow(rgb2);
title('Original Image 2','FontSize',15);
subplot(1,2,2)
imshow(rgb2final);
title('Reconstructed Image 2','FontSize',15);


