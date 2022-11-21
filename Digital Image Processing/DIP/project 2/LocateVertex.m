function vertex = LocateVertex( vertices,index,point,edge)
%Project for Digital Image Processing Course
%Vertex Identifier
%Aristotle University of Thessaloniki 2019-2020
%Stefanos Ganotakis 7664
%input:vertices=vertices cell array
%index=reference vertex
%point=current vertex
%edge=index-point distance
%outputs
%vertex=identified vertex

foundvertex=0;
vertex=rand; %initialize
if isempty(vertices{point})
vertex=rand;
else
for id1=1:size(vertices{point},1) %search for matching edges
  
    if (abs(edge-vertices{point}(id1,1))==0 || abs(edge-vertices{point}(id1,2))==0)
    v=vertices{point,2}(id1,:);
    if(~isempty(find(v==index))) %identify index of vertex
       vid=find(v~=index);
       vertex=v(vid);
       foundvertex=1;
    end
    
    end
    
    
end
end



end

