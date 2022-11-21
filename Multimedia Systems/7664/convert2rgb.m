function imageRGB = convert2rgb(imageY, imageCr, imageCb, subimg)
%inputs
%imageY=matrix containing Y component of image
%imageCr=matrix containing Cr component of image
%imageCb=matrix containing Cb component of image
%subimg= 1x3 vector containing subsampling mode
%output
%imageRGB= the RGB image

T=[0.299 0.587 0.114; -0.168736 -0.331264 0.5; 0.5 -0.418688 -0.081312];
Tinv = (T^-1);
T=Tinv;
offset = Tinv*[0;128;128];

%if Cb,Cr are subsampled, upsample them using nearest neighbor
%interpolation
if subimg == [4 2 2] 
imageCb=upsample_nn(imageCb,[4 2 2]);
imageCr=upsample_nn(imageCr,[4 2 2]);
end

if subimg == [4 2 0] 
imageCb=upsample_nn(imageCb,[4 2 0]);
imageCr=upsample_nn(imageCr,[4 2 0]);
end

ycbcr=cat(3,imageY,imageCr,imageCb);
imageRGB = zeros(size(ycbcr),'uint8');
for p = 1:3
    imageRGB(:,:,p) = imlincomb(T(p,1),ycbcr(:,:,1),T(p,2),ycbcr(:,:,2), ...
        T(p,3),ycbcr(:,:,3),-offset(p));
end

end

