function vertices = findVertices( groupedcorners,minangle,maxangle )
%Project for Digital Image Processing Course
%Canditate Vertex Identifier
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:
%groupedcorners=corner coordinates array (nx2)
%miangle= minimum angle in radians
%maxangle= maximum angle in radians
%outputs
%vertices=cell array with canditate vertices

%find each possible cornerpoint combination indeces

indeces = nchoosek(1:length(groupedcorners),3);
vertexvotes=zeros(length(groupedcorners),1); %
vertices=cell(length(groupedcorners),2);
% minangle=1.55; %82 degrees min angle
% maxangle=1.58; %102 degrees max angle
for i=1:length(indeces)
    %1st case
    x0=groupedcorners(indeces(i,1),1);
    y0=groupedcorners(indeces(i,1),2);
    x1=groupedcorners(indeces(i,2),1);
    y1=groupedcorners(indeces(i,2),2);
    x2=groupedcorners(indeces(i,3),1);
    y2=groupedcorners(indeces(i,3),2);
    x10 = x1-x0;
    y10 = y1-y0;
    x20 = x2-x0;
    y20 = y2-y0; 
    angle = atan2(abs(x10*y20-x20*y10),x10*y10+x20*y20);
    if (angle>=minangle) && (angle<=maxangle) %if angle is between range add vote to corner
        vertexvotes(indeces(i,1))=vertexvotes(indeces(i,1))+1;
        dist1=norm([x0,y0]-[x1,y1]);
        dist2=norm([x0,y0]-[x2,y2]);
        pointsindex=[indeces(i,2),indeces(i,3)];
        normvec=[dist1,dist2];
        [normvec,idx]=sort(normvec);
        pointsindex=pointsindex(idx);
        vertices{indeces(i,1),1}=[vertices{indeces(i,1),1}; normvec];
        vertices{indeces(i,1),2}=[vertices{indeces(i,1),2}; pointsindex];
    end
    %2nd case
    x0=groupedcorners(indeces(i,2),1);
    y0=groupedcorners(indeces(i,2),2);
    x1=groupedcorners(indeces(i,1),1);
    y1=groupedcorners(indeces(i,1),2);
    x2=groupedcorners(indeces(i,3),1);
    y2=groupedcorners(indeces(i,3),2);
    x10 = x1-x0;
    y10 = y1-y0;
    x20 = x2-x0;
    y20 = y2-y0; 
    angle = atan2(abs(x10*y20-x20*y10),x10*y10+x20*y20);
    if (angle>=minangle) && (angle<=maxangle) %if angle is between range add vote to corner
        vertexvotes(indeces(i,2))=vertexvotes(indeces(i,2))+1;
        dist1=norm([x0,y0]-[x1,y1]);
        dist2=norm([x0,y0]-[x2,y2]);
        pointsindex=[indeces(i,1),indeces(i,3)];
        normvec=[dist1,dist2];
        [normvec,idx]=sort(normvec);
        pointsindex=pointsindex(idx);
        vertices{indeces(i,2),1}=[vertices{indeces(i,2),1}; normvec];
        vertices{indeces(i,2),2}=[vertices{indeces(i,2),2}; pointsindex];
    end
    %3rd case
    x0=groupedcorners(indeces(i,3),1);
    y0=groupedcorners(indeces(i,3),2);
    x1=groupedcorners(indeces(i,1),1);
    y1=groupedcorners(indeces(i,1),2);
    x2=groupedcorners(indeces(i,2),1);
    y2=groupedcorners(indeces(i,2),2);
    x10 = x1-x0;
    y10 = y1-y0;
    x20 = x2-x0;
    y20 = y2-y0; 
    angle = atan2(abs(x10*y20-x20*y10),x10*y10+x20*y20);
    if (angle>=minangle) && (angle<=maxangle) %if angle is between range add vote to corner
        vertexvotes(indeces(i,3))=vertexvotes(indeces(i,3))+1;
        dist1=norm([x0,y0]-[x1,y1]);
        dist2=norm([x0,y0]-[x2,y2]);
        pointsindex=[indeces(i,1),indeces(i,2)];
        normvec=[dist1,dist2];
        [normvec,idx]=sort(normvec);
        pointsindex=pointsindex(idx);
        vertices{indeces(i,3),1}=[vertices{indeces(i,3),1}; normvec];
        vertices{indeces(i,3),2}=[vertices{indeces(i,3),2}; pointsindex];
    end
end


end

