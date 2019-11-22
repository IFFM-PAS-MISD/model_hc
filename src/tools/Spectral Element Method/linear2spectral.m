function [spec_element_nodes,spec_coords] = ...
    linear2spectral(elementNodes_fem,nodeCoordinates_fem,N_x)
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

format long
if n_x >=3
    nInt_x = n_x-2;
    ksi = gll(n_x);
    ksi_int = ksi(2:n_x-1);


    % find mid point and length of every edge
    [edgemidpointX edgelengthX] = edgegeometry(nodeCoordinates_fem,elementNodes_fem,1);
    [edgemidpointY edgelengthY] = edgegeometry(nodeCoordinates_fem,elementNodes_fem,2);
    [edgemidpointZ edgelengthZ] = edgegeometry(nodeCoordinates_fem,elementNodes_fem,3);

    % the edge nodes coordinates

    nodeCoordinates_int_edge = cell(length(edgemidpointX),3);


    nodeCoordinatesX_temp = num2cell(bsxfun(@plus,edgemidpointX,...
        bsxfun(@times, edgelengthX,ksi_int)),2);
    nodeCoordinatesY_temp = num2cell(bsxfun(@plus,edgemidpointY,...
        bsxfun(@times, edgelengthY,ksi_int)),2);
    nodeCoordinatesZ_temp = num2cell(bsxfun(@plus,edgemidpointZ,...
        bsxfun(@times, edgelengthZ,ksi_int)),2);

    [nodeCoordinates_int_edge{:,1}] = deal(nodeCoordinatesX_temp{:});
    [nodeCoordinates_int_edge{:,2}] = deal(nodeCoordinatesY_temp{:});
    [nodeCoordinates_int_edge{:,3}] = deal(nodeCoordinatesZ_temp{:});


    nodeCoordinates_int_edge = cellfun(@(x) x',nodeCoordinates_int_edge,'uni',0);
    nodeCoordinates_int_edge = cell2mat(nodeCoordinates_int_edge);


    [nodeCoordinates_int_edge,~,n1] = unique(nodeCoordinates_int_edge,'first','rows');

    elementNodes_int_edge = reshape(n1,nInt_x,[])';
    % regular spectral nodes topology
    elementNodes_int = elementNodes_int_edge + ...
        double(max(max(elementNodes_fem)));
    elementNodes_sem = [elementNodes_fem,elementNodes_int];
    spec_coords = round([nodeCoordinates_fem;nodeCoordinates_int_edge]*1e8)*1e-8;
    
    spec_element_nodes = elementNodes_sem(:,[1 3:2+nInt_x 2]);
else
    spec_coords = nodeCoordinates_fem;
    spec_element_nodes = elementNodes_fem;
end
    


function [edgemidpoint, edgelength] = edgegeometry(nodeCoordinates,elementNodes,dim)
        
        nC = reshape(nodeCoordinates(elementNodes(:,[1,2]),dim),[],2);
        % midpoint of the edge for all elements
        edgemidpoint = round((nC(:,2)+nC(:,1))/2*1e6)*1e-6;
        
        % length of 4 edges for all elements
        edgelength = (nC(:,2)-nC(:,1))/2;
        

%---------------------- END OF CODE---------------------- 

% ================ [quad2spectral_Fiborek.m] ================  
