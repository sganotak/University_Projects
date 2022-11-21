%Project for Digital Image Processing Course
%Harris Corner Detector Demonstration
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%deliverable 2


ogimg=imread('im2.jpg');

scale=0.2;

%downsample for speed purposes
img=imresize(ogimg,scale);

img=rgb2gray(img);

%display original image
figure(1)
subplot(1,2,1)
imshow(img)
title('Original Image');

%Harris Corner Detection Algorithm
corners=myDetectHarrisFeatures(img);

%rescale the located corners to original image size
rows=round(corners(:,1)./scale);
cols=round(corners(:,2)./scale);

%plot corners on original image
subplot(1,2,2)
imshow(ogimg)
hold on
plot(cols,rows,'rs');
title('Harris Corners');