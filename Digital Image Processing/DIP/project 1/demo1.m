%Project for Digital Image Processing Course
%Point Transform/Histogram Transform
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664

%demo 1: Point Transform


clear all
close all


% Load image , and convert it to gray -scale
 x = imread('lena.bmp');
 x = rgb2gray(x);
 x = double(x) / 255;
 % Original Image
 % Show the histogram of intensity values
 figure(1)
 imshow(x);
 title('Original image');
 [hn , hx] = hist(x(:), 0:1/255:1);
 figure(2)
 hn=100.*hn./sum(hn);
 bar(hx , hn)
 title('Original histogram');
 xlabel('Intensity')
 ylabel('Histogram %')

 % Point Transform [0.1961, 0.0392, 0.8039, 0.9608]
 x1=pointtransform(x,0.1961, 0.0392, 0.8039, 0.9608);
 figure(3)
 imshow(x1);
 title('Point Transform 0.1961, 0.0392, 0.8039, 0.9608');
  % Show the histogram of intensity values
 [hn , hx] = hist(x1(:), 0:1/255:1);
 figure(4)
 hn=100.*hn./sum(hn);
 bar(hx , hn)
 title('Histogram of Point Transform 0.1961, 0.0392, 0.8039, 0.9608');
 xlabel('Intensity')
 ylabel('Histogram %')
 
  % Point Transform Binary
  x2=pointtransform(x,0.5, 0, 0.5, 1);
 figure(5)
 imshow(x2);
 title('Binary Point Transform');
 % Show the histogram of intensity values
 [hn , hx] = hist(x2(:), 0:1/255:1);
 figure(6)
 hn=100.*hn./sum(hn);
 bar(hx , hn)
 title('Binary histogram');
 xlabel('Intensity')
 ylabel('Histogram %')
 
 
 
 
