%PZT mesh
function [elementNodes,nodeCoordinates]=...
    PZT_mesh(structure_i)
% i=4; structure_i=structure(i); 

R=structure_i.geometry(1)/2;
elementNodes=[2 3 4 1
              4 5 6 1
              6 7 2 1
              8 9 3 2
              9 10 11 3
              11 12 4 3
              12 13 5 4
              13 14 15 5
              15 16 6 5
              16 17 7 6
              17 18 19 7
              19 8 2 7
              20 21 9 8
              21 22 10 9
              22 23 11 10
              23 24 12 11
              24 25 13 12
              25 26 14 13
              26 27 15 14
              27 28 16 15
              28 29 17 16
              29 30 18 17
              30 31 19 18
              31 20 8 19];
nodeCoordinates=[0 0];
alpha=(90:60:390)*pi/180;
R1=R/3;
nC=R1*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC];

alpha=(90:30:420)*pi/180;
R2=2*R/3;
nC=R2*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC];

nC=R*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC];     
nodeCoordinates=round(nodeCoordinates*1e6)*1e-6;
end
%%
% bb=[elementNodes elementNodes(:,1)];
% for i=1:size(elementNodes,1)
%     clc
%     disp(i)
%     disp(bb(i,:))
% plot(nodeCoordinates(bb(i,:),1),nodeCoordinates(bb(i,:),2),'b')
% text(nodeCoordinates(bb(i,:),1),nodeCoordinates(bb(i,:),2),num2str(bb(i,:)'))
% hold on
% axis([-2.6*R 2.6*R -2.6*R 2.6*R])
% axis equal
% pause()
%end

