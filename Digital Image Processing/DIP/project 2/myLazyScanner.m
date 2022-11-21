filename=uigetfile('*.jpg');
I = imread(filename);
I_og=I;

%% PART1: IMAGE PREPROCESSING
%parameters
sigma     = 0.05;
threshold = 0.075;
rhoRes    = 1;
thetaRes  = 0.25*pi/180;
nLines    = 15; %recommended 10-30
resscale  = 0.2; %recommended 0.2-0.6
minangle=1.55; %recommended 1.42 for rotated images
maxangle=1.59; %recommended 1.62 for rotated images
%end of parameters

[ogH, ogW] = size(I_og);
I=imresize(I,resscale);
%I2=imresize(I,resscale);
%Imgray2=rgb2gray(I2);
Imgray=rgb2gray(I);
Imgray=double(Imgray) / 255;
%Apply Gaussian Filter to smooth edges
Imgrayfilt=imgaussfilt(Imgray,5);
[imH, imW] = size(Imgrayfilt);
%Create a binary image.

BW = edge(Imgrayfilt,'canny',[0.05 0.1],1);

%% PART 2: HOUGH TRANSFORM
 [H,L,res] = myHoughTransform(BW,rhoRes,thetaRes,nLines);
  thetaScale=(0:size(H,2)-1)*thetaRes;
  rhoScale=(0:size(H,1)-1)*rhoRes;
rho=L(:,1);
theta=L(:,2);

%% LINE INTERSECTION 
linepointsx=cell(nLines,1);
linepointsy=cell(nLines,1);
[~,linestruct]=myHoughRes(I,L);
for i=1:nLines
[lx, ly]=bresenham(linestruct(i).point1(1),linestruct(i).point1(2),linestruct(i).point2(1),linestruct(i).point2(2));
%     idx=find(ly==size(BW,1)); %eliminate out of bounds pixels
%     lx=lx(1:idx);
%     ly=ly(1:idx);
    linepointsx{i}=lx;
    linepointsy{i}=ly;
end


intersections = [];
for i = 1:nLines
  for j = 1:nLines
    if i>=j, continue; end;
    p1 = linestruct(i).rho;
    p2 = linestruct(j).rho;
    t1 = linestruct(i).theta;
    t2 = linestruct(j).theta;

    x = (p1*sin(t2)-p2*sin(t1))/(cos(t1)*sin(t2)-sin(t1)*cos(t2));
    y = (p1*cos(t2)-p2*cos(t1))/(sin(t1)*cos(t2)-cos(t1)*sin(t2));
    if x <= 0 || x > imW || y <= 0 || y > imH, continue; end;
    intersections = [intersections; x, y];
  end
end
figure(1)
imshow(I)
hold on
plot(intersections(:,1),intersections(:,2),'rs')
%% PART 3: HARRIS CORNER DETECTOR

corners=myDetectHarrisFeatures(Imgray);


rows=corners(:,1);
cols=corners(:,2);

figure(2)
imshow(I)
hold on
plot(cols,rows,'rs');

%% PART 4: CROSS REFERENCING AND CORNER POINT NORMALIZATION

%find which Hough line intersections match the corners detected from the Harris
%detector



finalcorners=[]; 
r=50; %radius of mask
masks=cell(1,length(intersections));
for idx=1:length(intersections)
[xgrid, ygrid] = meshgrid(1:size(Imgray,2), 1:size(Imgray,1));
masks{idx} = ((xgrid-intersections(idx,1)).^2 + (ygrid-intersections(idx,2)).^2) <= r.^2;
[y_cord, x_cord] = find(masks{idx}); %locate indeces of mask pixels
maskcord=[y_cord, x_cord];
%if harris corners are found in mask area, keep the intersection, else
%discard
if ~isempty(intersect(corners,maskcord,'rows')) 
    finalcorners=[finalcorners;intersections(idx,:)];
end  
end

figure(3)
imshow(I)
hold on
plot(finalcorners(:,1),finalcorners(:,2),'rs')

%Group close by corners

