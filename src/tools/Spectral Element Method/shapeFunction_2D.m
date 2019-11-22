function [shapeFunction_P,naturalDerivativesX_P,naturalDerivativesY_P] = ...
    shapeFunction_2D(Q_ksi,Q_eta,ksi_p,eta_p,func_type)
n_x = length(Q_ksi);
n_y = length(Q_eta);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[Sxi,Dxi] = cellfun(@(x) shape1D_v2(n_x,Q_ksi,x),num2cell(ksi_p,2), 'uni',0);
[Seta,Deta] = cellfun(@(x) shape1D_v2(n_y,Q_eta,x),num2cell(eta_p,2), 'uni',0);

Sxi = cell2mat(Sxi);
Seta = cell2mat(Seta);

Dxi = cell2mat(Dxi);
Deta = cell2mat(Deta);

iSparse = repmat((1:length(ksi_p))',1,n_x*n_y);
jSparse = bsxfun(@plus,repmat((1:n_x*n_y:n_x*n_y*length(ksi_p))',1,n_x*n_y), (0:n_x*n_y-1));

switch func_type
    case 's'
        disp('Shape function...')
        shapeFunction = rowWiseKron(Seta,Sxi);
        shapeFunction_P = sparse(iSparse,jSparse,shapeFunction);
        naturalDerivativesX_P = [];
        naturalDerivativesY_P = [];
    case 'd'
        disp('naturalDerivativesX...')
        shapeFunction_P = [];
        naturalDerivativesX = rowWiseKron(Seta,Dxi);
        naturalDerivativesX_P = sparse(iSparse,jSparse,naturalDerivativesX);
        disp('naturalDerivativesY...')
        naturalDerivativesY = rowWiseKron(Deta,Sxi); 
        naturalDerivativesY_P = sparse(iSparse,jSparse,naturalDerivativesY);
    otherwise
        disp('Shape function...')
        shapeFunction = rowWiseKron(Seta,Sxi);
        shapeFunction_P = sparse(iSparse,jSparse,shapeFunction);
        disp('naturalDerivativesX...')
        naturalDerivativesX = rowWiseKron(Seta,Dxi);
        naturalDerivativesX_P = sparse(iSparse,jSparse,naturalDerivativesX);
        disp('naturalDerivativesY...')
        naturalDerivativesY = rowWiseKron(Deta,Sxi); 
        naturalDerivativesY_P = sparse(iSparse,jSparse,naturalDerivativesY);
end
function z = rowWiseKron(x,y)
        
        z = zeros(size(x,1),size(x,2)*size(y,2));
        for ii = 1 : size(x,1)
            z(ii,:) = kron(x(ii,:),y(ii,:));
        end
        z = round(z*1e8)*1e-8;