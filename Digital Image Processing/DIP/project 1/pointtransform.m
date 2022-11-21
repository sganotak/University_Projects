%Project for Digital Image Processing Course
%Point Transform/Histogram Transform
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664

%function pointtransform
%inputs
%X= input image
%[x1,x2,y1,y2]= coordinates
%output
%Y=transformed image

function Y = pointtransform(X, x1, y1, x2, y2)

%Part 1 calculate line equation slope

slope1=(y1-0)/(x1-0);
slope2=(y2-y1)/(x2-x1);
slope3=(1-y2)/(1-x2);


[M N]=size(X);
Y=zeros(M,N);

for i=1:M
    for j=1:N
        if(X(i,j)<x1)
            Y(i,j)=slope1*(X(i,j)-0)+0; 
        elseif(X(i,j)>=x1 &&X(i,j)<=x2)
            Y(i,j)=slope2*(X(i,j)-x1)+y1;
        else
            Y(i,j)=slope3*(X(i,j)-x2)+y2;
        end
    end
end


