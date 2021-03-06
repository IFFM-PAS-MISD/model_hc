clc; disp('iMpC matrix...')
Eps = 1e-5;

MpC = cell(size(structure,2),1); M = cell(size(structure,2),1);
invMpC = cell(size(structure,2),1); MmC = cell(size(structure,2),1);
for i = 1:size(structure,2)
    iM = structure(i).Mass;
    iD = structure(i).Damp;
    M{i} = sparse((1:size(iM,1))',(1:size(iM,1))',iM);
    MpC{i} = sparse((1:size(iM,1))',(1:size(iM,1))',(iM + ts*iD/2));
    invMpC{i} = sparse((1:size(iM,1))',(1:size(iM,1))',1./((iM + ts*iD/2)));
    MmC{i} = sparse((1:size(iM,1))',(1:size(iM,1))',(iM - ts*iD/2));
end
clc;
disp(case_name)
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
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            if strcmp(structure(k1).mesh_type,'honeycomb_core') && ...
                    strcmp(structure(k2).mesh_type,'honeycomb_skin')
                if ~isempty(structure(k1).nodes_dmg) && ~isempty(structure(k2).nodes_dmg)
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
                    H = structure(k2).stAttach(2,k4)*0.5*structure(k2).geometry(3);
                    G{i,k2} = horzcat(G{i,k2}, vertcat(blkdiag(H*G_k2,H*G_k2),horzcat(0*G_k2,0*G_k2)));
                end
                G{i,k2} = structure(k2).stAttach(2,k4) * G{i,k2};
                G_k1 = structure(k1).stAttach(2,k3)*sparse(1:size(nodes_k1,1),jj(:,1),1,size(nodes_k1,1),...
                    size(structure(k1).nodeCoordinates,1));

                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                G{i,k1} = horzcat(G{i,k1}, sparse(size(G{i,k1},1),size(G{i,k1},2)));
            %%%%%%%%%%%%%%%%%%%%%%%    
            elseif strcmp(structure(k2).mesh_type,'honeycomb_core')&& ...
                    strcmp(structure(k1).mesh_type,'honeycomb_skin')
                if ~isempty(structure(k1).nodes_dmg) && ~isempty(structure(k2).nodes_dmg)
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
                    [~,bb] = min(sqrt((nodeCoordinates_k1(:,1)-iNodeCoor_k2(1)).^2+...
                        (nodeCoordinates_k1(:,2)-iNodeCoor_k2(2)).^2));
                    jj{iNode} = [bb, nodes_k2(iNode)];
                end
                jj = cell2mat(jj);
                G_k1 = sparse(1:size(nodes_k2,1),jj(:,1),1,size(nodes_k2,1),...
                    size(structure(k1).nodeCoordinates,1));

                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                if structure(k1).DOF(1) == 5
                    H = structure(k1).stAttach(2,k3)*0.5*structure(k1).geometry(3);
                    G{i,k1} = horzcat(G{i,k1}, vertcat(blkdiag(H*G_k1,H*G_k1),horzcat(0*G_k1,0*G_k1)));
                end
                G{i,k1} = structure(k1).stAttach(2,k3) * G{i,k1};
                G_k2 = structure(k2).stAttach(2,k4)*sparse(1:size(nodes_k2,1),jj(:,2),1,size(nodes_k2,1),...
                    size(structure(k2).nodeCoordinates,1));
 
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                G{i,k2} = horzcat(G{i,k2}, sparse(size(G{i,k2},1),size(G{i,k2},2)));
            %%%%%%%%%%%%%%%%%%%%%%%
            elseif strcmp(structure(k1).mesh_type,'honeycomb_core') && ...
                    ~strcmp(structure(k2).mesh_type,'honeycomb_skin')
                if structure(k2).stAttach(2,k4) == -1
                    elementNodes_k2 = structure(k2).elementNodes(1 : size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3),1:nx_k2*ny_k2);
                    elementNodes_k1 = structure(k1).elementNodes(1+size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3)*(structure(k1).numElements(3)-1) : ...
                        size(structure(k1).elementNodes,1), 1+nx_k1*(ny_k1-1) : nx_k1*ny_k1);
                    if ~isempty(structure(k1).nodes_dmg) && ~isempty(structure(k2).nodes_dmg)
                        dmgNodes = cell2mat(structure(k1).nodes_dmg) - ...
                            (size(structure(k1).nodeCoordinates,1)*(ny_k1-1)/ny_k1);
                    else
                        dmgNodes = [];
                    end
                elseif structure(k2).stAttach(2,k4) == 1
                    elementNodes_k2 = structure(k2).elementNodes(1+size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3)*(structure(k2).numElements(3)-1) : ...
                        size(structure(k2).elementNodes,1), 1+nx_k2*ny_k2*...
                        (nz_k12-1) : nx_k2*ny_k2*nz_k2);
                    elementNodes_k1 = structure(k1).elementNodes(1:size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3), 1 : nx_k1);
                    if ~isempty(structure(k1).nodes_dmg) && ~isempty(structure(k2).nodes_dmg)
                        dmgNodes = cell2mat(structure(k1).nodes_dmg);
                    else
                        dmgNodes = [];
                    end
                end
                           
                nodeCoordinates_k1 = structure(k1).nodeCoordinates;
                nodeCoordinates_k2 = structure(k2).nodeCoordinates;
                if size(structure(k1).stAttach,1)<4
                    nx_int = nx_k1; ny_int = 1;
                else
                    nx_int = structure(k1).stAttach(4,k3);
                    ny_int = 1;
                end
                [b, ~, n] = unique(reshape((elementNodes_k1(:,[1 nx_k1]))',[],1));
                elementNodes_interface = reshape(n,size(elementNodes_k1(:,[1 nx_k1]),2),[])';
                nodeCoordinates_interface = nodeCoordinates_k1(b,:);
                [elementNodes_interface,nodeCoordinates_interface] = ...
                    linear2spectral(elementNodes_interface,nodeCoordinates_interface,nx_int-1);
               
                [shapeFunction_k2,ownerElement_k2,~,expNodes_k2] = ...
                    spectral2meshgrid(Eps,nx_k2,ny_k2,nodeCoordinates_k2,...
                    elementNodes_k2,nodeCoordinates_interface,[],case_name);

                iSparse = repmat((1:length(ownerElement_k2))',1,nx_k2*ny_k2);
                jSparse = bsxfun(@plus,repmat((1:nx_k2*ny_k2:nx_k2*ny_k2*length(ownerElement_k2))',...
                    1,nx_k2*ny_k2), (0:nx_k2*ny_k2-1));
                
                
                vSparse = full(shapeFunction_k2(sub2ind(size(shapeFunction_k2),iSparse,jSparse)));
                iSparse = repmat((1:length(ownerElement_k2))',1,nx_k2*ny_k2);
                jSparse = elementNodes_k2(ownerElement_k2,:);
                
                G_k2 = sparse(iSparse,jSparse,vSparse,...
                    length(ownerElement_k2),size(nodeCoordinates_k2,1));
                                                
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                if structure(k2).DOF(1) == 5
                    H = structure(k2).stAttach(2,k4)*0.5*structure(k2).geometry(3);
                    G{i,k2} = horzcat(G{i,k2}, vertcat(blkdiag(H*G_k2,H*G_k2),horzcat(0*G_k2,0*G_k2)));
                end
                G{i,k2} = structure(k2).stAttach(2,k4) * G{i,k2};
                
                [shapeFunction_k1,ownerElement_k1,~,~] = ...
                    spectral2meshgrid(Eps,nx_k1,1,nodeCoordinates_k1,...
                    elementNodes_k1,nodeCoordinates_interface,structure(k1).rotation_angle,...
                    case_name);
                ownerElement_k1(expNodes_k2) = [];
                iSparse = repmat((1:length(ownerElement_k1))',1,nx_k1*1);
                jSparse = bsxfun(@plus,repmat((1:nx_k1*1:nx_k1*1*length(ownerElement_k1))',...
                    1,nx_k1*1), (0:nx_k1*1-1));
                
                
                vSparse = full(shapeFunction_k1(sub2ind(size(shapeFunction_k1),iSparse,jSparse)));
                iSparse = repmat((1:length(ownerElement_k1))',1,nx_k1*1);
                jSparse = elementNodes_k1(ownerElement_k1,:);
                
                G_k1 = structure(k1).stAttach(2,k3)*sparse(iSparse,jSparse,vSparse,...
                    length(ownerElement_k1),size(nodeCoordinates_k1,1));
                                
                G_k1 = G_k1(setdiff(1:length(ownerElement_k1),dmgNodes),:);
               
                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                G{i,k1} = horzcat(G{i,k1}, sparse(size(G{i,k1},1),size(G{i,k1},2)));
            %%%%%%%%%%%%%%%%%%%%%%%    
            elseif strcmp(structure(k2).mesh_type,'honeycomb_core')&& ...
                    ~strcmp(structure(k1).mesh_type,'honeycomb_skin')
                if structure(k1).stAttach(2,k3) == -1
                    elementNodes_k1 = structure(k1).elementNodes(1 : size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3),1:nx_k1*ny_k1);
                    elementNodes_k2 = structure(k2).elementNodes(1+size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3)*(structure(k2).numElements(3)-1) : ...
                        size(structure(k2).elementNodes,1), 1+nx_k2*(ny_k2-1) : nx_k2*ny_k2);
                    if ~isempty(structure(k1).nodes_dmg) && ~isempty(structure(k2).nodes_dmg)
                        dmgNodes = cell2mat(structure(k2).nodes_dmg) - ...
                            (size(structure(k2).nodeCoordinates,1)*(ny_k2-1)/ny_k2);
                    else
                        dmgNodes = [];
                    end
                elseif structure(k1).stAttach(2,k3) == 1
                    elementNodes_k1 = structure(k1).elementNodes(1+size(structure(k1).elementNodes,1)/...
                        structure(k1).numElements(3)*(structure(k1).numElements(3)-1) : ...
                        size(structure(k1).elementNodes,1), 1+nx_k1*ny_k1*...
                        (nz_k1-1) : nx_k1*ny_k1*nz_k1);
                    elementNodes_k2 = structure(k2).elementNodes(1:size(structure(k2).elementNodes,1)/...
                        structure(k2).numElements(3), 1 : nx_k2);
                    if ~isempty(structure(k1).nodes_dmg) && ~isempty(structure(k2).nodes_dmg)
                        dmgNodes = cell2mat(structure(k2).nodes_dmg);
                    else
                        dmgNodes = [];
                    end
                end
                           
                nodeCoordinates_k1 = structure(k1).nodeCoordinates;
                nodeCoordinates_k2 = structure(k2).nodeCoordinates;
                             
                
                if size(structure(k2).stAttach,1)<4
                    nx_int = nx_k2; ny_int = 1;
                else
                    nx_int = structure(k2).stAttach(4,k4);
                    ny_int = 1;
                end
                
                [b, ~, n] = unique(reshape((elementNodes_k2(:,[1 nx_k2]))',[],1));
                elementNodes_interface = reshape(n,size(elementNodes_k2(:,[1 nx_k2]),2),[])';
         
                nodeCoordinates_interface = nodeCoordinates_k2(b,:);
                [elementNodes_interface,nodeCoordinates_interface] = ...
                    linear2spectral(elementNodes_interface,nodeCoordinates_interface,nx_int-1);
                
                [shapeFunction_k1,ownerElement_k1,~,expNodes_k1] = ...
                    spectral2meshgrid(Eps,nx_k1,ny_k1,nodeCoordinates_k1,...
                    elementNodes_k1,nodeCoordinates_interface,[],case_name);
               
                iSparse = repmat((1:length(ownerElement_k1))',1,nx_k1*ny_k1);
                jSparse = bsxfun(@plus,repmat((1:nx_k1*ny_k1:nx_k1*ny_k1*length(ownerElement_k1))',...
                    1,nx_k1*ny_k1), (0:nx_k1*ny_k1-1));
                
                
                vSparse = full(shapeFunction_k1(sub2ind(size(shapeFunction_k1),iSparse,jSparse)));
                iSparse = repmat((1:length(ownerElement_k1))',1,nx_k1*ny_k1);
                jSparse = elementNodes_k1(ownerElement_k1,:);
                
                G_k1 = sparse(iSparse,jSparse,vSparse,...
                    length(ownerElement_k1),size(nodeCoordinates_k1,1));
                               
                
                G_k1 = G_k1(setdiff(1:length(ownerElement_k1),dmgNodes),:);
                G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
                if structure(k1).DOF(1) == 5
                    H = structure(k1).stAttach(2,k3)*0.5*structure(k1).geometry(3);
                    G{i,k1} = horzcat(G{i,k1}, vertcat(blkdiag(H*G_k1,H*G_k1),horzcat(0*G_k1,0*G_k1)));
                end
                G{i,k1} = structure(k1).stAttach(2,k3) * G{i,k1};
                
               [shapeFunction_k2,ownerElement_k2,~,~] = ...
                    spectral2meshgrid(Eps,nx_k2,1,nodeCoordinates_k2,...
                    elementNodes_k2,nodeCoordinates_interface,structure(k2).rotation_angle,...
                    case_name);

                ownerElement_k2(expNodes_k1) = [];
                iSparse = repmat((1:length(ownerElement_k2))',1,nx_k2*1);
                jSparse = bsxfun(@plus,repmat((1:nx_k2*1:nx_k2*1*length(ownerElement_k2))',...
                    1,nx_k2*1), (0:nx_k2*1-1));
                
                
                vSparse = full(shapeFunction_k2(sub2ind(size(shapeFunction_k2),iSparse,jSparse)));
                iSparse = repmat((1:length(ownerElement_k2))',1,nx_k2*1);
                jSparse = elementNodes_k2(ownerElement_k2,:);
                
                G_k2 = sparse(iSparse,jSparse,vSparse,...
                    length(ownerElement_k2),size(nodeCoordinates_k2,1));
                              
                G_k2 = structure(k2).stAttach(2,k4)*G_k2;
                G_k2 = G_k2(setdiff(1:length(ownerElement_k2),dmgNodes),:);
                G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
                G{i,k2} = horzcat(G{i,k2}, sparse(size(G{i,k2},1),size(G{i,k2},2)));
            end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
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
                if size(structure(k1).stAttach,1)<4
                    nx_int = nx_k1; ny_int = ny_k1;
                else
                    nx_int = structure(k1).stAttach(4,k3);
                    ny_int = structure(k1).stAttach(5,k3);
                end
                
                [b, ~, n] = unique(reshape((elementNodes_k1(:,[1 nx_k1 nx_k1*ny_k1 1+nx_k1*(ny_k1-1)]))',...
                    [],1));
                elementNodes_interface = reshape(n,size(elementNodes_k1(:,[1 nx_k1 nx_k1*ny_k1 1+nx_k1*(ny_k1-1)]),...
                    2),[])';
                nodeCoordinates_interface = nodeCoordinates_k1(b,:);
                [elementNodes_interface,nodeCoordinates_interface,~] = ...
                    quad2spectral(elementNodes_interface,nodeCoordinates_interface,nx_int-1,ny_int-1);
                
                [~,ownerElement_interface,~,~] =...
                    spectral2meshgrid(Eps,nx_int,ny_int,nodeCoordinates_interface,elementNodes_interface, ...
                    nodeCoordinates_interface,[],case_name);
            elseif structure(k2).stAttach(3,k4)
                if size(structure(k2).stAttach,1)<4
                    nx_int = nx_k2; ny_int = ny_k2;
                else
                    nx_int = structure(k2).stAttach(4,k4);
                    ny_int = structure(k2).stAttach(5,k4);
                end
                [b, ~, n] = unique(reshape((elementNodes_k2(:,[1 nx_k2 nx_k2*ny_k2 1+nx_k2*(ny_k2-1)]))',...
                    [],1));
                elementNodes_interface = reshape(n,size(elementNodes_k2(:,[1 nx_k2 nx_k2*ny_k2 1+nx_k2*(ny_k2-1)]),...
                    2),[])';
                nodeCoordinates_interface = nodeCoordinates_k2(b,:);
                [elementNodes_interface,nodeCoordinates_interface,~] = ...
                    quad2spectral(elementNodes_interface,nodeCoordinates_interface,nx_int-1,ny_int-1);
                
                [~,ownerElement_interface,~,~] =...
                    spectral2meshgrid(Eps,nx_int,ny_int,nodeCoordinates_interface,elementNodes_interface, ...
                    nodeCoordinates_interface,[],case_name);
            end
             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             [shapeFunction_k1,ownerElement_k1,~,~] = ...
                spectral2meshgrid(Eps,structure(k1).DOF(2),structure(k1).DOF(2),nodeCoordinates_k1,...
                elementNodes_k1,nodeCoordinates_interface,[],case_name);
               
             iSparse = repmat((1:length(ownerElement_interface))',1,nx_k1*ny_k1);
             jSparse = bsxfun(@plus,repmat((1:nx_k1*ny_k1:nx_k1*ny_k1*length(ownerElement_interface))',...
                1,nx_k1*ny_k1), (0:nx_k1*ny_k1-1));
                
                
             vSparse = full(shapeFunction_k1(sub2ind(size(shapeFunction_k1),iSparse,jSparse)));
             iSparse = repmat((1:length(ownerElement_k1))',1,nx_k1*ny_k1);
             jSparse = elementNodes_k1(ownerElement_k1,:);
                
             G_k1 = round((sparse(iSparse,jSparse,vSparse,...
                    length(ownerElement_interface),size(nodeCoordinates_k1,1)))*1e12)*1e-12;
             %G_k1 = G_k1(setdiff(1:length(ownerElement_interface),dmgNodes),:);
             
             G{i,k1} = blkdiag(G_k1,G_k1,G_k1);
             if structure(k1).DOF(1) == 5
                H = structure(k1).stAttach(2,k3)*0.5*structure(k1).geometry(3);
                G{i,k1} = horzcat(G{i,k1}, vertcat(blkdiag(H*G_k1,H*G_k1),horzcat(0*G_k1,0*G_k1)));
             end
              G{i,k1} = structure(k1).stAttach(2,k3) * G{i,k1};
              %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             [shapeFunction_k2,ownerElement_k2,~,~] = ...
                spectral2meshgrid(Eps,structure(k2).DOF(2),structure(k2).DOF(2),nodeCoordinates_k2,...
                elementNodes_k2,nodeCoordinates_interface,[],case_name);
             
             iSparse = repmat((1:length(ownerElement_interface))',1,nx_k2*ny_k2);
             jSparse = bsxfun(@plus,repmat((1:nx_k2*ny_k2:nx_k2*ny_k2*length(ownerElement_interface))',...
                1,nx_k2*ny_k2), (0:nx_k2*ny_k2-1));
                
                
             vSparse = full(shapeFunction_k2(sub2ind(size(shapeFunction_k2),iSparse,jSparse)));
             iSparse = repmat((1:length(ownerElement_k2))',1,nx_k2*ny_k2);
             jSparse = elementNodes_k2(ownerElement_k2,:);
                
             G_k2 = round((sparse(iSparse,jSparse,vSparse,...
                length(ownerElement_interface),size(nodeCoordinates_k2,1)))*1e12)*1e-12;
  
                
             %G_k2 = G_k2(setdiff(1:length(ownerElement_interface),dmgNodes),:);
             G{i,k2} = blkdiag(G_k2,G_k2,G_k2);
             if structure(k2).DOF(1) == 5
                H = structure(k2).stAttach(2,k4)*0.5*structure(k2).geometry(3);
                G{i,k2} = horzcat(G{i,k2}, vertcat(blkdiag(H*G_k2,H*G_k2),horzcat(0*G_k2,0*G_k2)));
             end        
                G{i,k2} = structure(k2).stAttach(2,k4) * G{i,k2};
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
    time = clock;
    GDof = cell(size(structure,2),1);
    [GDof{:}] = deal(structure(:).GDof);
    invMpC = blkdiag(invMpC{:});
    M = blkdiag(M{:});
    MmC = blkdiag(MmC{:});
    clc;    disp(case_name)
    disp('G matrix....done');     
    disp(['d0 matrix.......' num2str(time(4)) ':' num2str(time(5)) ':' num2str(round(time(6)))])
    d0 = sparse(G*invMpC*G');
    %invd0 = d0^(-1);
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
    invMpC = cell2mat(invMpC);
end
fields = {'material', 'fiber_type', 'properties','damp_coef','typeProp','stShape','damage_file',...
       'BC','mesh_type','inputfile','ksi','wix','eta','wiy','zeta','wiz',...
       'thicknessElementNo','interfaceElements','nodes_dmg','XYZ_P','e_p','epsS','Mass',...
       'Damp'};
structure = rmfield(structure,fields);