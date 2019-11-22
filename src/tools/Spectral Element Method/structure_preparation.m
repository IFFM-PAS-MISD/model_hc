function structure = structure_preparation(structure,dmgStruct)
% mesh generator 4 nods place in the corners of rectangle 
n_x = structure(1).DOF(2);
n_z = structure(1).DOF(3);
if length(structure(1).DOF) == 4
    n_y = structure(1).DOF(4);
else
    n_y = n_x;
end

[structure(1).ksi,structure(1).wix] = gll(n_x);
[structure(1).eta,structure(1).wiy] = gll(n_y);
[structure(1).zeta,structure(1).wiz] = gll(n_z);


[structure(1).nodeCoordinates,...
    structure(1).elementNodes,structure(1).rotation_angle] = mesh_generator(structure,1);
structure(1).thicknessElementNo = ones(size(structure(1).elementNodes,1),1);
% add internal nodes
if ~strcmp(structure(1).mesh_type,'honeycomb_core')
    [structure(1).elementNodes,structure(1).nodeCoordinates,~] = ...
        quad2spectral(structure(1).elementNodes,structure(1).nodeCoordinates,n_x-1,n_y-1);
%[structure(1).elementNodes,structure(1).nodeCoordinates]=...
%        internal_Nodes_SEM(structure(1),1,'old');
end
nodeCoordinates_int = structure(1).nodeCoordinates;
nodes_leyer = structure(1).elementNodes;
%add nodes for n_zeta>1
if n_z>1
    for i = 2:n_z
        max_Nodes = max(max(structure(1).elementNodes));
        structure(1).elementNodes(:,1 + (i-1)*structure(1).DOF(2)^2:...
            i*structure(1).DOF(2)^2) = nodes_leyer + max_Nodes;
        structure(1).nodeCoordinates(1 + size(nodeCoordinates_int,1)*(i-1):...
            size(nodeCoordinates_int,1)*(i),1:2) = nodeCoordinates_int(:,1:2);
        structure(1).nodeCoordinates(1 + size(nodeCoordinates_int,1)*(i-1):...
            size(nodeCoordinates_int,1)*(i),3) = nodeCoordinates_int(:,3) + ...
            structure(1).geometry(3)/structure(1).numElements(3)/2 + ...
            structure(1).zeta(i)*structure(1).geometry(3)/...
            structure(1).numElements(3)/2;
    end
structure(1).nodeCoordinates(:,3) = structure(1).nodeCoordinates(:,3)-...
    structure(1).geometry(3)/2;
end
if structure(1).numElements(3)>1
    nodes_leyer = structure(1).elementNodes;
    for i = 2:structure(1).numElements(3)
        max_Nodes = max(max(structure(1).elementNodes));
        elementNodes_el = zeros(size(nodes_leyer));
        elementNodes_el(:,1:structure(1).DOF(2)^2) = ...
            structure(1).elementNodes(1 + size(nodes_leyer)*(i-2):size(nodes_leyer)*...
            (i-1),1 + structure(1).DOF(2)^2*(n_z-1):end);
        elementNodes_el(:,1 + structure(1).DOF(2)^2:end) = ...
            nodes_leyer(:,1:size(nodes_leyer,2)-structure(1).DOF(2)^2) + max_Nodes;
        structure(1).elementNodes = [structure(1).elementNodes;elementNodes_el];
        nodeCoordinates_el = structure(1).nodeCoordinates(1 + size(nodeCoordinates_int,1)*(...
            (n_z-1)*(i-2)):size(nodeCoordinates_int,1)*(...
            (n_z-1)*(i-1) + 1),:);
        nodeCoordinates_el(:,3) = nodeCoordinates_el(:,3) + structure(1).geometry(3)/...
            structure(1).numElements(3);
        structure(1).nodeCoordinates = [structure(1).nodeCoordinates;
        nodeCoordinates_el(1 + size(nodeCoordinates_int,1):end,:)];
        structure(1).thicknessElementNo = [structure(1).thicknessElementNo;
            i*ones(size(elementNodes_el,1),1)];
    end
    if ~strcmp(structure(1).mesh_type,'honeycomb_core')
        structure(1).rotation_angle = zeros(size(structure(1).elementNodes,1),3);
    end
