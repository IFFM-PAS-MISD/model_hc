function [spec_element_nodes,spec_coords,boundary_nodes] = ...
    quad2spectral(elementNodes_fem,nodeCoordinates_fem,N_x,N_y)
% convert quad nodes mesh into spectral element mesh 
%    only for linear quad elements 
% 
% Syntax: [spec_element_nodes,spec_coords] = ...
%                                   quad2spec(elementNodes_fem,quad_coords,N) 
% 
% Inputs: 
%    elementNodes_fem - Quad nodes topology (element nodes), integer, dimensions [nQuadElements, 4]
%    nodeCoordinates_fem - coordinates of quad element nodes, double, dimensions [nQuadNodes, 3], Units: m 
%    N - element approximation order, integer (N=3,4,5,6,7,8,9)
% 
% Outputs: 
%    spec_element_nodes - spectral elements topology (element nodes), integer, dimensions [nQuadElements,(N+1)^2]
%    spec_coords - coordinates of spectral element nodes, integer, dimensions [nSpecNodes, 3], Units: m 
%    boundary_nodes - all nodes lying on the boundary of the structure
%  13    14   15   16
%   O----O----O----O   
%   |    |    |    |
%  9O--10O----O11--O12
%   |    |    |    | 
%  5O---6O----O7---O8
%   |    |    |    |
%   O----O----O----O
%   1    2    3    4
%
% Example: 
%    [spec_element_nodes,spec_coords] = quad2spec(q,quad_coords,N)
% 
% Other m-files required: gll.m 
% Subfunctions: edgegeometry 
% MAT-files required: none 
% See also:
% 

% Author: Piotr Fiborek, M.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 
n_x = N_x+1;
n_y = N_y+1;

 if n_x<3 || n_y<3
     spec_element_nodes = elementNodes_fem(:, [1 2 4 3]);
     spec_coords = nodeCoordinates_fem;
     boundary_nodes = [];
     return
 elseif n_x>10 || n_y>10
     msgbox('Maximum no of nodes on the edge of element is 10', 'Error','error');
     return
 end
numberElements = size(elementNodes_fem,1);
format long
nInt_x = n_x-2;
nInt_y = n_y-2;

ksi = gll(n_x);
eta = gll(n_y);


ksi_int = ksi(2:n_x-1);
eta_int = eta(2:n_y-1);

% find mid point and length of every edge
[edgemidpointX edgelengthX] = edgegeometry(nodeCoordinates_fem,elementNodes_fem,1);
[edgemidpointY edgelengthY] = edgegeometry(nodeCoordinates_fem,elementNodes_fem,2);
[edgemidpointZ edgelengthZ] = edgegeometry(nodeCoordinates_fem,elementNodes_fem,3);

% the edge nodes coordinates

nodeCoordinates_int_edge = cell(length(edgemidpointX),3);


nodeCoordinatesX_temp = num2cell(bsxfun(@plus,edgemidpointX(1:2:end-1),...
    bsxfun(@times, edgelengthX(1:2:end-1),ksi_int)),2);
nodeCoordinatesY_temp = num2cell(bsxfun(@plus,edgemidpointY(1:2:end-1),...
    bsxfun(@times, edgelengthY(1:2:end-1),ksi_int)),2);
nodeCoordinatesZ_temp = num2cell(bsxfun(@plus,edgemidpointZ(1:2:end-1),...
    bsxfun(@times, edgelengthZ(1:2:end-1),ksi_int)),2);

[nodeCoordinates_int_edge{1:2:end-1,1}] = deal(nodeCoordinatesX_temp{:});
[nodeCoordinates_int_edge{1:2:end-1,2}] = deal(nodeCoordinatesY_temp{:});
[nodeCoordinates_int_edge{1:2:end-1,3}] = deal(nodeCoordinatesZ_temp{:});

nodeCoordinatesX_temp = num2cell(bsxfun(@plus,edgemidpointX(2:2:end),...
    bsxfun(@times, edgelengthX(2:2:end),eta_int)),2);
