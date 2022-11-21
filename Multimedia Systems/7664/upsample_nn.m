function upsampledimg = upsample_nn( img,subimg )
%Simple implementation of nearest neighbour interpolation
%inputs
%Img=the image data
%subimg=chroma subsampling
%output
%upsampledimg=the upsampled image data

 % Define Resample size
[row,col]=size(img);

if subimg == [4 2 2]
    
    col=col*2;
end

if subimg == [4 2 0]
    row=row*2;
    col=col*2;
end



%Find old size to new size ratio
rtR = row/size(img,1);
rtC = col/size(img,2);

%Obtain the interpolated positions
IR = ceil([1:(size(img,1)*rtR)]./(rtR));
IC = ceil([1:(size(img,2)*rtC)]./(rtC));


%Row wise interpolation
Temp = img(IR,:);
%Columnwise interpolation
Inter = Temp(:,IC);





Output=zeros([row,col]);
Output=Inter;

upsampledimg = uint8(Output);

end

