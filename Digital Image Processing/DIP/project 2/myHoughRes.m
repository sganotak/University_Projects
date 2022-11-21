function [res,s] = myHoughRes( I,L)
%Project for Digital Image Processing Course
%Hough Residuals calculator
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:I=image
%L=Hough Lines Vector
%output:res=hough residuals
%s=struct with cartesian hough lines
rho=L(:,1);
theta=L(:,2);
numLines = numel(rho); 
linepoint1=cell(numLines,1); %start point of line
linepoint2=cell(numLines,1); %endpoint of line
linepixels=[]; %pixel coordinates of all hough lines
pointsx=cell(length(L),1);
pointsy=cell(length(L),1);
field1 = 'point1';
field2 = 'point2';
field3 = 'rho';
field4 = 'theta';
s = struct(field1,{},field2,{},field3,{},field4,{});

%// These are constant and never change
x0 = 1;
xend = size(I,2); %// Get the width of the image

%// For each rho,theta pair...
for idx = 1 : numLines
    r = rho(idx); th = theta(idx); %// Get rho and theta

    %// if line is vertical
    if (th == 0)
       
    linepoint1{idx}=[r,1];
    linepoint2{idx}=[r,size(I,1)];
    else
        %// Compute starting y coordinate
        y0 = (-cos(th)/sin(th))*x0 + (r / sin(th)); 

        %// Compute ending y coordinate
        yend = (-cos(th)/sin(th))*xend + (r / sin(th));
        linepoint1{idx}=[x0,y0];
        linepoint2{idx}=[xend,yend];
    end
    %we use Bresenham's algorithm to compute pixel values of all lines found
    %on image
    [lx, ly]=bresenham(linepoint1{idx}(1),linepoint1{idx}(2),linepoint2{idx}(1),linepoint2{idx}(2));
    idx2=find(ly==size(I,1)); %eliminate out of bounds pixels
    lx=lx(1:idx2);
    ly=ly(1:idx2);
    linepixels=[linepixels;[lx ly]];
    s(idx).point1=[linepoint1{idx}(1),linepoint1{idx}(2)];
    s(idx).point2=[linepoint2{idx}(1),linepoint2{idx}(2)];
    s(idx).rho=rho(idx);
    s(idx).theta=theta(idx);
    
end
linepixels=unique(linepixels,'rows');%find unique pixel combinations
res=size(I,1)*size(I,2)-length(linepixels); %residuals=total pixels-unique line pixels

end

