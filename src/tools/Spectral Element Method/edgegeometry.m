function [edgemidpoint, edgelength] = edgegeometry(nodeCoordinates,elementNodes,dim)
        
        nC = reshape(nodeCoordinates(elementNodes(:,[1,2,3 4 1]),dim),[],5);
        % midpoint of 4 edges for all elements
        edgemidpoint = (nC(:,2:5)+nC(:,1:4))/2;
        edgemidpoint = round(reshape(edgemidpoint',[],1)*1e6)*1e-6;
        
        % length of 4 edges for all elements
        edgelength = (nC(:,2:5)-nC(:,1:4))/2;
        edgelength = reshape(edgelength',[],1);