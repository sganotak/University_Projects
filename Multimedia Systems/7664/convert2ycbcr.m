function [imageY, imageCb, imageCr] = convert2ycbcr(imageRGB, subimg)
%inputs
%imageRGB=the RGB image
%subimage= chroma subsampling mode
%outputs
%imageY=matrix containing Y component of image
%imageCr=matrix containing Cr component of image
%imageCb=matrix containing Cb component of image


%Split image into R,G,B channels
R = imageRGB(:,:,1);
G = imageRGB(:,:,2);
B = imageRGB(:,:,3);

%Transformation Matrix
T=[0.299 0.587 0.114; -0.168736 -0.331264 0.5; 0.5 -0.418688 -0.081312];

offset = [0;128;128];

    
for p = 1:3
 ycbcr(:,:,p) = imlincomb(T(p,1),R,T(p,2),G, T(p,3),B,offset(p));
end

imageY= ycbcr(:,:,1);
imageCb=ycbcr(:,:,2);
imageCr=ycbcr(:,:,3);

%4:2:2 Chroma Subsampling 
if subimg == [4 2 2] 
 [row,col]=size(imageCb);
imageCb=imresize(imageCb,[row col/2]);
imageCr=imresize(imageCr,[row col/2]);
end

%4:2:0 Chroma Subsampling 
if subimg == [4 2 0] 
imageCb=imresize(imageCb,0.5);
imageCr=imresize(imageCr,0.5);
end



end

