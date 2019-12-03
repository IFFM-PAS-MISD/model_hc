function ownerElement = findOwnerElement(x_p,y_p,z_p,nodeCoordinates_main,elementNodes_main,...
    n_x,n_y,case_name)
% FINDOWNERELEMENT   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: [output1,output2] = findOwnerElement(input1,input2,input3) 
% 
% Inputs: 
%    xp,yp - points coordinates in uniform mesh in x,y direction, integer 
%    nodeCoordinates_sem - Description, logical, dimensions [m, n], Units: m 
%    elementNodes_sem - Spectral nodes topology, double, dimensions [m, n], Units: N
%    shape_order - element approximation order, integer (N=3,4,5,6,7,8,9)
%    % 
% Outputs: 
%    ownerElement - a vector of the numbers of the elements
%                   containing the points of the regular grid,
%                   integer, dimensions [length(xp)*length(yp),1], Units: - 
% 
% Example: 
%    [output1,output2] = findOwnerElement(input1,input2,input3) 
%    [output1,output2] = findOwnerElement(input1,input2) 
%    [output1] = findOwnerElement(input1,input2,input3) 
% 
% Other m-files required: none 
% Subfunctions: none 
% MAT-files required: none 
% See also: 
% 

% Author: Piotr Fiborek, M.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE----------------------
%%
disp('Determination of the owner element');
ownerElement = zeros(length(x_p),1);
if n_y > 1
    elementNodes = elementNodes_main(:,[1,n_x,n_x*n_y,n_x*(n_y-1)+1,1]);
    
    for ipolygon = 1:size(elementNodes_main,1)
        elementVertex = elementNodes(ipolygon,:);
        xv = nodeCoordinates_main(elementVertex,1);
        yv = nodeCoordinates_main(elementVertex,2);
        in = inpolygon(x_p,y_p,xv,yv);
        ownerElement(in) = ipolygon;
    end
elseif n_y==1
    
    for iX = 1: length(x_p)
        Limit = 100*eps(single(max(abs([x_p(iX) y_p(iX) z_p(iX)]))));
        nodeNo = find(sqrt((nodeCoordinates_main(:,1)-x_p(iX)).^2 + (nodeCoordinates_main(:,2)-y_p(iX)).^2 + ...
        (nodeCoordinates_main(:,3)-z_p(iX)).^2) < Limit,1,'first');
        if ~isempty(nodeNo)
            [ownerElement(iX),~,~] = find(nodeNo==elementNodes_main,1,'first');
        end
    end
    
    elementNodes = elementNodes_main(:,[1,n_x]);
    P1 = [nodeCoordinates_main(elementNodes(:,1),1) nodeCoordinates_main(elementNodes(:,1),2)];
    P2 = [nodeCoordinates_main(elementNodes(:,2),1) nodeCoordinates_main(elementNodes(:,2),2)];
    emptyOwner = find(ownerElement==0);
    P12 = P2 - P1;
    L12 = diag(sqrt(P12 * P12'));
    N   = bsxfun(@rdivide, P12 ,L12);
    Limit = 500 * eps(single(max(abs(cat(2, P1, P2)),[],2)));
    for iX = 1:length(emptyOwner)
        disp(case_name)
        disp('Determination of the owner element');
        disp([num2str(iX) ' from ' num2str(length(emptyOwner))])
        Q =[x_p(emptyOwner(iX)) y_p(emptyOwner(iX))];
        PQ = bsxfun(@minus, Q,P1);
        % Norm of distance vector: LPQ = N x PQ
        Dist = abs(N(:,1) .* PQ(:,2) - N(:,2) .* PQ(:,1));
        % Consider rounding errors:
         R     = (Dist < Limit);
        % Consider end points if any 4th input is used:
            % Projection of the vector from P1 to Q on the line:
            L = diag(PQ * N.');  % DOT product
            R(R==1) = (L(R==1) >= 0.0 & L(R==1) <= L12(R==1));
        if any(R)
            ownerElement(emptyOwner(iX)) = find(R,1,'first');
        end
        clc
    end
end
%---------------------- END OF CODE---------------------- 

% ================ [findOwnerElement.m] ================  
