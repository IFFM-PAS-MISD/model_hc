%force
function [B]=BBMindlin(structure_i,ii)
%structure_i=structure(i);
GDof = structure_i.GDof;
DOF = structure_i.DOF(1);
Lz = structure_i.geometry(3);
I = find(structure_i.stAttach(1,:)==structure_i.stAttach(1,ii),1);
prescint = structure_i.prescint(structure_i.prescint(:,I)~=0,I);
structure_i.stAttach(2,ii);
if DOF == 3 || strcmp(structure_i.mesh_type,'honeycomb_core')
    prescint_XYZ = reshape(prescint,[],3);
    prescintCoord = structure_i.nodeCoordinates(prescint_XYZ(:,1),:);
    [~,IX] = sort(prescintCoord(:,2));
    prescintCoord_sortY = prescintCoord(IX,:);
    unqY = unique(prescintCoord_sortY(:,2));
    for i = 1:length(unqY)
        [~,IIX] = sort(prescintCoord_sortY(prescintCoord_sortY(:,2) == unqY(i),1));
        unqYNodes = IX(prescintCoord_sortY(:,2) == unqY(i));
        IX(prescintCoord_sortY(:,2) == unqY(i)) = unqYNodes(IIX);
    end
    prescint_XYZ = prescint_XYZ(IX,:);
    prescint = reshape(prescint_XYZ,[],1);
    C_B = [(1:size(prescint,1))',prescint,ones(size(prescint,1),1)];
    B = sparse(C_B(:,1),C_B(:,2),C_B(:,3),size(prescint,1),GDof);
elseif DOF == 5 && ~strcmp(structure_i.mesh_type,'honeycomb_core')
    prescint_XYZTT = reshape(prescint,[],5);
    prescintCoord = structure_i.nodeCoordinates(prescint_XYZTT(:,1),:);
    [~,IX] = sort(prescintCoord(:,2));
    prescintCoord_sortY = prescintCoord(IX,:);
    unqY = unique(prescintCoord_sortY(:,2));
    for i = 1:length(unqY)
        [~,IIX] = sort(prescintCoord_sortY(prescintCoord_sortY(:,2) == unqY(i),1));
        unqYNodes = IX(prescintCoord_sortY(:,2) == unqY(i));
        IX(prescintCoord_sortY(:,2) == unqY(i)) = unqYNodes(IIX);
    end
    prescint_XYZTT = prescint_XYZTT(IX,:);
    prescint_XYZ = reshape(prescint_XYZTT(:,1:3),[],1);
    prescint_TT = reshape(prescint_XYZTT(:,4:5),[],1);
    C_B = [(1:size(prescint_XYZ,1))',prescint_XYZ(1:size(prescint_XYZ,1)),...
            ones(size(prescint_XYZ,1),1);
        (1:size(prescint_TT,1))',prescint_TT(1:size(prescint_TT,1)),...
            ones(size(prescint_TT,1),1)*structure_i.stAttach(2,ii)*Lz/2];
    B = sparse(C_B(:,1),C_B(:,2),C_B(:,3),size(prescint_XYZ,1),GDof);
end





