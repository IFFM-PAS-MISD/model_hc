function [nodeCoordinates, elementNodes] = ...
rectangularMesh(Lx,Ly,nElementsX,nElementsY,shift_x,shift_y,shift_z)

nodeCoordinatesX = linspace(-Lx/2,Lx/2,nElementsX+1) + shift_x;
nodeCoordinatesY = linspace(-Ly/2,Ly/2,nElementsY+1) + shift_y;
nodeCoordinates = zeros((nElementsX+1)*(nElementsY+1),3);

[XI,YI] = meshgrid(nodeCoordinatesX,nodeCoordinatesY);
nodeCoordinatesX = reshape(XI',[],1);
nodeCoordinatesY = reshape(YI',[],1);
nodeCoordinates(:,1:2) = [nodeCoordinatesX,nodeCoordinatesY];
nodeCoordinates(:,3) = nodeCoordinates(:,3) + shift_z;
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

