function [nodeCoordinates, elementNodes] = ...
rectangularMesh(Lx,Ly,nElementsX,nElementsY)

nodeCoordinatesX = linspace(-Lx/2,Lx/2,nElementsX+1);
nodeCoordinatesY = linspace(-Ly/2,Ly/2,nElementsY+1);
nodeCoordinates = zeros((nElementsX+1)*(nElementsY+1),3);

for jElementsY = 1:nElementsY+1;
    for iElementsX = 1:nElementsX+1;
        nodeCoordinates(iElementsX+(jElementsY-1)*(nElementsX+1),1) =...
            nodeCoordinatesX(iElementsX);
        nodeCoordinates(iElementsX+(jElementsY-1)*(nElementsX+1),2) =...
            nodeCoordinatesY(jElementsY);
        
    end
end
elementNodes=zeros((nElementsX)*(nElementsY),4);
for jElementsY=1:nElementsY;
    for iElementsX=1:nElementsX;
        elementNodes(iElementsX+(jElementsY-1)*(nElementsX),1) =...
            iElementsX+(jElementsY-1)*(nElementsX+1);
        elementNodes(iElementsX+(jElementsY-1)*(nElementsX),2) =...
            iElementsX+(jElementsY-1)*(nElementsX+1)+1;
        elementNodes(iElementsX+(jElementsY-1)*(nElementsX),4) =...
            iElementsX+(jElementsY-1)*(nElementsX+1)+(nElementsX+1);
        elementNodes(iElementsX+(jElementsY-1)*(nElementsX),3) =...
            iElementsX+(jElementsY-1)*(nElementsX+1)+(nElementsX+1)+1;
    end
end

end