nodeCoordinatesY_temp = num2cell(bsxfun(@plus,edgemidpointY(2:2:end),...
    bsxfun(@times, edgelengthY(2:2:end),eta_int)),2);
nodeCoordinatesZ_temp = num2cell(bsxfun(@plus,edgemidpointZ(2:2:end),...
    bsxfun(@times, edgelengthZ(2:2:end),eta_int)),2);

[nodeCoordinates_int_edge{2:2:end,1}] = deal(nodeCoordinatesX_temp{:});
[nodeCoordinates_int_edge{2:2:end,2}] = deal(nodeCoordinatesY_temp{:});
[nodeCoordinates_int_edge{2:2:end,3}] = deal(nodeCoordinatesZ_temp{:});

nodeCoordinates_int_edge = cellfun(@(x) x',nodeCoordinates_int_edge,'uni',0);
nodeCoordinates_int_edge = cell2mat(nodeCoordinates_int_edge);


[nodeCoordinates_int_edge,~,n1] = unique(nodeCoordinates_int_edge,'first','rows');

elementNodes_int_edge = reshape(n1,2*nInt_x+2*nInt_y,[])';


% coordinates of the nodes inside the element
elementNodes_int_int = (1:(numberElements*nInt_x*nInt_y))+...
    max(max(elementNodes_int_edge));
elementNodes_int_int = reshape(elementNodes_int_int,nInt_x*nInt_y,...
     numberElements)';
n_el1 = elementNodes_int_edge(:,1 + 0*nInt_x : 1*nInt_x);
n_el2 = elementNodes_int_edge(:,1 + 1*nInt_x : nInt_x + nInt_y);
n_el3 = elementNodes_int_edge(:,nInt_y+2*nInt_x : -1 : 1 + nInt_x + nInt_y);
n_el4 = elementNodes_int_edge(:,2*nInt_y+2*nInt_x : -1 : 1 + nInt_y + 2*nInt_x);
    
iSparse = repmat(1:numberElements,nInt_x,1);
jSparse = bsxfun(@plus,1:nInt_x:nInt_x*numberElements, (0:nInt_x-1)');
       
A13 = reshape(nodeCoordinates_int_edge(n_el3,2)-nodeCoordinates_int_edge(n_el1,2),[],nInt_x);
A13 = sparse(iSparse,jSparse,A13');
B13 = reshape(nodeCoordinates_int_edge(n_el1,1)-nodeCoordinates_int_edge(n_el3,1),[],nInt_x);
B13 = sparse(iSparse,jSparse,B13');
C13 = reshape((nodeCoordinates_int_edge(n_el1,2)-nodeCoordinates_int_edge(n_el3,2)).*...
        nodeCoordinates_int_edge(n_el1,1)+...
        (nodeCoordinates_int_edge(n_el3,1)-nodeCoordinates_int_edge(n_el1,1)).*...
        nodeCoordinates_int_edge(n_el1,2),[],nInt_x);
C13 = sparse(iSparse,jSparse,C13');

iSparse = repmat(1:numberElements,nInt_y,1);
jSparse = bsxfun(@plus,1:nInt_x:nInt_x*numberElements, (0:nInt_y-1)');

A42 = reshape(nodeCoordinates_int_edge(n_el2,2)-nodeCoordinates_int_edge(n_el4,2),[],nInt_y);
A42 = sparse(iSparse,jSparse,A42');
B42 = reshape(nodeCoordinates_int_edge(n_el4,1)-nodeCoordinates_int_edge(n_el2,1),[],nInt_y);
B42 = sparse(iSparse,jSparse,B42');
C42 = reshape((nodeCoordinates_int_edge(n_el4,2)-nodeCoordinates_int_edge(n_el2,2)).*...
        nodeCoordinates_int_edge(n_el4,1)+...
        (nodeCoordinates_int_edge(n_el2,1)-nodeCoordinates_int_edge(n_el4,1)).*...
        nodeCoordinates_int_edge(n_el4,2),[],nInt_y);
C42 = sparse(iSparse,jSparse,C42');

iSparse = repmat(1:nInt_x*numberElements,nInt_y,1);
jSparse = bsxfun(@plus,reshape(repmat(1:nInt_x:nInt_x*numberElements,nInt_x ,1),1,[]),...
    (0:nInt_y-1)');
AA = sparse(iSparse,jSparse,true);
W = (A13'*B42-B13'*A42);
W = W(AA);
Wx = (B13'*C42-C13'*B42);
Wx = Wx(AA);
Wy = (C13'*A42-A13'*C42);
Wy = Wy(AA);
X_int = Wx./W;
Y_int = Wy./W;
Z_int = ones(length(X_int),1).*unique(nodeCoordinates_int_edge(:,3));
nodeCoordinates_int_int = full([X_int,Y_int,Z_int]);

% regular spectral nodes topology
elementNodes_int = [elementNodes_int_edge,elementNodes_int_int] + ...
    double(max(max(elementNodes_fem)));
nodeCoordinates_int = [nodeCoordinates_int_edge;nodeCoordinates_int_int];
elementNodes_sem = [elementNodes_fem,elementNodes_int];
spec_coords = round([nodeCoordinates_fem;nodeCoordinates_int]*1e8)*1e-8;


e1 = 4+(1:nInt_x);
e2 = [2 4+nInt_x+(1:nInt_y) 3]';
e3 = fliplr(4+nInt_x+nInt_y+(1:nInt_x));
e4 = fliplr([4 4+2*nInt_x+nInt_y+(1:nInt_y) 1])';
e5 = reshape(4+2*nInt_x+2*nInt_y+(1:nInt_x*nInt_y),nInt_x,[])';
ee = reshape([e4 [e1; e5; e3] e2]',1,[]);

spec_element_nodes = elementNodes_sem(:,ee);


[~,~,n0] = unique([edgemidpointX,edgemidpointY,edgemidpointZ],'first','rows');
U = unique(n0);
U_vrt = U(1==histc(n0,U));
edge_1 = 1:n_x;
edge_2 = n_x:n_x:n_x*n_y;
edge_3 = 1+n_x*(n_y-1):n_x*n_y;
edge_4 = 1:n_x:1+n_x*(n_y-1);
elementNodes_edge = spec_element_nodes(:,[edge_1 edge_2 edge_3 edge_4]);
bndEdge = num2cell(ismember(n0,U_vrt),2);
bndEdge_X = cell(length(bndEdge)/2,1);
[bndEdge_X{:}] = deal(bndEdge{1:2:end-1});
bndEdge_X = cellfun(@(x) repmat(x,1,n_x),bndEdge_X,'uni',0);
bndEdge_Y = cell(length(bndEdge)/2,1);
[bndEdge_Y{:}] = deal(bndEdge{2:2:end});
bndEdge_Y = cellfun(@(y) repmat(y,1,n_y),bndEdge_Y,'uni',0);

[bndEdge{1:2:end-1}] = deal(bndEdge_X{:});
[bndEdge{2:2:end}] = deal(bndEdge_Y{:});
bndEdge = logical(cell2mat(reshape(bndEdge,4,[])'));
boundary_nodes = unique(elementNodes_edge(bndEdge));

function [edgemidpoint, edgelength] = edgegeometry(nodeCoordinates,elementNodes,dim)
        
        nC = reshape(nodeCoordinates(elementNodes(:,[1,2,3 4 1]),dim),[],5);
        % midpoint of 4 edges for all elements
        edgemidpoint = (nC(:,2:5)+nC(:,1:4))/2;
        edgemidpoint = round(reshape(edgemidpoint',[],1)*1e6)*1e-6;
        
        % length of 4 edges for all elements
        edgelength = (nC(:,2:5)-nC(:,1:4))/2;
        edgelength = reshape(edgelength',[],1);

%---------------------- END OF CODE---------------------- 

% ================ [quad2spectral_Fiborek.m] ================  
