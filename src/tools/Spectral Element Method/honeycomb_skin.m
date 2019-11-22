function [nodeCoordinates,elementNodes] = honeycomb_skin(structure,actSt)
% structure_i.DOF = [5,6,1,6]; Lx = 500e-3; Ly = 314e-3; Lz = 1e-3; shiftY = 0e-3;shiftX = 0e-3;shiftZ = 0e-3;
% D_h = 19.0e-3; W_h =  70.0e-6; n = structure_i.DOF(2);
structure_i = structure(actSt);
format long

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'skin length [m]';                    Lx = structure_i.geometry(1);
'skin width [m]';                     Ly = structure_i.geometry(2);
'shift in z direction - total thickness [m]';shiftZ = structure_i.geometry(6);
'honeycomb cell inner diagonal [m]';  D_h = structure_i.properties(end-1);
'honeycomb cell wall thickness [m]';  W_h = structure_i.properties(end);
n = structure_i.DOF(2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


numCells_x = floor((Lx-2*(D_h/2+W_h/2/sin(60*pi/180)))/...
    (5*(D_h/2+W_h/2/sin(60*pi/180))));
numCells_y = floor((Ly)/(D_h*sin(60*pi/180)+W_h));

xx1 = -numCells_x/2*(2*(D_h+2*W_h/2/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))+...
    (D_h+W_h/sin(60*pi/180))/2 : 3*(D_h+W_h/sin(60*pi/180))/2:...
    numCells_x/2*(2*(D_h+2*W_h/2/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))-...
    (D_h+W_h/sin(60*pi/180))/2;
yy1 = -numCells_y/2*(D_h*sin(60*pi/180)+W_h)+(D_h*sin(60*pi/180)+W_h)/2:...
    (D_h*sin(60*pi/180)+W_h):...
    numCells_y/2*(D_h*sin(60*pi/180)+W_h)-(D_h*sin(60*pi/180)+W_h)/2;
xx2 = -numCells_x/2*(2*(D_h+2*W_h/2/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))+...
   5/2*(D_h+W_h/sin(60*pi/180))/2:...
   3*(D_h+W_h/sin(60*pi/180))/2:...
   numCells_x/2*(2*(D_h+W_h/sin(60*pi/180))+(D_h/2+W_h/2/sin(60*pi/180)))-...
   5/2*(D_h+W_h/sin(60*pi/180))/2;
yy2 = -(numCells_y-1)/2*(D_h*sin(60*pi/180)+W_h)+(D_h*sin(60*pi/180)+W_h)/2:...
    (D_h*sin(60*pi/180)+W_h):...
    (numCells_y-1)/2*(D_h*sin(60*pi/180)+W_h)-(D_h*sin(60*pi/180)+W_h)/2;

p_0 = zeros(7,2);
point_c = [0,0];
R = (D_h+W_h/sin(60*pi/180))/2;
for k = 1:6
    p_0(k+1,:) = [R*cos(60*(k-1)*pi/180)-point_c(1,1),R*sin(60*(k-1)*pi/180)-point_c(1,2)];
end
p_0(:,3) = round(shiftZ*1e6)*1e-6;
number_X1 = size(xx1,2);
number_X2 = size(xx2,2);
number_Y1 = size(yy1,2);
number_Y2 = size(yy2,2);

elementNodes0 = [7 2 3 1
               3 4 5 1
               5 6 7 1];
nodeCoordinates = cell(number_X1*number_Y1+number_X2*number_Y2,1);
elementNodes = cell(number_X1*number_Y1+number_X2*number_Y2,1);
C1 = 0;
for i = 1:number_X1
    for j = 1:number_Y1
        C1 = C1+1;    
        trans = [xx1(i) yy1(j) 0];
        if j==1&&i==1
            nodeCoordinates{C1} = p_0+repmat(trans,size(p_0,1),1);    
            elementNodes{C1} = elementNodes0;
        elseif j==1&&i~=1
            nodeCoordinates{C1} = p_0+repmat(trans,size(p_0,1),1);
            nodeCoordinates{C1} = round(nodeCoordinates{C1}*1e6)*1e-6;
                elementNodes{C1} = elementNodes0+max(max(elementNodes{C1-1}));
        else
            nC = p_0+repmat(trans,size(p_0,1),1);
            nC(6:7,:) = [];
            nodeCoordinates{C1} = nC;
            nodeCoordinates{C1} = round(nodeCoordinates{C1}*1e6)*1e-6;
            EN = zeros(size(elementNodes0));
            EN(1,1) = elementNodes{C1-1}(1,3);
            EN(3,2:3) = elementNodes{C1-1}(2,2:-1:1);
            EN(EN==0) = elementNodes0(EN==0)+max(max(elementNodes{C1-1}));
            elementNodes{C1} = EN;   
       end
     end
 end
 for i = 1:number_X2
     for j = 1:number_Y2
         C1 = C1+1;
         trans = [xx2(i) yy2(j) shiftZ];
         nodeCoordinates{C1} = trans;
         nodeCoordinates{C1} = round(nodeCoordinates{C1}*1e6)*1e-6;
         EN = zeros(size(elementNodes0));
         EN(:,4) = max(max(elementNodes{C1-1}))+1;
         EN(1,1:2) = elementNodes{i-1+number_Y1+C1-number_X1*number_Y1}(2,3:-1:2);
         EN(1,3) = elementNodes{i+number_Y1+C1-number_X1*number_Y1}(2,3);
         EN(2,2:3) = elementNodes{i+C1-number_X1*number_Y1}(1,2:-1:1);
         EN(2,1) = elementNodes{i+number_Y1+C1-number_X1*number_Y1}(2,3);
         EN(3,1:2) = elementNodes{i-1+C1-number_X1*number_Y1}(1,3:-1:2);
         EN(3,3) = elementNodes{i-1+number_Y1+C1-number_X1*number_Y1}(3,1);
         elementNodes{C1} = EN;
      end
 end
%%
 pureNC = cell2mat(nodeCoordinates);
 C3 = 0;
 C4 = 0;
 C1_kk = cell(1,1);
 cellPZT = cell(2,1);
 
 for k = setdiff(1:size(structure,2),actSt)
     
     if ~isempty(structure(k).piezo_type)
         C4 = C4+1;
         [elementNodes_str,nodeCoordinates_str,cellsCoordinates,cellPZT_el] = ...
            cell_PZT_mesh(structure(actSt),structure(k));
        
        cPZT = repmat([structure(k).geometry(4) structure(k).geometry(5)],7,1)+...
             cellsCoordinates;
        C1_kk{C4,1} = zeros(length(cellsCoordinates),2);
       
        for kk7 = 1:length(cellsCoordinates) 
             d1 = inf;
            for kk = 1:C1+C3
                if min(sqrt((nodeCoordinates{kk}(:,1)-cPZT(kk7,1)).^2+...
                     (nodeCoordinates{kk}(:,2)-cPZT(kk7,2)).^2))<d1
                   [d1 d] = min(sqrt((nodeCoordinates{kk}(:,1)-cPZT(kk7,1)).^2+...
                     (nodeCoordinates{kk}(:,2)-cPZT(kk7,2)).^2));
                    C1_kk{C4}(kk7,:) = [kk d];  
                end
            end
        end
        nodeCoordinates_str(:,1) = nodeCoordinates_str(:,1)+nodeCoordinates{C1_kk{C4}(1,1)}(C1_kk{C4}(1,2),1);
        nodeCoordinates_str(:,2) = nodeCoordinates_str(:,2)+nodeCoordinates{C1_kk{C4}(1,1)}(C1_kk{C4}(1,2),2);
        eN_kk = cell2mat(elementNodes(C1_kk{C4}(:,1)));
        C2 = 0;cmnNodes = []; unqEN = unique(eN_kk);
        for i = 1:size(nodeCoordinates_str,1)
            if ~isempty(find(abs(pureNC(unqEN,1)-nodeCoordinates_str(i,1))<1e-5&...
                   abs(pureNC(unqEN,2)-nodeCoordinates_str(i,2))<1e-5, 1))
               C2 = C2+1;
               cmnNodes(C2,:) = [i unqEN(find(abs(pureNC(unqEN,1)-...
                  nodeCoordinates_str(i,1))<1e-5&...
                  abs(pureNC(unqEN,2)-nodeCoordinates_str(i,2))<1e-5, 1))];
            end
        end
        nN = (1:max(max(elementNodes_str)))';
        nN = (setdiff(nN,cmnNodes(:,1)));
        for i = 1:size(cmnNodes,1)
            elementNodes_str(elementNodes_str==cmnNodes(i,1)) = cmnNodes(i,2);
        end
        for i = 1:size(nN,1)
            elementNodes_str(elementNodes_str==nN(i)) = max(max(elementNodes{C1+C3}))+i;
        end
        nodeCoordinates_str(cmnNodes(:,1),:) = [];
        nodeCoordinates_strZ=zeros(size(nodeCoordinates_str,1),1)+unique(pureNC(:,3));
        C3 = C3+1;
        elementNodes{C1+C3} = elementNodes_str;
        nodeCoordinates{C1+C3} = [nodeCoordinates_str nodeCoordinates_strZ];
        cellPZT{1} = [cellPZT{1} 
                    (size(cell2mat(elementNodes),1)-size(elementNodes{end},1)+cellPZT_el{1})'];
        cellPZT{2} = [cellPZT{2} 
                    (size(cell2mat(elementNodes),1)-size(elementNodes{end},1)+cellPZT_el{2})'];
     end
 
 end
 C1_kk = cell2mat(C1_kk);
 cellPZT{1} = cellPZT{1}-size(cell2mat(elementNodes(C1_kk(:,1))),1);
 cellPZT{2} = cellPZT{2}-size(cell2mat(elementNodes(C1_kk(:,1))),1);
 elementNodes(C1_kk(:,1)) = [];

nodeCoordinates = cell2mat(nodeCoordinates);
elementNodes = cell2mat(elementNodes);
nodeCoordinates = round(nodeCoordinates*1e6)*1e-6;