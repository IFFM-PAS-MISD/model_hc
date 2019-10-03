function [w_P,Jacob_P11inv,Jacob_P12inv,Jacob_P21inv,Jacob_P22inv,Jacob_P13inv,...
    Jacob_P23inv,Jacob_P31inv,Jacob_P32inv,Jacob_P33inv,shapeFunction_P,...
    naturalDerivativesX_P,naturalDerivativesY_P,naturalDerivativesZ_P,XYZ_P] = ...
    Jacob_NbN(DOF,n_x,n_y,n_z,elementNodes,nodeCoordinates,alpha_rot)

nElements = size(elementNodes,1);
[ksi_i,wi_x] = gll(n_x);
[eta_i,wi_y] = gll(n_y);
ksi_l = repmat(ksi_i,nElements,1);
eta_l = repmat(eta_i,nElements,1);
wi_x = repmat(wi_x,nElements,1);
[Q_ksi] = Vandermonde_v2(ksi_i,n_x);
wi_y = repmat(wi_y,nElements,1);
[Q_eta] = Vandermonde_v2(eta_i,n_y);
%%
[zeta_i,wi_z] = gll(n_z);
zeta_l = repmat(zeta_i,nElements,1);
wi_z = repmat(wi_z,nElements,1);
[Q_zeta] = Vandermonde_v2(zeta_i,n_z);
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch DOF
    case {2,5,6}

        [Sxi,Dxi] = cellfun(@(x) shape1D_v2(n_x,Q_ksi,x),num2cell(ksi_l,2), 'UniformOutput',false);
        [Seta,Deta] = cellfun(@(x) shape1D_v2(n_y,Q_eta,x),num2cell(eta_l,2), 'UniformOutput',false);
                      
        wi_x = num2cell(wi_x,2);
        wi_y = num2cell(wi_y,2);
        
        gaussWeights_P = cellfun(@(x,y) kron(x,y)',wi_y, wi_x, 'UniformOutput',false);
        gaussWeights_P = cell2mat(gaussWeights_P);
        disp('Shape function...')
        shapeFunction = cellfun(@(x,y) sparseSF(x,y,[]),...
            Sxi,Seta, 'UniformOutput',false);
        shapeFunction_P = blkdiag(shapeFunction{:});
        disp('naturalDerivativesX...')
        naturalDerivativesX = cellfun(@(x,y) sparse(kron(x,y)),...
            Seta, Dxi, 'UniformOutput',false);
        naturalDerivativesX_P = blkdiag(naturalDerivativesX{:});
        disp('naturalDerivativesY...')
         naturalDerivativesY = cellfun(@(x,y) sparse(kron(x,y)),...
            Deta, Sxi, 'UniformOutput',false);
        naturalDerivativesY_P = blkdiag(naturalDerivativesY{:});
        
        clear msgid
        nC = cellfun(@(x) nodeCoordinates(x,:),num2cell(elementNodes,2), 'UniformOutput',false);
        
        if ~isempty(alpha_rot)
            alpha = num2cell(alpha_rot(:,1));
            beta = num2cell(alpha_rot(:,2));
            gamma = num2cell(alpha_rot(:,3));
            e_nodesTrans = cellfun(@(x) x(1,:),nC, 'UniformOutput',false);
            nC = cellfun(@(x,y) bsxfun(@minus, x,y),nC, e_nodesTrans, 'UniformOutput',false);
            R_xyz = cellfun(@global2local, alpha, beta, gamma, 'UniformOutput',false);
            nC = cellfun(@(x,y) transpose(round(x*y'*1e6)*1e-6), R_xyz,nC, 'UniformOutput',false);
            nC = cellfun(@(x,y) bsxfun(@plus, x,y),nC,e_nodesTrans, 'UniformOutput',false);
        end
        nC = cell2mat(nC);
        X_P = nC(:,1);
        Y_P = nC(:,2);
        XYZ_P = [X_P,Y_P];
        disp('Jacob...')
        % Jacob
        Jacob_P11 = naturalDerivativesX_P*X_P;
        Jacob_P12 = naturalDerivativesX_P*Y_P;
        Jacob_P21 = naturalDerivativesY_P*X_P;
        Jacob_P22 = naturalDerivativesY_P*Y_P;
        % (Jacob')^-1
        det_J = round((Jacob_P11.*Jacob_P22-Jacob_P12.*Jacob_P21)*1e8)*1e-8;
        Jacob_P11inv = round(1./det_J.*Jacob_P22*1e8)*1e-8;
        Jacob_P12inv = -round(1./det_J.*Jacob_P12*1e8)*1e-8;
        Jacob_P21inv = -round(1./det_J.*Jacob_P21*1e8)*1e-8;
        Jacob_P22inv = round(1./det_J.*Jacob_P11*1e8)*1e-8;
        Jacob_P13inv = [];Jacob_P23inv = []; Jacob_P31inv = []; Jacob_P32inv = []; Jacob_P33inv = [];
        naturalDerivativesZ_P = [];
%%
%%%%%%%%%%%%%%%%%%%%%%%
    case 3;
        [Sxi,Dxi] = cellfun(@(x) shape1D_v2(n_x,Q_ksi,x),num2cell(ksi_l,2), 'UniformOutput',false);
        [Seta,Deta] = cellfun(@(x) shape1D_v2(n_y,Q_eta,x),num2cell(eta_l,2), 'UniformOutput',false);
        [Szeta,Dzeta] = cellfun(@(x) shape1D_v2(n_z,Q_zeta,x),num2cell(zeta_l,2), 'UniformOutput',false);
                
        wi_x = num2cell(wi_x,2);
        wi_y = num2cell(wi_y,2);
        wi_z = num2cell(wi_z,2);
       
        gaussWeights_P = cellfun(@(x,y,z) kron(kron(x,y),z)',wi_z,wi_y, wi_x,...
            'UniformOutput',false);
        gaussWeights_P = cell2mat(gaussWeights_P);
        
        shapeFunction = cellfun(@(x,y,z) sparseSF(x,y,z),...
            Sxi,Seta,Szeta, 'UniformOutput',false);
        shapeFunction_P = blkdiag(shapeFunction{:});
        naturalDerivativesX = cellfun(@(x,y,z) sparseSF(x,y,z),...
            Dxi,Seta,Szeta, 'UniformOutput',false);
        naturalDerivativesX_P = blkdiag(naturalDerivativesX{:});
   
        naturalDerivativesY = cellfun(@(x,y,z) sparseSF(x,y,z),...
            Sxi,Deta,Szeta, 'UniformOutput',false);
        naturalDerivativesY_P = blkdiag(naturalDerivativesY{:});
        
        naturalDerivativesZ = cellfun(@(x,y,z) sparseSF(x,y,z),...
            Sxi,Seta,Dzeta, 'UniformOutput',false);
        naturalDerivativesZ_P = blkdiag(naturalDerivativesZ{:});

        clear msgid
        nC = cellfun(@(x) nodeCoordinates(x,:),num2cell(elementNodes,2), 'UniformOutput',false);
        nC = cell2mat(nC);
        X_P = nC(:,1);
        Y_P = nC(:,2);
        Z_P = nC(:,3);
        XYZ_P = [X_P,Y_P,Z_P];
        % Jacob
        disp('Jacob')
        Jacob_P11 = round(naturalDerivativesX_P*X_P*1e16)*1e-16;
        Jacob_P12 = round(naturalDerivativesX_P*Y_P*1e16)*1e-16;
        Jacob_P13 = round(naturalDerivativesX_P*Z_P*1e16)*1e-16;
        Jacob_P21 = round(naturalDerivativesY_P*X_P*1e16)*1e-16;
        Jacob_P22 = round(naturalDerivativesY_P*Y_P*1e16)*1e-16;
        Jacob_P23 = round(naturalDerivativesY_P*Z_P*1e16)*1e-16;
        Jacob_P31 = round(naturalDerivativesZ_P*X_P*1e16)*1e-16;
        Jacob_P32 = round(naturalDerivativesZ_P*Y_P*1e16)*1e-16;
        Jacob_P33 = round(naturalDerivativesZ_P*Z_P*1e16)*1e-16;
        disp('inv(Jacob)')
        det_J = round((Jacob_P11.*Jacob_P22.*Jacob_P33+...
            Jacob_P12.*Jacob_P23.*Jacob_P31+...
            Jacob_P13.*Jacob_P21.*Jacob_P32-...
            Jacob_P13.*Jacob_P22.*Jacob_P31-...
            Jacob_P11.*Jacob_P23.*Jacob_P32-...
            Jacob_P12.*Jacob_P21.*Jacob_P33)*1e16)*1e-16;
        Jacob_P11inv = round(1./det_J.*(Jacob_P22.*Jacob_P33-Jacob_P23.*Jacob_P32)*1e16)*1e-16;
        Jacob_P12inv = round(1./det_J.*(Jacob_P13.*Jacob_P32-Jacob_P12.*Jacob_P33)*1e16)*1e-16;
        Jacob_P13inv = round(1./det_J.*(Jacob_P12.*Jacob_P23-Jacob_P13.*Jacob_P22)*1e16)*1e-16;
        Jacob_P21inv = round(1./det_J.*(Jacob_P23.*Jacob_P31-Jacob_P21.*Jacob_P33)*1e16)*1e-16;
        Jacob_P22inv = round(1./det_J.*(Jacob_P11.*Jacob_P33-Jacob_P13.*Jacob_P31)*1e16)*1e-16;
        Jacob_P23inv = round(1./det_J.*(Jacob_P13.*Jacob_P21-Jacob_P11.*Jacob_P23)*1e16)*1e-16;
        Jacob_P31inv = round(1./det_J.*(Jacob_P21.*Jacob_P32-Jacob_P22.*Jacob_P31)*1e16)*1e-16;
        Jacob_P32inv = round(1./det_J.*(Jacob_P12.*Jacob_P31-Jacob_P11.*Jacob_P32)*1e16)*1e-16;
        Jacob_P33inv = round(1./det_J.*(Jacob_P11.*Jacob_P22-Jacob_P12.*Jacob_P21)*1e16)*1e-16;

end
w_P = gaussWeights_P.*det_J;
function shapeFunction = sparseSF(Sxi,Seta,Szeta )
         
         if isempty(Szeta)
            shapeFunction = kron(Seta,Sxi);
         else
            shapeFunction = kron(kron(Szeta,Seta),Sxi);
         end
         shapeFunction = round(shapeFunction*1e8)*1e-8;
         % shapeFunction(abs(shapeFunction)<1e-8) = 0;
         shapeFunction = sparse(shapeFunction);




