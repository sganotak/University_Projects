function [H,L,res] = myHoughTransform(img_binary, Drho, Dtheta,n)
%Project for Digital Image Processing Course
%Hough Transformation
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:img_binary=binary image
%Drho=rho resolution
%Dtheta=theta resolution
%n=desired number of lines/local maxima
%output:H= Hough accumulator
%L=hough lines array
%res=residuals value

%parameters
threshold=0.075;
%end of parameters

img_binary = img_binary';
    [w, h] = size(img_binary);
    maxRho = ceil(norm([w, h])/Drho); %Diagonal
    rhoNum = maxRho + 1; 
    thetaNum = 2.0*pi / Dtheta;
    
    i = 1:thetaNum;
    thetaScale = (Dtheta * (i-1));


    rhoScale = (0:Drho:(Drho*maxRho));
    rhoBin = [rhoScale - 0.5*Drho, Drho*maxRho + 0.5*Drho];
    
    Imidx = find(img_binary > threshold); %locate indeces of pixels over threshold
    s = size(img_binary);
    [subx, suby] = ind2sub(s, Imidx); %convert linear index to subscript
    
    subx = subx - 1;
    suby = suby - 1;

    H = zeros([rhoNum, thetaNum]); %initialize Hough accumulator

    thetax = subx * cos(thetaScale); 
    thetay = suby * sin(thetaScale);
    rho = thetax + thetay; %r=x*cos(theta)+y*sin(theta)

    for i=1:thetaNum
        H(:,i) = histcounts(rho(:, i), rhoBin)'; %increment accumulator bin of each found rho theta pair
    end
    
rows = size(H, 1);
cols = size(H, 2);

padH = padarray(H, [1,1]);

rhos = zeros(n, 1);
thetas = zeros(n, 1);

for n = 1:n
    [~, lin_i] = max(padH(:)); %find local maxima
    [i, j] = ind2sub([rows+2, cols+2], lin_i);
    r = i - 1;
    c = j - 1;
    rhos(n) = r;
    thetas(n) = c;
    padH(i-1:i+1, j-1:j+1) = 0;
end


thetaScale=(0:size(H,2)-1)*Dtheta;
rhoScale=(0:size(H,1)-1)*Drho;

L=[rhoScale(rhos); thetaScale(thetas)]';

[res,~]=myHoughRes(img_binary',L);

end