end
structure(1).interfaceElements = zeros(size(structure(1).elementNodes,1),...
    size(structure(1).stAttach,2));
for i = 1:size(structure(1).stAttach,2)
    structure(1).interfaceElements(:,i)=...
        intElements(structure(1),structure(structure(1).stAttach(1,i)),i);    
end
if size(structure,2)>1
    for i = 2:size(structure,2);
        n_x = structure(i).DOF(2);
        n_z = structure(i).DOF(3);
        if length(structure(i).DOF) == 4
            n_y = structure(i).DOF(4);
        else
            n_y = n_x;
        end
        [structure(i).ksi,structure(i).wix] = gll(n_x);
        [structure(i).eta,structure(i).wiy] = gll(n_y);
        [structure(i).zeta,structure(i).wiz] = gll(n_z);
        if ~strcmp(structure(i).mesh_type,'base')
            [structure(i).nodeCoordinates,...
                structure(i).elementNodes,structure(i).rotation_angle] = ...
                mesh_generator(structure,i);
            structure(i).thicknessElementNo = ones(size(structure(i).elementNodes,1),1);
            if ~strcmp(structure(i).mesh_type,'honeycomb_core')

                % add internal nodes
                 [structure(i).elementNodes,structure(i).nodeCoordinates,~] = ...
                 quad2spectral(structure(i).elementNodes,structure(i).nodeCoordinates,n_x-1,n_y-1);
%[structure(i).elementNodes,structure(i).nodeCoordinates]=...
%      internal_Nodes_SEM(structure(i),i,'old');
                nodeCoordinates_int = structure(i).nodeCoordinates;
                nodes_leyer = structure(i).elementNodes;
                %add nodes for n_zeta>1
                if n_z>1
                    for ii = 2:n_z
                    max_Nodes = max(max(structure(i).elementNodes));
                    structure(i).elementNodes(:,1 + (ii-1)*n_x*n_y:...
                        ii*n_x*n_y) = nodes_leyer + max_Nodes;
                    structure(i).nodeCoordinates(1 + size(nodeCoordinates_int,1)*(ii-1):...
                        size(nodeCoordinates_int,1)*(ii),1:2) = nodeCoordinates_int(:,1:2);
                    structure(i).nodeCoordinates(1 + size(nodeCoordinates_int,1)*(ii-1):...
                        size(nodeCoordinates_int,1)*(ii),3) = nodeCoordinates_int(:,3) + ...
                        structure(i).geometry(3)/structure(i).numElements(3)/2 + ...
                        structure(i).zeta(ii)*structure(i).geometry(3)/...
                        structure(i).numElements(3)/2;
                    end 
                    structure(i).nodeCoordinates(:,3) = structure(i).nodeCoordinates(:,3)-...
                        structure(i).geometry(3)/2;
                    if ~strcmp(structure(i).mesh_type,'honeycomb_core')
                        structure(i).rotation_angle = zeros(size(structure(i).elementNodes,1),3);
                    end
                end
                if structure(i).numElements(3)>1
                    nodes_leyer = structure(i).elementNodes;

                    for ii = 2:structure(i).numElements(3)
                        max_Nodes = max(max(structure(i).elementNodes));
                        elementNodes_el = zeros(size(nodes_leyer));
                        elementNodes_el(:,1:n_x*n_y) = ...
                            structure(i).elementNodes(1 + size(nodes_leyer)*(ii-2):...
                            size(nodes_leyer)*(ii-1),1 + n_x*n_y*...
                            (n_z-1):end);
                        elementNodes_el(:,1 + n_x*n_y:end) = ...
                            nodes_leyer(:,1:size(nodes_leyer,2)-n_x*n_y) + max_Nodes;
                        structure(i).elementNodes =  [structure(i).elementNodes;elementNodes_el];
                        nodeCoordinates_el = ...
                            structure(i).nodeCoordinates(1 + size(nodeCoordinates_int,1)*...
                            n_z*(ii-2):size(nodeCoordinates_int,1)*...
                            n_z*(ii-1),:);
                        nodeCoordinates_el(:,3) = nodeCoordinates_el(:,3) + ...
                            structure(i).geometry(3)/structure(i).numElements(3);
                        structure(i).nodeCoordinates = [structure(i).nodeCoordinates;
                        nodeCoordinates_el(1 + size(nodeCoordinates_int,1):end,:)];
                        structure(i).thicknessElementNo = [structure(i).thicknessElementNo;
                        ii*ones(size(elementNodes_el,1),1)];
                    end
                end
            end
        else
            [structure(i).nodeCoordinates,structure(i).elementNodes,structure(i).thicknessElementNo] = ...
                nodes_generator(structure(structure(i).stAttach(1,1)),structure(i),i);

        end
        for ii = 1:size(structure(i).stAttach,2)
            structure(i).interfaceElements(:,ii) = ...
                intElements(structure(i),structure(structure(i).stAttach(1,ii)),ii);    
        end
        % boundary condition
        [structure(i).prescribedDof,structure(i).activeDof,structure(i).GDof] =  ...
            EssentialBC(structure(i));
        % force
        [structure(i).P,structure(i).forceNode,structure(i).U_pD] = ...
            structure_force(structure(i));
        
    end