groupedcorners=finalcorners;



 mindist = 100; % desired minimum distance between two points
 nX = sum(groupedcorners.^2,2);
 d = bsxfun(@plus,nX,nX')-2*groupedcorners*groupedcorners';
 [p,~,r] = dmperm(d<mindist^2);
 nvoxels = diff(r);
 for n=find(nvoxels>1) 
   idx = p(r(n):r(n+1)-1);
   groupedcorners(idx,:) = repmat(mean(groupedcorners(idx,:),1),numel(idx),1); 
   groupedcorners(idx(2:end),:) = nan;
 end
 groupedcorners(any(isnan(groupedcorners),2),:) = [];
 
 groupedcorners=round(groupedcorners);
 groupedcorners=sortrows(groupedcorners);
 
 figure(4)
imshow(I)
hold on
plot(groupedcorners(:,1),groupedcorners(:,2),'rs')

%% PART 5: RECTANGULAR OBJECT DETECTION

%find vertices of perpendicular edges
vertices = findVertices( groupedcorners,minangle,maxangle );
%detect all possible rectangle masks
binaryMasks=findBinaryMasks( groupedcorners,vertices,imH,imW );
%detect image count, 100 pixel threshold
binaryMasks=findImageCount(binaryMasks,100);
%% PART 6: CROPPING , ROTATION CORRECTION AND IMAGE SAVING

binaryMasks_resized=cell(length(binaryMasks),1);
for i=1:length(binaryMasks_resized)
    binaryMasks_resized{i}=imresize(binaryMasks{i},round(1/resscale));
end
measurements=cell(length(binaryMasks),1);
extremapoints=cell(length(binaryMasks),1);
croppedImage=cell(length(binaryMasks),1);

%Method 1: Crop first then rotate, Faster runtime but worse accuracy

for i=1:length(binaryMasks)
    measurements{i} = regionprops(binaryMasks{i}, 'BoundingBox');
    extremapoints{i} = regionprops(binaryMasks{i}, 'Extrema');
%      measurements{i} = regionprops(binaryMasks_resized{i}, 'BoundingBox');
%     extremapoints{i} = regionprops(binaryMasks_resized{i}, 'Extrema');
    %locate rotation angle from extrema points
    pts=extremapoints{i}.Extrema;
    pts_dif=[pts(7,1),1;pts(5,1),1]\[pts(7,2);pts(5,2)];
    angle=atan2(pts_dif(1),1);
    croppedImage{i} = imcrop(I, measurements{i}.BoundingBox);
%      croppedImage{i} = imcrop(I_og, measurements{i}.BoundingBox);
    rotImage=myImgRotation(croppedImage{i},angle);
    str1 = filename(1:end-4);
    str2 = int2str(i); 
    str = [str1 '_' str2 '.jpg'];
    fname = strcat(str);
    imwrite(rotImage,fname);
end

%Method 2: Rotate Mask and starting Image separately and crop afterwards
% has better Accuraccy but slower runtime

% for i=1:length(binaryMasks)
%     extremapoints{i} = regionprops(binaryMasks{i}, 'Extrema');
% %     extremapoints{i} = regionprops(binaryMasks_resized{i}, 'Extrema');
%     %locate rotation angle from extrema points
%     pts=extremapoints{i}.Extrema;
%     pts_dif=[pts(7,1),1;pts(5,1),1]\[pts(7,2);pts(5,2)];
%     angle=atan2(pts_dif(1),1);
%     mask= 255 * repmat(uint8(binaryMasks{i}), 1, 1, 3);
%     mask= 255 * repmat(uint8(binaryMasks_resized{i}), 1, 1, 3);
%     mask=logical(mask);
%     mask=mask(:,:,1);
%     rotmask=myImgRotation(mask,angle);
%     rotImage=myImgRotation(I,angle);
%     %rotImage=myImgRotation(I_og,angle);
%     measurements{i} = regionprops(rotmask, 'BoundingBox');
%     % measurements{i} = regionprops(rotmask, 'BoundingBox');
%     croppedImage{i} = imcrop(rotImage, measurements{i}.BoundingBox);
% %      croppedImage{i} = imcrop(I_og, measurements{i}.BoundingBox);
%     
%     str1 = filename(1:end-4);
%     str2 = int2str(i); 
%     str = [str1 '_' str2 '.jpg'];
%     fname = strcat(str);
%     imwrite(croppedImage{i},fname);
% end
