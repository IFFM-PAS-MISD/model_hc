%cell_mesh
function [elementNodes,nodeCoordinates,cellsCoordinates,coreElements,cellPZT_el]=...
    cell_mesh(structure_i)
% i=1; structure_i=structure(i);
'honeycomb cell inner diagonal [m]';  D_h=structure_i.properties(end-1);
'honeycomb cell wall thickness [m]';  W_h=structure_i.properties(end);
R=(D_h+W_h/sin(60*pi/180))/2;
% element 1-12 
elementNodes=[2 8 3 1
              3 9 4 1
              4 10 5 1
              5 11 6 1
              6 12 7 1
              7 13 2 1
              13 14 8 2
              8 15 9 3
              9 16 10 4
              10 17 11 5
              11 18 12 6
              12 19 13 7];

% nodes 1
nodeCoordinates=[0 0];
% nodes 2-7
R1=R/2;
alpha=(60:60:360)*pi/180;
nC=R1.*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC];

% nodes 8-13
alpha=(90:60:390)*pi/180;
R2=R*cos(30*pi/180);
nC=R2'.*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC];

% nodes 14-19
alpha=(60:60:360)*pi/180;
nC=R.*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC];

% element 13-18 
elementNodes=[elementNodes;
              21 15 8 20
              9 15 21 22
              24 17 10 23
              11 17 24 25
              27 19 12 26
              13 19 27 28];
              
% nodes 20-22
 alpha=(60:60:180)*pi/180;         
 R2=R/2;
 nC=repmat(nodeCoordinates(15,:),size(alpha,2),1)+R2*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 
 % nodes 23-25
 alpha=(180:60:300)*pi/180;         
 R2=R/2;
 nC=repmat(nodeCoordinates(17,:),size(alpha,2),1)+R2*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 26-28
 alpha=(300:60:420)*pi/180;         
 R2=R/2;
 nC=repmat(nodeCoordinates(19,:),size(alpha,2),1)+R2*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 

% element 19-30
elementNodes=[elementNodes;
              8 14 29 20
              29 30 21 20
              21 30 31 22
              31 16 9 22
              10 16 33 23
              33 34 24 23
              24 34 35 25
              35 18 11 25
              12 18 37 26
              37 38 27 26
              27 38 39 28
              39 14 13 28];
 % nodes 29-30
 alpha=(60:60:120)*pi/180;         
 nC=repmat(nodeCoordinates(15,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 % nodes 31-32
 alpha=(120:60:180)*pi/180;         
 nC=repmat(nodeCoordinates(16,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 
 % nodes 33-34
 alpha=(180:60:240)*pi/180;         
 nC=repmat(nodeCoordinates(17,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 % nodes 35-36
 alpha=(240:60:300)*pi/180;         
 nC=repmat(nodeCoordinates(18,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 
 % nodes 37-38
 alpha=(300:60:360)*pi/180;         
 nC=repmat(nodeCoordinates(19,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 % nodes 39-40
 alpha=(360:60:420)*pi/180;         
 nC=repmat(nodeCoordinates(14,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
          
% element 31-42

elementNodes=[elementNodes;
              14 40 41 29
              41 42 30 29
              30 43 44 31
              44 32 16 31
              16 32 45 33
              45 46 34 33
              34 47 48 35
              48 36 18 35
              18 36 49 37
              49 50 38 37
              38 51 52 39
              52 40 14 39];
          
 % nodes 41-42
 alpha=(60:60:120)*pi/180;         
 nC=repmat(nodeCoordinates(29,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 % nodes 43-44
 alpha=(120:60:180)*pi/180;         
 nC=repmat(nodeCoordinates(31,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 
 % nodes 45-46
 alpha=(180:60:240)*pi/180;         
 nC=repmat(nodeCoordinates(33,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 % nodes 47-48
 alpha=(240:60:300)*pi/180;         
 nC=repmat(nodeCoordinates(35,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 
 % nodes 49-50
 alpha=(300:60:360)*pi/180;         
 nC=repmat(nodeCoordinates(37,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 % nodes 51-52
 alpha=(360:60:420)*pi/180;         
 nC=repmat(nodeCoordinates(39,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];
 nodeCoordinates=round(nodeCoordinates*1e6)*1e-6;
 cellsCoordinates=nodeCoordinates([1 29:2:39],:);
 
 coreElements=[14 8 15
               15 9 16 
               16 10 17
               17 11 18
               18 12 19
               19 13 14
               15 21 30
               17 24 34
               19 27 38];
cellPZT_el=cell(2,1);
cellPZT_el{1}=[21,25,29];
cellPZT_el{2}=[1:6,19:30];

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
% end
end