end
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% old
% if ~isfield(structure(i),'dmgGeometry');structure(i).dmgGeometry = []; end
% if ~isfield(structure(i),'dmgShape');structure(i).dmgShape = []; end
% for ii = 1:size(structure(i).stAttach,2)
%     [structure(i).elementNodes,structure(i).nodeCoordinates,...
%         structure(i).nodes_dmg(:,ii)] = damage_input(structure(i),...
%         structure(structure(i).stAttach(1,ii)),ii);
% end
% damage
for i = 1:size(structure,2)

    if ~isempty(dmgStruct)
        C0 = 0;
        for j = 1:length(dmgStruct)
            if i == dmgStruct(j).structure
                C0 = C0 + 1;
               [structure(i).elementNodes,structure(i).nodeCoordinates,structure(i).rotation_angle,...
                structure(i).nodes_dmg{C0}] = damage_nodes(dmgStruct(j),structure(i));
            end
        end
    else 
        structure(i).nodes_dmg = [];
    end

% boundary condition
        [structure(i).prescribedDof,structure(i).activeDof,structure(i).GDof] =  ...
            EssentialBC(structure(i));
        % force
        [structure(i).P,structure(i).forceNode,structure(i).U_pD] = ...
            structure_force(structure(i));

end


%% properties

for i = 1:size(structure,2)
    
    n_x = structure(i).DOF(2);
    n_z = structure(i).DOF(3);
    if length(structure(i).DOF) == 4
        n_y = structure(i).DOF(4);
    else
        n_y = n_x;
    end
    structure(i).numberNodes = length(unique(structure(i).elementNodes));
    structure(i).numberElements = size(structure(i).elementNodes,1);
    [structure(i).I_G,structure(i).I_L] = nodesMaps(n_x,n_y,n_z,structure(i).elementNodes);
    [structure(i).w_P,structure(i).Jacob_P11inv,structure(i).Jacob_P12inv,structure(i).Jacob_P21inv,...
        structure(i).Jacob_P22inv,structure(i).Jacob_P13inv,structure(i).Jacob_P23inv,...
        structure(i).Jacob_P31inv,structure(i).Jacob_P32inv,structure(i).Jacob_P33inv,...
        structure(i).shapeFunction_P,structure(i).naturalDerivativesX_P,...
        structure(i).naturalDerivativesY_P,structure(i).naturalDerivativesZ_P,structure(i).XYZ_P] = ...
        Jacob_NbN(structure(i).DOF(1),n_x,n_y,n_z,...
        structure(i).elementNodes,structure(i).nodeCoordinates,structure(i).rotation_angle);   
  
    disp(['C stiffness coefficients_',num2str(i),'.......'])      
    [structure(i).rho,structure(i).J11,structure(i).a11,structure(i).a12,...
        structure(i).a16,structure(i).a22,structure(i).a26,structure(i).a66,...
        structure(i).a44_2d,structure(i).a45_2d,structure(i).a55_2d,...
        structure(i).b11,structure(i).b12,structure(i).b16,structure(i).b22,...
        structure(i).b26,structure(i).b66,structure(i).d11,structure(i).d12,...
        structure(i).d16,structure(i).d22,structure(i).d26,structure(i).d66,...
        structure(i).c11,structure(i).c12,structure(i).c13,structure(i).c14,...
        structure(i).c15,structure(i).c16,structure(i).c21,structure(i).c22,...
        structure(i).c23,structure(i).c24,structure(i).c25,structure(i).c26,...
        structure(i).c31,structure(i).c32,structure(i).c33,structure(i).c34,...
        structure(i).c35,structure(i).c36,structure(i).c41,structure(i).c42,...
        structure(i).c43,structure(i).c44,structure(i).c45,structure(i).c46,...
        structure(i).c51,structure(i).c52,structure(i).c53,structure(i).c54,...
        structure(i).c55,structure(i).c56,structure(i).c61,structure(i).c62,...
        structure(i).c63,structure(i).c64,structure(i).c65,structure(i).c66,...
        structure(i).e_p,structure(i).epsS] = structure_prop_full(structure(i));
    clc
    disp(['C stiffness coefficients',num2str(i),'...done'])
