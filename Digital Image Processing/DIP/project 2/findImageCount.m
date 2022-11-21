function imageMasks = findImageCount( binaryMasks,threshold )
%Project for Digital Image Processing Course
%Find unique image mask
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:I=binary Masks, cell array with binary mask
%threshold=pixel count threshold, recommended 50-100
%output:imageMasks=filtered image masks
ind = true(1,numel(binaryMasks)); 
for ii = 1:numel(binaryMasks)-1
    for jj = ii+1:numel(binaryMasks)
        compmask=find(and(binaryMasks{ii},binaryMasks{jj}));
        mask1=find(binaryMasks{ii});
        mask2=find(binaryMasks{jj});
        if abs(length(compmask)-length(mask1))<=threshold 
            ind(jj) = false; 
        end
    end
end
imageMasks = binaryMasks(ind);
end

