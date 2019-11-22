function [shapeFunction_P,naturalDerivativesX_P] = ...
    shapeFunction_1D(Q_ksi,ksi_l,func_type)
n_x = length(Q_ksi);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Sxi,Dxi] = cellfun(@(x) shape1D_v2(n_x,Q_ksi,x),num2cell(ksi_l,2), 'UniformOutput',false);

Sxi = cell2mat(Sxi);
Dxi = cell2mat(Dxi);


iSparse = repmat((1:length(ksi_l))',1,n_x);
jSparse = bsxfun(@plus,repmat((1:n_x:n_x*length(ksi_l))',1,n_x), (0:n_x-1));

switch func_type
    case 's'
        disp('Shape function...')
        shapeFunction = round(Sxi*1e16)*1e-16;
        shapeFunction_P = sparse(iSparse,jSparse,shapeFunction);
        naturalDerivativesX_P = [];
    case 'd'
        disp('naturalDerivativesX...')
        shapeFunction_P = [];
        naturalDerivativesX = round(Dxi*1e16)*1e-16;
        naturalDerivativesX_P = sparse(iSparse,jSparse,naturalDerivativesX);
    otherwise
        disp('Shape function...')
        shapeFunction = round(Sxi*1e16)*1e-16;
        shapeFunction_P = sparse(iSparse,jSparse,shapeFunction);
        disp('naturalDerivativesX...')
        naturalDerivativesX = round(Dxi*1e16)*1e-16;
        naturalDerivativesX_P = sparse(iSparse,jSparse,naturalDerivativesX);
end