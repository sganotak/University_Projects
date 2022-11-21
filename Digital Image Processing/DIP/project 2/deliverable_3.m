%Project for Digital Image Processing Course
%Image Rotation Demonstration
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%deliverable 3


img=imread('im2.jpg');

%downsample for speed purposes
img=imresize(img,0.2);

%display original image
figure(1)
imshow(img)
title('Original Image');

% Case 1: Rotate image 54*pi/180 rads counterclockwise
figure(2)
rot1=myImgRotation(img,54*pi/180);
imshow(rot1);
title('Rotation by 54*pi/180 rads CCW');

% Case 2: Rotate image 213*pi/180 rads counterclockwise
figure(3)
rot2=myImgRotation(img,213*pi/180);
imshow(rot2);
title('Rotation by 213*pi/180 rads CCW');