%Project for Multimedia Systems and Virtual Reality 
%JPEG Compression/Decompression Algorithm
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%demo 2

clear all
close all

%% PART 1: MSE AND BIT LENGTH CALCULATION
load img1_down;
load img2_down;


qscalevec=[0.1 0.3 0.6 1 2 5 10];%quantization scale vector

n=length(qscalevec);

%initialize
img1encoded=cell(1,n);
img2encoded=cell(1,n);
img1decoded=cell(1,n);
img2decoded=cell(1,n);
bitcounts_img1=zeros(1,n);
bitcounts_img2=zeros(1,n);

%Encode both images for each qScale value
for i=1:n
    img1encoded{1,i}=JPEGencode(img1_down,[4 2 2],qscalevec(i));
    img2encoded{1,i}=JPEGencode(img2_down,[4 4 4],qscalevec(i));
end

%calculate total number of bits for each encoded image
for i=1:n
    img=img1encoded{1,i};
    for j=2:length(img)
bitcounts_img1(i)=bitcounts_img1(i)+length(img{1,j}.huffStream);
    end
    img2=img2encoded{1,i};
    for k=2:length(img2)
bitcounts_img2(i)=bitcounts_img2(i)+length(img2{1,k}.huffStream);
    end
end
    

%Decode images
for i=1:n
    img1decoded{1,i}=JPEGdecode(img1encoded{1,i});
    img2decoded{1,i}=JPEGdecode(img2encoded{1,i});
end

[r, c]=size(img1_down(:,:,1));
[r2,c2]=size(img2_down(:,:,1));
%Resize original images for MSE calculation
img1=img1_down(1:r-mod(r,8),1:c-mod(c,8),:); 
img2=img2_down(1:r2-mod(r2,8),1:c2-mod(c2,8),:); 

%plot the results
figure(1)
h=subplot(3,3,1)
     ax=get(h,'Position');
     ax(4)=ax(4)+0.05; 
     set(h,'Position',ax);
imshow(img1);
title('Original image 1');

for i=1:length(qscalevec)
    h=subplot(3,3,i+1)
     ax=get(h,'Position');
     ax(4)=ax(4)+0.05; 
     set(h,'Position',ax);
    imshow(img1decoded{i});
    title(strcat('Rec. Image 1,Qscale: ',num2str(qscalevec(i))));
end

figure(2)
h=subplot(3,3,1)
     ax=get(h,'Position');
     ax(4)=ax(4)+0.05; 
     set(h,'Position',ax);
imshow(img2);
title('Original image 2');

for i=1:length(qscalevec)
    h=subplot(3,3,i+1)
     ax=get(h,'Position');
     ax(4)=ax(4)+0.05; 
     set(h,'Position',ax);
    imshow(img2decoded{i});
    title(strcat('Rec. Image 2,Qscale: ',num2str(qscalevec(i))));
end


%MSE calculation
%image 1
MSEvec1=cell(1,n);
for i=1:n
    MSEvec1{i}=MSEcalc(img1,img1decoded{1,i});
end
%image 2
MSEvec2=cell(1,n);
for i=1:n
    MSEvec2{i}=MSEcalc(img2,img2decoded{1,i});
end

R = @(x) x(1);
G =@(x) x(2);
B=@(x) x(3);

MSER1 = cellfun(R,MSEvec1);
MSEG1 = cellfun(G,MSEvec1);
MSEB1 = cellfun(B,MSEvec1);

MSER2 = cellfun(R,MSEvec2);
MSEG2 = cellfun(G,MSEvec2);
MSEB2 = cellfun(B,MSEvec2);

figure(3)

plot(bitcounts_img1,MSER1,'-.r*')
hold on
plot(bitcounts_img1,MSEG1,'-.g*')
hold on
plot(bitcounts_img1,MSEB1,'-.b*')
hold off

title('Image 1:Bit-Count/Enc.Image MSE Correlation')
xlabel('bit count of encoded image')
ylabel('MSE')

figure(4)

plot(bitcounts_img2,MSER2,'-.r*')
hold on
plot(bitcounts_img2,MSEG2,'-.g*')
hold on
plot(bitcounts_img2,MSEB2,'-.b*')
hold off

title('Image 2:Bit-Count/Enc.Image MSE Correlation')
xlabel('bit count of encoded image')
ylabel('MSE')


%% PART 2 ENTROPY CALCULATION
    entropymat1=entropycalc(img1,[4 2 2],0.6);
    entropymat2=entropycalc(img2,[4 4 4],5);