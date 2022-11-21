function corners = myDetectHarrisFeatures(I)
%Project for Digital Image Processing Course
%Harris Corner Detector
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:I=image
%output:corners=Harris corners

%if input image is RGB, convert to grayscale
if size(I,3)==3
    I=rgb2gray(I);
end

%check if pixel value range is [0,1], if not cast to dobule
if max(I(:))>1
I=double(I)/255;
end

%parameters
sigma=7; %Gaussian Filter standard deviation, odd number,>=3,default=5
radius=10;
order=(2*radius+1);

%0 <= threhsold <= 1, default=0.1
threshold=0.01;

%derivatives in x and y direction
[dx,dy]=meshgrid(-1:1, -1:1);

Ix=conv2(double(I),dx,'same');
Iy=conv2(double(I),dy,'same');

%Gaussian Filter

% dim = max(1,fix(6*sigma));
% m=dim; n=dim;
% 
% [h1,h2]= meshgrid(-(m-1)/2: (m-1),-(n-1)/2: (n-2)/2);
% hg= exp((-h1.^2+h2.^2)/(2*sigma^2));
% 
% [a,b]=size(hg);
% 
% sum=0;
% 
% for i=1:a
%     for j=1:b
%         sum=sum+hg(i,j);
%     end
% end
% 
% g=hg ./sum;

 g=fspecial('gaussian',max(1,fix(6*sigma)),sigma);

%Smooth squared image derivatives
Ix2=conv2(double(Ix.^2),g,'same');
Iy2=conv2(double(Iy.^2),g,'same');
Ixy=conv2(double(Ix.*Iy),g,'same');

%Harris measure
R= (Ix2.*Iy2 - Ixy.^2) ./ (Ix2+Iy2 +eps);

%Find Local Maxima
mx= ordfilt2(R,order^2,ones(order)); %gray scale dilation filter

% Get the coordinates with maximum cornerness responses
harris_points= (R==mx) & (R>threshold);

%locate unique corners
[rows,cols]=find(harris_points);

%output
corners=[rows cols];

end

