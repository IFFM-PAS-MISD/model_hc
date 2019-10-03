function [stiffness_uV,stiffness_V,err_el] = formStiffnessV_full(structure_i)
% compute stiffness V and uV matrix
%structure_i = structure(i);
numberElements = structure_i.numberElements;
nodeCoordinates = structure_i.nodeCoordinates;
elementNodes = structure_i.elementNodes;
numberNodes = structure_i.numberNodes;
DOF = structure_i.DOF(1);
ksi = structure_i.ksi;wi_x=structure_i.wix;
eta = structure_i.eta;wi_y=structure_i.wiy;
zeta = structure_i.zeta;wi_z=structure_i.wiz;
n = structure_i.DOF(2);n_zeta=structure_i.DOF(3);
e_p = structure_i.e_p;epsS=structure_i.epsS;
GDof = structure_i.GDof;
C1 = 0;
lastwarn('')
err_n = 0;
err_el = 0;
stiffness_uV = sparse([],[],[],GDof,numberNodes,0);
stiffness_V = sparse([],[],[],numberNodes,numberNodes,0);

[gaussLocations,gaussWeights] = gaussQuadrature(ksi,eta,zeta,wi_x,wi_y,wi_z,DOF);
for e = 1:numberElements
    C1 = C1+1;
    indice = elementNodes(e,:);
    elementDof = [indice indice+numberNodes indice+2*numberNodes];
    ndof = length(indice);
    stiffness_uV_temp = zeros(length(elementDof),length(indice));
    stiffness_V_temp = zeros(length(indice),length(indice));
        % cycle for Gauss point
    for q = 1:size(gaussWeights,1)
   GaussPoint = gaussLocations(q,:);
    xi = GaussPoint(1);
    eta = GaussPoint(2);
    zeta = GaussPoint(3);
    [~,naturalDerivatives] = shape_function(xi,eta,zeta,n,n_zeta);
    [Jacob,~,XYZderivatives] = Jacobian(nodeCoordinates(indice,:),naturalDerivatives);
    B = zeros(6,3*ndof);
    B(1,1:ndof) = XYZderivatives(:,1)';
    B(2,ndof+1:2*ndof) = XYZderivatives(:,2)';
    B(3,2*ndof+1:3*ndof) = XYZderivatives(:,3)';
    B(4,ndof+1:2*ndof) = XYZderivatives(:,3)';
    B(4,2*ndof+1:3*ndof) = XYZderivatives(:,2)';
    B(5,1:ndof) = XYZderivatives(:,3)';
    B(5,2*ndof+1:3*ndof) = XYZderivatives(:,1)';
    B(6,1:ndof) = XYZderivatives(:,2)';
    B(6,ndof+1:2*ndof) = XYZderivatives(:,1)';
    B = round(B*1e8)*1e-8;
    
    B_f=zeros(3,ndof);
    B_f(1,1:ndof) = XYZderivatives(:,1)';
    B_f(2,1:ndof) = XYZderivatives(:,2)';
    B_f(3,1:ndof) = XYZderivatives(:,3)';
    B_f = round(B_f*1e8)*1e-8;
    % stiffness matrix  
    stiffness_uV_temp = stiffness_uV_temp + B'*e_p'*B_f*gaussWeights(q)*det(Jacob);
    stiffness_V_temp = stiffness_V_temp + B_f'*(epsS*B_f)*gaussWeights(q)*det(Jacob);

    end
    [err_n,err_el] = check_singularity(1,err_n,err_el);    
    stiffness_uV = stiffness_uV+sparse(repmat(elementDof',1,length(indice)),...
        repmat(indice,length(elementDof),1),stiffness_uV_temp,...
        GDof,numberNodes);
    stiffness_V = stiffness_V+sparse(repmat(indice',1,length(indice)),...
        repmat(indice,length(indice),1),stiffness_V_temp,...
        numberNodes,numberNodes);

end
end


