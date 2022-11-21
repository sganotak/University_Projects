function interp=myBlInterp(img,yx,zpad)
%Project for Digital Image Processing Course
%BiLinear interpolation using 4 pixels around the target location with floor convention
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:img = single layer matrix or a RGB layer colored image
%yx=yx =[y_value, x_value]; 
%zpad=boolean variable (zero padding)
%output:interp=interpolated pixels

if nargin<4,RGB=ndims(img);RGB(RGB<3)=1; end
if nargin<3,zpad=true; end
yx0=floor(yx);
wt=yx-yx0; wtConj=1-wt;
interTop=wtConj(2)*pixLookup(img,yx0(1),yx0(2),zpad,RGB)+wt(2)*pixLookup(img,yx0(1),yx(2),zpad,RGB);
interBtm=wtConj(2)*pixLookup(img,yx(1),yx0(2),zpad,RGB)+wt(2)*pixLookup(img,yx(1),yx(2),zpad,RGB);
interp=wtConj(1)*interTop+wt(1)*interBtm;
end
function pixVal=pixLookup(img,y,x,zpad,RGB)
%  helper function, looks up a pixel value from a given input image
if nargin<4,RGB=3;end
pixVal=zeros(1,1,RGB); %Initialize the pixel 
if nargin<3
    zpad=true; %pad with black pixels
end
if RGB==3
    [ROW,COL,~]=size(img);
else
    [ROW,COL]=size(img);
end
% If the pixel value is outside of image bounds
if (x<=0)||(x>COL)||(y<=0)||(y>ROW) 
    if zpad
        pixVal(:)=0;
    else
        y0=y;x0=x;
        y0(y0<1)=1; x0(x0<1)=1;
        y0(y0>ROW)=ROW;x0(x0>COL)=COL;
        pixVal=img(floor(y0),floor(x0),:);
    end
else
    pixVal=img(floor(y),floor(x),:);
end
end