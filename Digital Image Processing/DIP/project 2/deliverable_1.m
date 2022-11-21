%Project for Digital Image Processing Course
%Hough Transform Demonstration
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%deliverable 1


I_og  = imread('im2.jpg');

%% PART1: IMAGE PREPROCESSING
%parameters
scale=0.5; 
sigma     = 0.05;
threshold = 0.075;
rhoRes    = 1;
thetaRes  = 0.25*pi/180;
nLines    = 20;
%end of parameters


I=imresize(I_og,scale);
Imgray=rgb2gray(I);
Imgray=double(Imgray) / 255;
%Apply Gaussian Filter to smooth edges
Imgray=imgaussfilt(Imgray,5);
[imH, imW] = size(Imgray);
%Create a binary image.

BW = edge(Imgray,'canny',[0.05 0.1],1);

%% PART 2: HOUGH TRANSFORM
 [H,L,res] = myHoughTransform(BW,rhoRes,thetaRes,nLines);
  thetaScale=(0:size(H,2)-1)*thetaRes;
  rhoScale=(0:size(H,1)-1)*rhoRes;
rho=L(:,1);
theta=L(:,2);
 
     
%% PART 3: PLOT HOUGH SPACE AND HOUGH TRANSFORM LINES
%Hough Space
figure(1)
imshow(imadjust(H./ max(H(:))),[],...
       'XData',thetaScale*180/pi,...
       'YData',rhoScale,'InitialMagnification','fit');
xlabel('\theta (degrees)')
ylabel('\rho')
axis on
axis normal 
hold on
colormap(gca,hot)
x = (180/pi)*theta;
y = rho;
plot(x,y,'s','color','green');
title('Hough Space');

%Hough Lines
figure(2)
imshow(I_og); %// Show the image
hold on; %// Hold so we can draw lines
numLines = numel(rho); %// or numel(theta);
linepoint1=cell(numLines,1);
linepoint2=cell(numLines,1);
linepixels=[];
%// These are constant and never change
x0 = 1;
%xend = size(BW,2); %// Get the width of the image
xend= size(I_og,2);
%// For each rho,theta pair...
for idx = 1 : numLines
    r = rho(idx); th = theta(idx); %// Get rho and theta
    r=r./scale; %rescale rho to original image size
    %// if a vertical line, then draw a vertical line centered at x = r
    if (th == 0)
        line([r r], [1 size(I_og,1)], 'Color', 'red');
    else
        %// Compute starting y coordinate
        y0 = (-cos(th)/sin(th))*x0 + (r / sin(th)); %// Note theta in degrees to respect your convention
        %// Compute ending y coordinate
        yend = (-cos(th)/sin(th))*xend + (r / sin(th));
        %// Draw the line
        line([x0 xend], [y0 yend], 'Color', 'red');
    end
    
end