end
%%
% mass stiffness and force matrix
err_el = zeros(size(structure,2),2); 
for i = 1:size(structure,2)
    n_x = structure(i).DOF(2);
    n_z = structure(i).DOF(3);
    n_y = structure(i).DOF(4);
    
    structure(i).c_xpx = []; structure(i).c_xpy = []; structure(i).c_xpz = [];
            structure(i).c_ypx = []; structure(i).c_ypy = []; structure(i).c_ypz = [];
            structure(i).c_zpx = []; structure(i).c_zpy = []; structure(i).c_zpz = [];
    switch structure(i).DOF(1)
        case 2
            structure(i).Mass = zeros(structure(i).numberNodes,1);   
            M_P = structure(i).rho.*diag(structure(i).shapeFunction_P*...
                structure(i).shapeFunction_P').*structure(i).w_P(:,1);
            for ii = 1:12
                structure(i).Mass(structure(i).I_G(:,ii)) = ...
                structure(i).Mass(structure(i).I_G(:,ii)) + M_P(structure(i).I_L(:,ii));
            end
            structure(i).Mass = repmat(structure(i).Mass,3,1);
        case 3
            structure(i).Mass = zeros(structure(i).numberNodes,1);   
            M_P = structure(i).rho.*diag(structure(i).shapeFunction_P*...
                structure(i).shapeFunction_P').*structure(i).w_P(:,1);
            for ii = 1:12
                structure(i).Mass(structure(i).I_G(:,ii)) = ...
                structure(i).Mass(structure(i).I_G(:,ii)) + M_P(structure(i).I_L(:,ii));
            end
            structure(i).Mass = repmat(structure(i).Mass,3,1);
            
        case 5
            structure(i).Mass = zeros(structure(i).numberNodes,1);   
            M_I = zeros(structure(i).numberNodes,1);   
            M_P = structure(i).geometry(3)*structure(i).rho.*diag(structure(i).shapeFunction_P*...
                structure(i).shapeFunction_P').*structure(i).w_P(:,1);
            M_PI = structure(i).J11.*diag(structure(i).shapeFunction_P*...
                structure(i).shapeFunction_P').*structure(i).w_P(:,1);
            for ii = 1:12
                structure(i).Mass(structure(i).I_G(:,ii)) = ...
                    structure(i).Mass(structure(i).I_G(:,ii)) + M_P(structure(i).I_L(:,ii));
                M_I(structure(i).I_G(:,ii)) = M_I(structure(i).I_G(:,ii)) + ...
                    M_PI(structure(i).I_L(:,ii));
            end
            structure(i).Mass = [repmat(structure(i).Mass,3,1);repmat(M_I,2,1)];
        case 6
            %local mass matrix
            M1 = zeros(structure(i).numberNodes,1);
            M2 = M1; M3 = M1;
            M_I1 = zeros(structure(i).numberNodes,1);
            M_I2 = M_I1;M_I3 = M_I1;
            if strcmp(structure(i).mesh_type,'honeycomb_core')
                h = structure(i).properties(end);
            else
                h = structure(i).geometry(3);
            end
            M_P = h*structure(i).rho.*diag(structure(i).shapeFunction_P*...
                structure(i).shapeFunction_P').*structure(i).w_P(:,1);
            M_PI = structure(i).J11.*diag(structure(i).shapeFunction_P*...
                structure(i).shapeFunction_P').*structure(i).w_P(:,1);
           % mass matrix from local to global coordinates
            c_xpx = cell(structure(i).numberElements,1);
            c_xpy = cell(structure(i).numberElements,1);
            c_xpz = cell(structure(i).numberElements,1);
            
            c_ypx = cell(structure(i).numberElements,1);
            c_ypy = cell(structure(i).numberElements,1);
            c_ypz = cell(structure(i).numberElements,1);
            
            c_zpx = cell(structure(i).numberElements,1);
            c_zpy = cell(structure(i).numberElements,1);
            c_zpz = cell(structure(i).numberElements,1);
            
            for e = 1:structure(i).numberElements;
                R_xyz = global2local(structure(i).rotation_angle(e,1),...
                    structure(i).rotation_angle(e,2),structure(i).rotation_angle(e,3));
                c_xpx{e} = repmat(R_xyz(1,1),n_x*n_y,1);
                c_xpy{e} = repmat(R_xyz(1,2),n_x*n_y,1);
                c_xpz{e} = repmat(R_xyz(1,3),n_x*n_y,1);
                
                c_ypx{e} = repmat(R_xyz(2,1),n_x*n_y,1);
                c_ypy{e} = repmat(R_xyz(2,2),n_x*n_y,1);
                c_ypz{e} = repmat(R_xyz(2,3),n_x*n_y,1);
                c_zpx{e} = repmat(R_xyz(3,1),n_x*n_y,1);
                c_zpy{e} = repmat(R_xyz(3,2),n_x*n_y,1);
                c_zpz{e} = repmat(R_xyz(3,3),n_x*n_y,1);
                
            end
            c_xpx = cell2mat(c_xpx); c_xpy = cell2mat(c_xpy); c_xpz = cell2mat(c_xpz);
            c_ypx = cell2mat(c_ypx); c_ypy = cell2mat(c_ypy); c_ypz = cell2mat(c_ypz);
            c_zpx = cell2mat(c_zpx); c_zpy = cell2mat(c_zpy); c_zpz = cell2mat(c_zpz);
            
            M_Pg1 = c_xpx.^2.*M_P + c_ypx.^2.*M_P + c_zpx.^2.*M_P;
            M_Pg2 = c_xpy.^2.*M_P + c_ypy.^2.*M_P + c_zpy.^2.*M_P;
            M_Pg3 = c_xpz.^2.*M_P + c_ypz.^2.*M_P + c_zpz.^2.*M_P;
            M_PIg1 = c_xpx.^2.*M_PI + c_ypx.^2.*M_PI + c_zpx.^2.*M_PI;
            M_PIg2 = c_xpy.^2.*M_PI + c_ypy.^2.*M_PI + c_zpy.^2.*M_PI;
            M_PIg3 = c_xpz.^2.*M_PI + c_ypz.^2.*M_PI + c_zpz.^2.*M_PI;
            
            for ii = 1:12
                M1(structure(i).I_G(:,ii)) = ...
                    M1(structure(i).I_G(:,ii)) + M_Pg1(structure(i).I_L(:,ii));
                M2(structure(i).I_G(:,ii)) = ...
                    M1(structure(i).I_G(:,ii)) + M_Pg2(structure(i).I_L(:,ii));
                M3(structure(i).I_G(:,ii)) = ...
                    M1(structure(i).I_G(:,ii)) + M_Pg3(structure(i).I_L(:,ii));
                M_I1(structure(i).I_G(:,ii)) = M_I1(structure(i).I_G(:,ii)) + ...
                    M_PIg1(structure(i).I_L(:,ii));
                M_I2(structure(i).I_G(:,ii)) = M_I2(structure(i).I_G(:,ii)) + ...
                    M_PIg2(structure(i).I_L(:,ii));
                M_I3(structure(i).I_G(:,ii)) = M_I3(structure(i).I_G(:,ii)) + ...
                    M_PIg3(structure(i).I_L(:,ii));
            end
            
            structure(i).c_xpx = c_xpx;
            structure(i).c_xpy = c_xpy;
            structure(i).c_xpz = c_xpz;
            structure(i).c_ypx = c_ypx;
            structure(i).c_ypy = c_ypy;
            structure(i).c_ypz = c_ypz;
            structure(i).c_zpx = c_zpx;
            structure(i).c_zpy = c_zpy;
            structure(i).c_zpz = c_zpz;
            
            structure(i).Mass = [M1;M2;M3;M_I1;M_I2;M_I3];
    end
    
    structure(i).Force = structure(i).P;
         
    for ii = 1:structure(i).DOF(1)
        structure(i).Damp(1 + structure(i).numberNodes*(ii-1):...
            structure(i).numberNodes*ii,1) = structure(i).damp_coef(ii).*...
            structure(i).Mass(1 + structure(i).numberNodes*(ii-1):...
            structure(i).numberNodes*ii);
    end
    [structure(i).prescribedPhi,structure(i).Phi,structure(i).groundNode,structure(i).voltageNode] = ...
        piezo_function(structure(i)); 
    structure(i).electrodeLayer = zeros(size(structure,2),1); 
    if isempty(structure(i).piezo_type)
        
        structure(i).stiffness_uV = sparse([],[],[],0,1,0);
        structure(i).stiffness_V = sparse([],[],[],0,1,0);
        structure(i).inv_stiffness_V = sparse([],[],[],0,1,0);
        structure(i).stiffness_Vu = sparse([],[],[],0,1,0);
        structure(i).activePhi = sparse([],[],[],0,1,0);
        structure(i).Phi = sparse([],[],[],0,1,0);
    else
    
        if structure(i).stAttach(2,1) == -1
            structure(i).electrodeLayer = structure(i).DOF(3);
        elseif structure(i).stAttach(2,1) == 1
            structure(i).electrodeLayer(i) = 1;
        end
        [structure(i).prescribedPhi,structure(i).Phi,structure(i).groundNode,structure(i).voltageNode] =...
            piezo_function(structure(i));
        [structure(i).stiffness_uV,structure(i).stiffness_V,err_el(i,2)] = ...
            formStiffnessV_full(structure(i));
        structure(i).stiffness_Vu = structure(i).stiffness_uV';
        structure(i).activePhi = cell(1,size(cellstr(structure(i).piezo_type),1));
        structure(i).activePhi = setdiff((1:structure(i).numberNodes)',structure(i).prescribedPhi);
        structure(i).inv_stiffness_V = structure(i).stiffness_V(structure(i).activePhi,...
            structure(i).activePhi)^(-1);
    end
end
if any(err_el) ~= 0
    disp(err_el)
    disp('Mesh is bad defined')
    return;
end