% piezo function

function [P,forceNode,U_pD]=structure_force(structure_i)
% structure_i=structure(i);
GDof = structure_i.GDof;
nodeCoordinates = structure_i.nodeCoordinates;
prescribedDof = structure_i.prescribedDof;
numberNodes_pl = size(nodeCoordinates,1);
forceNode_range = structure_i.forceNode_range;
stShape = structure_i.stShape;
U_pD = zeros(length(prescribedDof),1);
Pn = structure_i.Pn; 
P = zeros(GDof,size(Pn,1));
tol = 1e-8;
scale = 1e4;   
if size(forceNode_range,2)==4
    alpha = forceNode_range(1,4);
else
    alpha = 0;
end
if ~isempty(forceNode_range)
    cc = round(cos(alpha*pi/180)*1e6)*1e-6;
    ss = round(sin(alpha*pi/180)*1e6)*1e-6;
    shiftX = (forceNode_range(1,1)+forceNode_range(2,1))/2;
    shiftY = (forceNode_range(1,2)+forceNode_range(2,2))/2;
    shiftZ=forceNode_range(1,3);
    Lx = -(forceNode_range(1,1)-forceNode_range(2,1));
    Ly = -(forceNode_range(1,2)-forceNode_range(2,2));
    if strcmp(stShape,'circ')
        forceNode = find(round((((nodeCoordinates(:,1)-shiftX)*cc+...
            (nodeCoordinates(:,2)-shiftY)*ss).^2/(Lx/2)^2+...
            ((nodeCoordinates(:,1)-shiftX)*ss-(nodeCoordinates(:,2)-shiftY)*cc).^2/...
            (Ly/2)^2)*scale)/scale<=1&abs(nodeCoordinates(:,3)-shiftZ)<tol);
    elseif strcmp(stShape,'rect')
        forceNode = find(...
            abs(round(((nodeCoordinates(:,1)-shiftX)*cc+...
            (nodeCoordinates(:,2)-shiftY)*ss)*scale)/scale)<=Lx/2&...
            abs(round(((nodeCoordinates(:,2)-shiftY)*cc-...
            (nodeCoordinates(:,1)-shiftX)*ss)*scale)/scale)<=Ly/2&...
            abs(nodeCoordinates(:,3)-shiftZ)<tol); 
    
        if forceNode_range(1,1) == forceNode_range(2,1)&&forceNode_range(1,2)==...
                forceNode_range(2,2)
            [~,forceNode] = min(sqrt(nodeCoordinates(:,1).^2+...
                nodeCoordinates(:,2).^2+shiftZ.^2)-...
                sqrt(forceNode_range(1,1).^2+forceNode_range(1,2).^2)+shiftZ.^2);
        end
    end
else
    forceNode = [];
end
    P(forceNode+0*numberNodes_pl,1) = Pn(1);
    P(forceNode+1*numberNodes_pl,1) = Pn(2);
    P(forceNode+2*numberNodes_pl,1) = Pn(3);