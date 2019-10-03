%EssentialBC
function [prescribedDof,activeDof,GDof]= ...
    EssentialBC(structure)

typeBC=structure.BC;
nodeCoordinates=structure.nodeCoordinates;
DOF=structure.DOF(1);
xx=nodeCoordinates(:,1);
yy=nodeCoordinates(:,2);
numberNodes=size(nodeCoordinates,1);


switch typeBC
    case 'ssss'
fixedNodeU=[];
fixedNodeV=[];
fixedNodeW=find(xx==max(nodeCoordinates(:,1))| ...
    xx==min(nodeCoordinates(:,1))| ...
    yy==min(nodeCoordinates(:,2))| ...
    yy==max(nodeCoordinates(:,2)));
fixedNodeTX=find(yy==max(nodeCoordinates(:,2))| ...
    yy==min(nodeCoordinates(:,2)));
fixedNodeTY=find(xx==max(nodeCoordinates(:,1))| ...
    xx==min(nodeCoordinates(:,1)));
case 'ffff'
fixedNodeU=[];
fixedNodeV=[];
fixedNodeW=[];
fixedNodeTX=[];
fixedNodeTY=[];
fixedNodeTZ=[];
    case 'cccc'
fixedNodeU=find(xx==max(nodeCoordinates(:,1))| ...
    xx==min(nodeCoordinates(:,1))| ...
    yy==min(nodeCoordinates(:,2))| ...
    yy==max(nodeCoordinates(:,2)));
fixedNodeV=find(xx==max(nodeCoordinates(:,1))| ...
    xx==min(nodeCoordinates(:,1))| ...
    yy==min(nodeCoordinates(:,2))| ...
    yy==max(nodeCoordinates(:,2)));
fixedNodeW=find(xx==max(nodeCoordinates(:,1))| ...
    xx==min(nodeCoordinates(:,1))| ...
    yy==min(nodeCoordinates(:,2))| ...
    yy==max(nodeCoordinates(:,2)));
fixedNodeTX=fixedNodeW ;
fixedNodeTY=fixedNodeTX;
    case 'scsc'
fixedNodeU=find(xx==min(nodeCoordinates(:,1)));
fixedNodeV=find(yy==min(nodeCoordinates(:,2)));
fixedNodeW=find(xx==max(nodeCoordinates(:,1))| ...
    xx==min(nodeCoordinates(:,1))| ...
    yy==min(nodeCoordinates(:,2))| ...
    yy==max(nodeCoordinates(:,2)));
fixedNodeTX=find(yy==min(nodeCoordinates(:,1)));
fixedNodeTY=find(xx==min(nodeCoordinates(:,1)));
  case 'cccf'
        fixedNodeW=find(xx==min(nodeCoordinates(:,1))| ...
    yy==min(nodeCoordinates(:,2))| ...
    yy==max(nodeCoordinates(:,2)));
fixedNodeTX=fixedNodeW;
fixedNodeTY=fixedNodeTX;
    case 'ssff'
fixedNodeU=find(xx==0| ...
    yy==0);
fixedNodeV=find(xx==0| ...
    yy==0);
fixedNodeW=[];
fixedNodeTX=fixedNodeU;
fixedNodeTY=fixedNodeV;
    case 'Qffff'
fixedNodeU=find(xx==0);
fixedNodeV=find(yy==0);
fixedNodeW=[];
fixedNodeTX=fixedNodeV;
fixedNodeTY=fixedNodeU;
end
GDof=DOF*numberNodes;
switch  DOF
    case 3
    prescribedDof=[fixedNodeU;fixedNodeV+numberNodes;fixedNodeW+2*numberNodes];
    case 5
    prescribedDof=[fixedNodeU;fixedNodeV+numberNodes;fixedNodeW+2*numberNodes; ...
    fixedNodeTX+3*numberNodes;fixedNodeTY+4*numberNodes];
    case 6
    prescribedDof=[fixedNodeU;fixedNodeV+numberNodes;fixedNodeW+2*numberNodes; ...
    fixedNodeTX+3*numberNodes;fixedNodeTY+4*numberNodes;fixedNodeTZ+5*numberNodes];
end

activeDof=setdiff((1:GDof)',prescribedDof);