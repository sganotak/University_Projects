%Project for Multimedia Systems and Virtual Reality 
%JPEG Compression/Decompression Algorithm
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%demo 3

load img1_down;
load img2_down;


qscalevec=[0.1 0.3 0.6 1 2 5 10];%quantification scale vector

n=length(qscalevec);

%initialize
img1encoded=cell(1,n);
img2encoded=cell(1,n);
img1decoded=cell(1,n);
img2decoded=cell(1,n);
filesizes_img1=zeros(1,n);
filesizes_img2=zeros(1,n);

%Encode both images for each qScale value
for i=1:n
    img1encoded{1,i}=JPEGencodeStream(img1_down,[4 2 2],qscalevec(i));
    img2encoded{1,i}=JPEGencodeStream(img2_down,[4 4 4],qscalevec(i));
end

%Create binary files of encoded images 
for i=1:n
    name=strcat('image1q',num2str(qscalevec(i)),'.bin');
    fileID = fopen(name,'w');
    fwrite(fileID,img1encoded{1,i});
    fclose(fileID);
    f=dir(name);
    filesizes_img1(i)=f.bytes;
    name2=strcat('image2q',num2str(qscalevec(i)),'.bin');
    fileID = fopen(name2,'w');
    fwrite(fileID,img2encoded{1,i});
    fclose(fileID);
    f=dir(name2);
    filesizes_img2(i)=f.bytes;
end

f=dir('img1_down.mat');
filesize_img1=f.bytes;
f=dir('img2_down.mat');
filesize_img2=f.bytes;

%Calculate Compression Rate
Comp_rate_img1=filesize_img1./filesizes_img1;
Comp_rate_img2=filesize_img2./filesizes_img2;

%Decode Images 

%for i=1:n
   % img1decoded{1,i}=JPEGdecodeStream(img1encoded{1,i});
   % img2decoded{1,i}=JPEGdecodeStream(img2encoded{1,i});
%end