function rotImg = myImgRotation(img , angle)
%Project for Digital Image Processing Course
%Image Rotation
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:img= image
%angle=rotation angle in rads
%output:rotImg=rotated Image
[rows,cols,z]= size(img); 

%dynamically calculate array dimesions so that rotated image gets fit in it exactly.

rowsf=ceil(rows*abs(cos(angle))+cols*abs(sin(angle)));                      
colsf=ceil(rows*abs(sin(angle))+cols*abs(cos(angle)));                     

% define black canvas with calculated dimensions for rotated image
C=uint8(zeros([rowsf colsf 3 ]));

%calculating center of original and final image
xo=ceil(rows/2);                                                            
yo=ceil(cols/2);

midx=ceil((size(C,1))/2);
midy=ceil((size(C,2))/2);

% in this loop we calculate corresponding coordinates of pixel of original image 
% for each pixel of rotated image via inverse mapping
for i=1:size(C,1)
    for j=1:size(C,2)                                                       
        %calculate rotated coordinates via rotation matrix
         x= (i-midx)*cos(angle)+(j-midy)*sin(angle);                                       
         y= -(i-midx)*sin(angle)+(j-midy)*cos(angle);
         
         %recenter image
         x=x+xo;
         y=y+yo;
        %use bilinear interpolation to get final coordinates
         if (x>=1 && y>=1 && x<=size(img,1) &&  y<=size(img,2) ) 
              C(i,j,:)=myBlInterp(img,[x,y]);
              
         end

    end
end
rotImg=C;
end

