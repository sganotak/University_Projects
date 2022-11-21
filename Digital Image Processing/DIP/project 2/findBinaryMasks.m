function binmasks_final = findBinaryMasks( groupedcorners,vertices,imH,imW )
%Project for Digital Image Processing Course
%Binary Mask creator
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:groupedcorners=nx2 corner array
% vertices=canditate vertex cell aray
% imH=image Height
% imW=image Width
%output:binmasks_final=cell array with located binary masks
num=1;
binmasks=cell(50,1);

for i=1:length(vertices) %for each canditate vertex
    if isempty(vertices{i}) 
        continue;
    else
        for j=1:size(vertices{i},1) %check if connected points are also canditate vertices
            point1=vertices{i,2}(j,1);
            edge1=vertices{i,1}(j,1);
            point2=vertices{i,2}(j,2);
            edge2=vertices{i,1}(j,2);
             if isempty(vertices{point1}) || isempty(vertices{point2})
            v1=0;
            v2=1;
             else %find 4th point of rectangle, if matching 
                v1=LocateVertex( vertices,i,point1,edge1);
                v2=LocateVertex( vertices,i,point2,edge2); 
             end
            if (v1==v2) %create mask from rectangle
                k1=i;
                k2=point1;
                k4=point2;
                k3=v2;
                binmasks{num}=poly2mask([groupedcorners(k1,1),groupedcorners(k2,1),groupedcorners(k3,1),groupedcorners(k4,1)], [groupedcorners(k1,2),groupedcorners(k2,2),groupedcorners(k3,2),groupedcorners(k4,2)],imH,imW);
                num=num+1;
            end
        end
    end
end

%eliminate duplicate masks
num=find(~cellfun(@isempty,binmasks));

ind = true(1,numel(num)); %// true indicates non-duplicate. Initiallization
for ii = 1:numel(num)-1
    for jj = ii+1:numel(num)
        if isequal(binmasks{ii}, binmasks{jj})
            ind(jj) = false; %// mark as duplicate
        end
    end
end
binmasks_final = binmasks(ind);


end

