function [N,N_prim]=shape1D_v2(n,Q,xi)

% n - number of nodes in 1D shape function in z direction
% calculate values of the shape function at point (z) defined in local
% coordinates

if isempty(xi)
    N = zeros(numel(xi),n);
    N_prim = zeros(numel(xi),n);
else
    uz = zeros(numel(xi),n);
    uz_prim = zeros(numel(xi),n);
    uz(:,1) = 1;

    for j = 2:n
         uz(:,j) = reshape((xi.^(j-1))',[],1);
         uz_prim(:,j) = reshape(((j-1)*xi.^(j-2))',[],1);
    end;  
    N = uz*Q';
    N_prim = uz_prim*Q';
end
