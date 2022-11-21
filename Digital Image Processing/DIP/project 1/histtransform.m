%Project for Digital Image Processing Course
%Point Transform/Histogram Transform
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664

%function histtransform
%inputs
%X= input grayscale image
%h= histogram values
%v=luminance values
%output
%Y= transformed image
function Y = histtransform(X, h, v)
[M N]=size(X);
counter=0;
[xsort index]=sort(X(:)); %sorting X so we can access similar intensities at once
pixels=length(xsort);                         %while keeping in index array the possition of
                          %each pixel
index1=1;
previouspixel=xsort(1);
z=1;
Y=zeros(pixels,1); %creating Y as a vector
while(index1<pixels)
    
    while(xsort(index1)==previouspixel) %same intensitys will be at the same bin
        Y(index(index1))=v(z);
        counter=counter+1;
        index1=index1+1;
    end
    
    
    previouspixel=xsort(index1);
    if((counter/pixels)>=h(z)) % when current bin fills move to the next one
        z=z+1;
        counter=0;
    end  
end

Y=reshape(Y,[M N]); 


            
            
            