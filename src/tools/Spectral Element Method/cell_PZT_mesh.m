%cell_PZT mesh
function [elementNodes,nodeCoordinates,cellsCoordinates,cellPZT_el]=...
    cell_PZT_mesh(structure_i,structure_att)
% i=3; structure_i=structure(i); ii=4; structure_att=structure(ii);


'honeycomb cell inner diagonal [m]';  D_h=structure_i.properties(end-1);
'honeycomb cell wall thickness [m]';  W_h=structure_i.properties(end);
R_PZT=structure_att.geometry(1)/2;
R=(D_h+W_h/sin(60*pi/180))/2;


% element 1-24 
% nodes 1-31
[elementNodes,nodeCoordinates]=PZT_mesh(structure_att);

%%
 % element 25-48  
elementNodes=[elementNodes;
              [(32:55)', [33:43, 32, 45:55, 44]', [21:31, 20, 33:43, 32]', (20:43)']];

% nodes 32-43          
alpha=(90:30:420)*pi/180;
beta=repmat([30;0],6,1)*pi/180;
R1=0.5*(R*cos(beta(1))+R_PZT);
nC=R1.*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC];
% nodes 44-55
beta=repmat([30;0],6,1)*pi/180;
nC=repmat(R.*cos(beta),1,2).*[cos(alpha') sin(alpha')];
nodeCoordinates=[nodeCoordinates;nC]; 
% element 49-54  
elementNodes=[elementNodes;
              57 45 44 56
              46 45 57 58
              60 49 48 59
              50 49 60 61
              63 53 52 62
              54 53 63 64];
 % nodes 56-58
 alpha=(60:60:180)*pi/180;         
 R2=R/2;
 nC=repmat(nodeCoordinates(45,:),size(alpha,2),1)+R2*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 % nodes 59-61
 alpha=(180:60:300)*pi/180;         
 nC=repmat(nodeCoordinates(49,:),size(alpha,2),1)+R2*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 % nodes 62-64
 alpha=(300:60:420)*pi/180;         
 nC=repmat(nodeCoordinates(53,:),size(alpha,2),1)+R2*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 % element 55-66             
elementNodes=[elementNodes;
              44 55 65 56
              66 57 56 65
              57 66 67 58
              47 46 58 67
              48 47 69 59
              70 60 59 69
              60 70 71 61
              51 50 61 71
              52 51 73 62
              74 63 62 73
              63 74 75 64
              55 54 64 75];
 % nodes 65-66
 alpha=([60 120])*pi/180;         
 nC=repmat(nodeCoordinates(45,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];        
 
 % nodes 67-68
 alpha=([120 180])*pi/180;       
 nC=repmat(nodeCoordinates(47,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 69-70
alpha=([180 240])*pi/180;
nC=repmat(nodeCoordinates(49,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 71-72
alpha=([240 300])*pi/180;
nC=repmat(nodeCoordinates(51,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 73-74
alpha=([300 360])*pi/180;
nC=repmat(nodeCoordinates(53,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 75-76
alpha=([360 420])*pi/180;
nC=repmat(nodeCoordinates(55,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 % element 67-78  
 elementNodes=[elementNodes;
                55 76 77 65
                77 78 66 65
                66 79 80 67
                80 68 47 67
                47 68 81 69
                81 82 70 69
                70 83 84 71
                84 72 51 71
                51 72 85 73
                85 86 74 73
                74 87 88 75
                88 76 55 75];
              
% nodes 77-78
 alpha=([60 120])*pi/180;         
 nC=repmat(nodeCoordinates(65,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC];        
 
 % nodes 79-80
 alpha=([120 180])*pi/180;       
 nC=repmat(nodeCoordinates(67,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 81-82
alpha=([180 240])*pi/180;
nC=repmat(nodeCoordinates(69,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 83-84
alpha=([240 300])*pi/180;
nC=repmat(nodeCoordinates(71,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 85-86
alpha=([300 360])*pi/180;
nC=repmat(nodeCoordinates(73,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
 
 % nodes 87-88
alpha=([360 420])*pi/180;
nC=repmat(nodeCoordinates(75,:),size(alpha,2),1)+R*[cos(alpha') sin(alpha')];
 nodeCoordinates=[nodeCoordinates;nC]; 
nodeCoordinates=round(nodeCoordinates*1e6)*1e-6;
cellsCoordinates=nodeCoordinates([1 65:2:75],:);

cellPZT_el=cell(2,1);
cellPZT_el{1}=[55 56 58 59 60 62 63 64 66];
cellPZT_el{2}=setdiff(1:66,49:54);
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