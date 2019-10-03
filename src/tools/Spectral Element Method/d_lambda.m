clc; disp('iMpC matrix...')
MpC = cell(size(structure,2),1); M = cell(size(structure,2),1);
invMpC = cell(size(structure,2),1); MmC = cell(size(structure,2),1);
for i = 1:size(structure,2)
    iM = structure(i).Mass;
    iD = structure(i).Damp;
    M{i} = sparse((1:size(iM,1))',(1:size(iM,1))',2*iM/ts^2);
    MpC{i} = sparse((1:size(iM,1))',(1:size(iM,1))',(iM/ts + iD/2)/ts);
    invMpC{i} = sparse((1:size(iM,1))',(1:size(iM,1))',1./((iM/ts + iD/2)/ts));
    MmC{i} = sparse((1:size(iM,1))',(1:size(iM,1))',(iM/ts - iD/2)/ts);
end
clc;
disp('iMpC matrix...done')

if size(structure,2)>1
    disp('G matrix...');intLay=[];
    for i = 1:size(structure,2)
        for ii = 1:size(structure(i).stAttach,2)
                intLay = [intLay,[i;structure(i).stAttach(1,ii)]];
        end
    end
    intLay = unique(sort(intLay)','rows');   
    % Lagrange multiplier
    shapeFunction_interface = cell(size(intLay,1),size(structure,2));
    G = cell(size(intLay,1),size(structure,2));
    ownerElement_interface = cell(size(intLay,1),size(structure,2));
    nodes_order = cell(size(intLay,1),size(structure,2),1);
    for i = 1 : size(intLay,1)
      
        k1 = intLay(i,1);
        k2 = intLay(i,2);
        k3 = find(structure(k1).stAttach(1,:) == k2);
        k4 = find(structure(k2).stAttach(1,:) == k1);
        nx_k1 = structure(k1).DOF(2);
        ny_k1 = structure(k1).DOF(4);
        nz_k1 = structure(k1).DOF(3);
        nx_k2 = structure(k2).DOF(2);
        ny_k2 = structure(k2).DOF(4);
        nz_k2 = structure(k2).DOF(3);
        if ~structure(k1).stAttach(3,k3) && ~structure(k2).stAttach(3,k4)
            % from file
            if structure(k1).stAttach(2,k3) == -1
                nodes_k1 = find(structure(k1).nodeCoordinates(:,3) == ...
                    min(unique(structure(k1).nodeCoordinates(:,3))));
                
                nodes_k2 = find(structure(k2).nodeCoordinates(:,3) == ...
                    max(unique(structure(k2).nodeCoordinates(:,3))));
            elseif structure(k1).stAttach(2,k3)==1
                nodes_k1 = find(structure(k1).nodeCoordinates(:,3) == ...
                    max(unique(structure(k1).nodeCoordinates(:,3))));
                nodes_k2 = find(structure(k2).nodeCoordinates(:,3) == ...
                    min(unique(structure(k2).nodeCoordinates(:,3))));
            end
            if strcmp(structure(k1).mesh_type,'honeycomb_core') && ...
                    strcmp(structure(k2).mesh_type,'honeycomb_skin')
                if isfield(structure(k1),'nodes_dmg')
                    dmgNodes = cell2mat(structure(k1).nodes_dmg);
                    nodes_k1 = setdiff(nodes_k1,dmgNodes);
                else
                    dmgNodes = [];
                end
                
                nodeCoordinates_k2 = structure(k2).nodeCoordinates(nodes_k2,1:2);
                nodeCoordinates_k1 = structure(k1).nodeCoordinates(nodes_k1,1:2);
                
                jj = cell(size(nodes_k1));
                for iNode = 1:length(nodes_k1)
                    iNodeCoor_k1 = nodeCoordinates_k1(iNode,1:2);
                    [~,bb] = min(sqrt((nodeCoordinates_k2(:,1)-iNodeCoor_k1(1)).^2+...
                        (nodeCoordinates_k2(:,2)-iNodeCoor_k1(2)).^2));
                    jj{iNode} = [nodes_k1(iNode), bb];
                end
                jj = cell2mat(jj);
                
                G_k2 = sparse(1:size(nodes_k1,1),jj(:,2),1,size(nodes_k1,1),...
                    size(structure(k2).nodeCoordinates,1));
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                if structure(k2).DOF(1) == 5
                    H = 0.5*structure(k2).geometry(3)*structure(k2).stAttach(2,k4);
                    G{i,k2} = horzcat(G{i,k2}, vertcat(blkdiag(H*G_k2,H*G_k2),horzcat(0*G_k2,0*G_k2)));
                end
                G_k1 = sparse(1:size(nodes_k1,1),jj(:,1),1,size(nodes_k1,1),...
                    size(structure(k1).nodeCoordinates,1));
                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                G{i,k1} = horzcat(G{i,k1}, sparse(size(G{i,k1},1),size(G{i,k1},2)));
                
            elseif strcmp(structure(k2).mesh_type,'honeycomb_core')&& ...
                    strcmp(structure(k1).mesh_type,'honeycomb_skin')
                if isfield(structure(k2),'nodes_dmg')
                    dmgNodes = cell2mat(structure(k2).nodes_dmg);
                    nodes_k2 = setdiff(nodes_k2,dmgNodes);
                else
                    dmgNodes = [];
                end
                nodeCoordinates_k2 = structure(k2).nodeCoordinates(nodes_k2,1:2);
                nodeCoordinates_k1 = structure(k1).nodeCoordinates(nodes_k1,1:2);
                jj = cell(size(nodes_k2));
                for iNode = 1:length(nodes_k2)
                    iNodeCoor_k2 = nodeCoordinates_k2(iNode,1:2);
                    [aa,bb] = min(sqrt((nodeCoordinates_k1(:,1)-iNodeCoor_k2(1)).^2+...
                        (nodeCoordinates_k1(:,2)-iNodeCoor_k2(2)).^2));
                    jj{iNode} = [bb, nodes_k2(iNode)];
                end
                jj = cell2mat(jj);
                G_k1 = sparse(1:size(nodes_k2,1),jj(:,1),1,size(nodes_k2,1),...
                    size(structure(k1).nodeCoordinates,1));
                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                if structure(k1).DOF(1) == 5
                    H = 0.5*structure(k1).geometry(3)*structure(k1).stAttach(2,k3);
                    G{i,k1} = horzcat(G{i,k1}, vertcat(blkdiag(H*G_k1,H*G_k1),horzcat(0*G_k1,0*G_k1)));
                end
                G_k2 = sparse(1:size(nodes_k2,1),jj(:,2),1,size(nodes_k2,1),...
                    size(structure(k2).nodeCoordinates,1));
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                G{i,k2} = horzcat(G{i,k2}, sparse(size(G{i,k2},1),size(G{i,k2},2)));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            elseif strcmp(structure(k1).mesh_type,'honeycomb_core') && ...
                    ~strcmp(structure(k2).mesh_type,'honeycomb_skin')
                if structure(k2).stAttach(2,k4) == -1
                    elementNodes_k2 = structure(k2).elementNodes(1 : size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3),1:nx_k2*ny_k2);
                    elementNodes_k1 = structure(k1).elementNodes(1+size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3)*(structure(k1).numElements(3)-1) : ...
                        size(structure(k1).elementNodes,1), 1+nx_k1*(ny_k1-1) : nx_k1*ny_k1);
                elseif structure(k2).stAttach(2,k4) == 1
                    elementNodes_k2 = structure(k2).elementNodes(1+size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3)*(structure(k2).numElements(3)-1) : ...
                        size(structure(k2).elementNodes,1), 1+nx_k2*ny_k2*...
                        (nz_k12-1) : nx_k2*ny_k2*nz_k2);
                    elementNodes_k1 = structure(k1).elementNodes(1:size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3), 1 : nx_k1);
                end
                           
                nodeCoordinates_k1 = structure(k1).nodeCoordinates;
                nodeCoordinates_k2 = structure(k2).nodeCoordinates;
                alpha = structure(k1).rotation_angle;
                
                
                nx_int = nx_k1; ny_int = 1;
                [b, ~, n] = unique(reshape(elementNodes_k1',[],1));
                
                nodeCoordinates_interface = nodeCoordinates_k1(b,:);
                elementNodes_interface = reshape(n,size(elementNodes_k1,2),[])';
                
                x_p = nodeCoordinates_interface(:,1);
                y_p = nodeCoordinates_interface(:,2);
                z_p = nodeCoordinates_interface(:,3);
                
                ownerElement_interface = zeros(length(b),1);
                for iNode_int = 1 : length(b)
                    ownerElement_interface(iNode_int,1) = ...
                        find(any(ismember(elementNodes_k1,b(iNode_int)),2),1,'first');
                end
                [Ksi,wi_x]=gll(nx_int);
                Ksi = repmat(Ksi,length(x_p),1);
                elementNodes_owner = elementNodes_interface(ownerElement_interface,:);
                
                Eps = 1e-8;
                x_0 = nodeCoordinates_k1(elementNodes_owner,1);
                x_0 = reshape(x_0,[],nx_int);
                y_0 = nodeCoordinates_k1(elementNodes_owner,2);
                y_0 = reshape(y_0,[],nx_int);
                                
                [~,point_no] = min(sqrt(bsxfun(@minus, x_p,x_0).^2+bsxfun(@minus, y_p,y_0).^2),[],2);
                x_0 = round(x_0(sub2ind(size(x_0),(1:length(point_no))',point_no))/Eps)*Eps;
                y_0 = round(y_0(sub2ind(size(y_0),(1:length(point_no))',point_no))/Eps)*Eps;

                ksi_p = Ksi(sub2ind(size(Ksi),ones(length(point_no),1),point_no));
                [Q_ksi] = Vandermonde_v2(gll(nx_int),nx_int);
                [Q_eta] = Vandermonde_v2(gll(1),1);
                
                nodes_order = reshape(elementNodes_owner',[],1);

                x_e = nodeCoordinates_k1(nodes_order,1);
                y_e = nodeCoordinates_k1(nodes_order,2);
                
                c_alpha = round(cos(alpha(ownerElement_interface,3))*1e6)*1e-6;
                s_alpha = round(sin(alpha(ownerElement_interface,3))*1e6)*1e-6;
                c_alpha = reshape(repmat(c_alpha,1,nx_int)',[],1);
                s_alpha = reshape(repmat(s_alpha,1,nx_int)',[],1);
                
                [shapeFunction_interface,naturalDerivativesX_P,naturalDerivativesY_P] = ...
                    shapeFunction_2D(Q_ksi,Q_eta,ksi_p,ones(size(ksi_p)),'a');
                J11 = naturalDerivativesX_P*(c_alpha.*x_e+s_alpha.*y_e);
                det_J = round(J11*1e6)*1e-6;
                
                w_p = wi_x;
                w_p = repmat(w_p,length(x_p),1);
                w_p = w_p(sub2ind(size(w_p),ones(length(point_no),1),point_no)).*det_J;
                
                [shapeFunction_k2,ownerElement_k2,~,~] = ...
                    spectral2meshgrid(structure(k2).DOF(2),structure(k2).DOF(4),nodeCoordinates_k2,...
                    elementNodes_k2,nodeCoordinates_interface);
               
                [r,c,v] = find(shapeFunction_k2'*shapeFunction_interface);
                c = mod(c,nx_int*ny_int); c(c==0) = nx_int*ny_int;
                
                g = sparse(r,c,v,nx_k2*ny_k2*length(nodeCoordinates_interface),nx_int*ny_int);
                g = bsxfun(@times,g,reshape(repmat(w_p',nx_k2*ny_k2,1),[],1));
                
                
                G_k2 = sparse(length(ownerElement_interface),size(nodeCoordinates_k2,1),0);
                G{i,k2} = sparse(nx_k2*ny_k2,nx_int*ny_int,0);
                for iOE_I = 1:length(ownerElement_interface)
                    clc; disp(i);disp([num2str(iOE_I) ' from ' num2str(length(ownerElement_interface))])
                    iSparse = repmat(elementNodes_interface(ownerElement_interface(iOE_I),:)',1,nx_k2*ny_k2);
                    jSparse = repmat(elementNodes_k2(ownerElement_k2(iOE_I),:),nx_int*ny_int,1);
                    G_k2 = G_k2 + sparse(iSparse,jSparse,(g((1:nx_k2*ny_k2)+(iOE_I-1)*nx_k2*ny_k2,:))',...
                        length(ownerElement_interface),size(nodeCoordinates_k2,1));
                end
                if isfield(structure(k1),'nodes_dmg')
                    dmgNodes = cell2mat(structure(k1).nodes_dmg);
                    G_k2 = G_k2(setdiff(1:length(ownerElement_interface),dmgNodes),:);
                end
                
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                if structure(k2).DOF(1) == 5
                    H = 0.5*structure(k2).geometry(3)*structure(k2).stAttach(2,k4);
                    G{i,k2} = horzcat(G{i,k2}, vertcat(blkdiag(H*G_k2,H*G_k2),horzcat(0*G_k2,0*G_k2)));
                end
                
                G_k1 = sparse(1:size(nodes_k1,1),nodes_k1,1,size(nodes_k1,1),...
                    size(structure(k1).nodeCoordinates,1));
                if isfield(structure(k1),'nodes_dmg')
                    dmgNodes = cell2mat(structure(k1).nodes_dmg);
                    G_k1 = G_k1(setdiff(1:length(ownerElement_interface),dmgNodes),:);
                end
                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                G{i,k1} = horzcat(G{i,k1}, sparse(size(G{i,k1},1),size(G{i,k1},2)));
                
            elseif strcmp(structure(k2).mesh_type,'honeycomb_core')&& ...
                    ~strcmp(structure(k1).mesh_type,'honeycomb_skin')
                if structure(k1).stAttach(2,k3) == -1
                    elementNodes_k1 = structure(k1).elementNodes(1 : size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3),1:nx_k1*ny_k1);
                    elementNodes_k2 = structure(k2).elementNodes(1+size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3)*(structure(k2).numElements(3)-1) : ...
                        size(structure(k2).elementNodes,1), 1+nx_k2*(ny_k2-1) : nx_k2*ny_k2);
                elseif structure(k1).stAttach(2,k3) == 1
                    elementNodes_k1 = structure(k1).elementNodes(1+size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3)*(structure(k1).numElements(3)-1) : ...
                        size(structure(k1).elementNodes,1), 1+nx_k1*ny_k1*...
                        (nz_k1-1) : nx_k1*ny_k1*nz_k1);
                    elementNodes_k2 = structure(k2).elementNodes(1:size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3), 1 : nx_k2);
                end
                           
                nodeCoordinates_k1 = structure(k1).nodeCoordinates;
                nodeCoordinates_k2 = structure(k2).nodeCoordinates;
                alpha = structure(k2).rotation_angle;
                
                
                nx_int = nx_k2; ny_int = 1;
                [b, ~, n] = unique(reshape(elementNodes_k2',[],1));
                nodeCoordinates_interface = nodeCoordinates_k2(b,:);
                elementNodes_interface = reshape(n,size(elementNodes_k2,2),[])';
                
                x_p = nodeCoordinates_interface(:,1);
                y_p = nodeCoordinates_interface(:,2);
                z_p = nodeCoordinates_interface(:,3);
                
                ownerElement_interface = zeros(length(b),1);
                for iNode_int = 1 : length(b)
                    ownerElement_interface(iNode_int,1) = ...
                        find(any(ismember(elementNodes_k2,b(iNode_int)),2),1,'first');
                end
                [Ksi,wi_x]=gll(nx_int);
                Ksi = repmat(Ksi,length(x_p),1);
                elementNodes_owner = elementNodes_interface(ownerElement_interface,:);
                
                Eps = 1e-8;
                x_0 = nodeCoordinates_k2(elementNodes_owner,1);
                x_0 = reshape(x_0,[],nx_int);
                y_0 = nodeCoordinates_k2(elementNodes_owner,2);
                y_0 = reshape(y_0,[],nx_int);
                                
                [~,point_no] = min(sqrt(bsxfun(@minus, x_p,x_0).^2+bsxfun(@minus, y_p,y_0).^2),[],2);
                x_0 = round(x_0(sub2ind(size(x_0),(1:length(point_no))',point_no))/Eps)*Eps;
                y_0 = round(y_0(sub2ind(size(y_0),(1:length(point_no))',point_no))/Eps)*Eps;

                ksi_p = Ksi(sub2ind(size(Ksi),ones(length(point_no),1),point_no));
                [Q_ksi] = Vandermonde_v2(gll(nx_int),nx_int);
                [Q_eta] = Vandermonde_v2(gll(1),1);
                
                nodes_order = reshape(elementNodes_owner',[],1);

                x_e = nodeCoordinates_k2(nodes_order,1);
                y_e = nodeCoordinates_k2(nodes_order,2);
                
                c_alpha = round(cos(alpha(ownerElement_interface,3))*1e6)*1e-6;
                s_alpha = round(sin(alpha(ownerElement_interface,3))*1e6)*1e-6;
                c_alpha = reshape(repmat(c_alpha,1,nx_int)',[],1);
                s_alpha = reshape(repmat(s_alpha,1,nx_int)',[],1);
                
                [shapeFunction_interface,naturalDerivativesX_P,naturalDerivativesY_P] = ...
                    shapeFunction_2D(Q_ksi,Q_eta,ksi_p,ones(size(ksi_p)),'a');
                J11 = naturalDerivativesX_P*(c_alpha.*x_e+s_alpha.*y_e);
                det_J = round(J11*1e6)*1e-6;
                
                w_p = wi_x;
                w_p = repmat(w_p,length(x_p),1);
                w_p = w_p(sub2ind(size(w_p),ones(length(point_no),1),point_no)).*det_J;
                
                [shapeFunction_k1,ownerElement_k1,~,~] = ...
                    spectral2meshgrid(structure(k1).DOF(2),structure(k1).DOF(4),nodeCoordinates_k1,...
                    elementNodes_k1,nodeCoordinates_interface);
               
                [r,c,v] = find(shapeFunction_k1'*shapeFunction_interface);
                c = mod(c,nx_int*ny_int); c(c==0) = nx_int*ny_int;
                
                g = sparse(r,c,v,nx_k1*ny_k1*length(nodeCoordinates_interface),nx_int*ny_int);
                g = bsxfun(@times,g,reshape(repmat(w_p',nx_k1*ny_k1,1),[],1));
                
                
                G_k1 = sparse(length(ownerElement_interface),size(nodeCoordinates_k1,1),0);
                G{i,k1} = sparse(nx_k1*ny_k1,nx_int*ny_int,0);
                for iOE_I = 1:length(ownerElement_interface)
                    clc; disp(i);disp([num2str(iOE_I) ' from ' num2str(length(ownerElement_interface))])
                    iSparse = repmat(elementNodes_interface(ownerElement_interface(iOE_I),:)',1,nx_k1*ny_k1);
                    jSparse = repmat(elementNodes_k1(ownerElement_k1(iOE_I),:),nx_int*ny_int,1);
                    G_k1 = G_k1 + sparse(iSparse,jSparse,(g((1:nx_k1*ny_k1)+(iOE_I-1)*nx_k1*ny_k1,:))',...
                        length(ownerElement_interface),size(nodeCoordinates_k1,1));
                end
                if isfield(structure(k2),'nodes_dmg')
                    dmgNodes = cell2mat(structure(k2).nodes_dmg);
                    G_k1 = G_k1(setdiff(1:length(ownerElement_interface),dmgNodes),:);
                else
                end
                
                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                if structure(k1).DOF(1) == 5
                    H = 0.5*structure(k1).geometry(3)*structure(k1).stAttach(2,k3);
                    G{i,k1} = horzcat(G{i,k1}, vertcat(blkdiag(H*G_k1,H*G_k1),horzcat(0*G_k1,0*G_k1)));
                end
                
                G_k2 = sparse(1:size(nodes_k2,1),nodes_k2,1,size(nodes_k2,1),...
                    size(structure(k2).nodeCoordinates,1));
                if isfield(structure(k2),'nodes_dmg')
                    dmgNodes = cell2mat(structure(k2).nodes_dmg);
                    G_k2 = G_k2(setdiff(1:length(ownerElement_interface),dmgNodes),:);
                else
                    dmgNodes = [];
                end
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                G{i,k2} = horzcat(G{i,k2}, sparse(size(G{i,k2},1),size(G{i,k2},2)));
                
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%                
            end
        else
            if structure(k1).stAttach(2,k3) == -1
                elementNodes_k1 = structure(k1).elementNodes(1 : size(structure(k1).elementNodes,1)/...
                    structure(k1).numElements(3),1:nx_k1*ny_k1);
                elementNodes_k2 = structure(k2).elementNodes(1+size(structure(k2).elementNodes,1)/...
                    structure(k2).numElements(3)*(structure(k2).numElements(3)-1) : ...
                    size(structure(k2).elementNodes,1), 1+nx_k2*ny_k2*...
                    (nz_k2-1) : nx_k2*ny_k2*nz_k2);
            elseif structure(k1).stAttach(2,k3) == 1
                elementNodes_k1 = structure(k1).elementNodes(1+size(structure(k1).elementNodes,1)/...
                    structure(k1).numElements(3)*(structure(k1).numElements(3)-1) : ...
                    size(structure(k1).elementNodes,1), 1+nx_k1*ny_k1*...
                    (nz_k1-1) : nx_k1*ny_k1*nz_k1);
                elementNodes_k2 = structure(k2).elementNodes(1:size(structure(k2).elementNodes,1)/...
                    structure(k2).numElements(3), 1 : nx_k2*ny_k2);
            end
                nodeCoordinates_k1 = structure(k1).nodeCoordinates;
                nodeCoordinates_k2 = structure(k2).nodeCoordinates;
                
                
                if structure(k1).stAttach(3,k3)
                    nx_int = nx_k1; ny_int = ny_k1;
                    [b, ~, n] = unique(reshape(elementNodes_k1',[],1));
                    nodeCoordinates_interface = nodeCoordinates_k1(b,:);
                    elementNodes_interface = reshape(n,size(elementNodes_k1,2),[])';
                    [shapeFunction_interface,ownerElement_interface,w_p,~] =...
                        spectral2meshgrid(nx_int,ny_int,nodeCoordinates_interface,elementNodes_interface, ...
                        nodeCoordinates_interface);
                elseif structure(k2).stAttach(3,k4)
                    nx_int = nx_k2; ny_int = ny_k2;
                    [b, ~, n] = unique(reshape(elementNodes_k2',[],1));
                    nodeCoordinates_interface = nodeCoordinates_k2(b,:);
                    elementNodes_interface = reshape(n,size(elementNodes_k2,2),[])';
                    [shapeFunction_interface,ownerElement_interface,w_p,~] =...
                        spectral2meshgrid(nx_int,ny_int,nodeCoordinates_interface,elementNodes_interface, ...
                        nodeCoordinates_interface);
                 end
                %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
               [shapeFunction_k1,ownerElement_k1,~,~] = ...
                    spectral2meshgrid(structure(k1).DOF(2),structure(k1).DOF(2),nodeCoordinates_k1,...
                    elementNodes_k1,nodeCoordinates_interface);
               
                [r,c,v] = find(shapeFunction_k1'*shapeFunction_interface);
                c = mod(c,nx_int*ny_int); c(c==0) = nx_int*ny_int;
                
                g = sparse(r,c,v,nx_k1*ny_k1*length(nodeCoordinates_interface),nx_int*ny_int);
                g = bsxfun(@times,g,reshape(repmat(w_p',nx_k1*ny_k1,1),[],1));
                
                
                G_k1 = sparse(max(max(elementNodes_interface)),size(nodeCoordinates_k1,1),0);
                G{i,k1} = sparse(nx_k1*ny_k1,nx_int*ny_int,0);
                for iOE_I = 1:length(ownerElement_interface)
                    clc; disp(i);disp([num2str(iOE_I) ' from ' num2str(length(ownerElement_interface))])
                    iSparse = repmat(elementNodes_interface(ownerElement_interface(iOE_I),:)',1,nx_k1*ny_k1);
                    jSparse = repmat(elementNodes_k1(ownerElement_k1(iOE_I),:),nx_int*ny_int,1);
                    G_k1 = G_k1 + sparse(iSparse,jSparse,(g((1:nx_k1*ny_k1)+(iOE_I-1)*nx_k1*ny_k1,:))',...
                        length(ownerElement_interface),size(nodeCoordinates_k1,1));
                end
                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                if structure(k1).DOF(1) == 5
                    H = 0.5*structure(k1).geometry(3)*structure(k1).stAttach(2,k3);
                    G{i,k1} = horzcat(G{i,k1}, vertcat(blkdiag(H*G_k1,H*G_k1),horzcat(0*G_k1,0*G_k1)));
                end
              
               %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                [shapeFunction_k2,ownerElement_k2,~,~] = ...
                    spectral2meshgrid(structure(k2).DOF(2),structure(k2).DOF(2),nodeCoordinates_k2,...
                    elementNodes_k2,nodeCoordinates_interface);
                [r,c,v] = find(shapeFunction_k2'*shapeFunction_interface);
                c = mod(c,nx_int*ny_int); c(c==0) = nx_int*ny_int;
                g = sparse(r,c,v,nx_k2*ny_k2*length(nodeCoordinates_interface),nx_int*ny_int);
                g = bsxfun(@times,g,reshape(repmat(w_p',nx_k2*ny_k2,1),[],1));
                G_k2 = sparse(max(max(elementNodes_interface)),size(nodeCoordinates_k2,1),0);
                G{i,k2} = sparse(nx_k2*ny_k2,nx_int*ny_int,0);
                for iOE_I = 1:length(ownerElement_interface)
                    clc; disp(i);disp([num2str(iOE_I) ' from ' num2str(length(ownerElement_interface))])
                    iSparse = repmat(elementNodes_interface(ownerElement_interface(iOE_I),:)',1,nx_k2*ny_k2);
                    jSparse = repmat(elementNodes_k2(ownerElement_k2(iOE_I),:),nx_int*ny_int,1);
                    G_k2 = G_k2 + sparse(iSparse,jSparse,(g((1:nx_k2*ny_k2)+(iOE_I-1)*nx_k2*ny_k2,:))',...
                        length(ownerElement_interface),size(nodeCoordinates_k2,1));
                end
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                if structure(k2).DOF(1) == 5
                    H = 0.5*structure(k2).geometry(3)*structure(k2).stAttach(2,k4);
                    G{i,k2} = horzcat(G{i,k2}, vertcat(blkdiag(H*G_k2,H*G_k2),horzcat(0*G_k2,0*G_k2)));
                end        
                
        end
    end
    for i = 1 : size(intLay,1)
        for j = setdiff(1:size(structure,2),intLay(i,:))
             firstNotEmptyCell = [find(~cellfun(@isempty,G(i,:)),1) ...
                 find(~cellfun(@isempty,G(:,j)),1)];
             G{i,j} = sparse([],[],[],size(G{i,firstNotEmptyCell(1)},1),...
                 size(G{firstNotEmptyCell(2),j},2),0);
        end
    end
    G = cell2mat(G);
    invMpC = blkdiag(invMpC{:});
    MmC = blkdiag(MmC{:});
    M = blkdiag(M{:});
    time = clock;
    clc;    disp(case_name)
    disp('G matrix....done');     
    disp(['d0 matrix.......' num2str(time(4)) ':' num2str(time(5)) ':' num2str(round(time(6)))])
    d0 = sparse(G*invMpC*G');
    invd0 = d0^(-1);
    clc;    disp('G matrix....done');    disp('d0 matrix...done')
    disp('id0 matrix........');    clc;    disp('G matrix....done');
    disp('d0 matrix...done');    disp('id0 matrix....done');
    disp('d matrix........')
    d1 = G*invMpC;
    disp('G matrix....done');    disp('d0 matrix...done')
    disp('ido matrix....done');    disp('d matrix....done') 
else
    invd0 =[];
    d1 = [];
    G = [];
    intLay = [];
    M = cell2mat(M);
    MmC = cell2mat(MmC);
    invMpC = cell2mat(invMpC);
end
