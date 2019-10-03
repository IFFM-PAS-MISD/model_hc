function [elementNodes_dmg,nodeCoordinates_dmg,rotation_angle,dmgNodes] = ...
    damage_nodes(dmgStrct,structure_i)
% structure_i = structure(ii); dmgStrct = dmgStruct(i); 
rotation_angle = structure_i.rotation_angle;
dmgGeometry = dmgStrct.geometry;
dmgLocalization = dmgStrct.localization;
dmgShape = dmgStrct.shape;
dmgType = dmgStrct.type;
dmgNodesShift = dmgGeometry(4);
dmgAlpha = dmgLocalization(4);
dmgPrpReduction = dmgStrct.dmgPrpReduction;
nodeCoordinates_st = structure_i.nodeCoordinates;
nodes = (1:size(nodeCoordinates_st,1))';
elementNodes_st = structure_i.elementNodes;
n_x = structure_i.DOF(2);
if length(structure_i.DOF) == 4
    n_y = structure_i.DOF(4);
else
    n_y = n_x;
end
tol = 1e-8;
switch dmgType
    case 'local'
        h = abs(nodeCoordinates_st(:,3))-(dmgLocalization(3)+dmgGeometry(3)/2) <= tol;
        a = dmgGeometry(1)/2;
        b = dmgGeometry(2)/2;
        Lz = dmgGeometry(3);
        x0 = dmgLocalization(1);
        y0 = dmgLocalization(2);
        cc = round(cos(dmgAlpha*pi/180)*1e6)*1e-6;
        ss = round(sin(dmgAlpha*pi/180)*1e6)*1e-6;
        k1 = 0;
        dmgNodes = cell(length(unique(nodeCoordinates_st(h,3))),1);
        for k = unique(nodeCoordinates_st(h,3))
            k1 = k1 + 1;
            h_k = abs(nodeCoordinates_st(:,3))-k <= tol;
            hNodes = nodes(h_k);
            X = nodeCoordinates_st(hNodes,1);
            Y = nodeCoordinates_st(hNodes,2);
            switch dmgShape
                case 'circ'
                    A = a^2*ss^2 + b^2*cc^2;
                    B = 2*(b^2-a^2)*ss*cc;
                    C = a^2*cc^2 + b^2*ss^2;
                    D = -2*A*x0 - B*y0;
                    E = -B*x0 - 2*C*y0;
                    F = A*x0^2 + B*x0*y0 + C*y0^2 - a^2*b^2;
                    dmgNodes{k1} = hNodes(A*X.^2+B*X.*Y+C*Y.^2+D*X+E*Y+F<=0);
                case 'rect'
                    dmgNodes{k1} = hNodes(abs((X-x0)*cc+(Y-y0)*ss)<=a & ...
                        abs(((nodeCoordinates_st(:,2)-y0)*cc-(X-x0)*ss))<=b);
                case 'poly'
                    xv = [dmgGeometry(:,1); dmgGeometry(1,1)];
                    yv = [dmgGeometry(:,2); dmgGeometry(1,2)];
                    dmgNodes{k1} = hNodes(inpolygon(X,Y,xv,yv));
            end
            
        end
        dmgNodes = cell2mat(dmgNodes);
        if dmgGeometry(3) == 0
            BB = reshape(sum(repmat(reshape(elementNodes_st',[],1),1,length(dmgNodes)) == ...
               repmat(dmgNodes',numel(elementNodes_st),1),2),fliplr(size(elementNodes_st)));
           
            if dmgPrpReduction == 100
                element_dmg = find(sum(BB,1)==n_x*n_y);
                if ~isempty(element_dmg)
                    empNodes = elementNodes_st(element_dmg,:);
                    empNodes = sort(empNodes(~ismember(empNodes,elementNodes_st(1:end~=element_dmg,:))));
                    aa = repmat(reshape(elementNodes_st',[],1),1,length(empNodes)) >= ...
                        repmat(empNodes,numel(elementNodes_st),1);
                    elementNodes_st = reshape(reshape(elementNodes_st',[],1)-sum(aa,2),...
                        size(elementNodes_st,2),[])';
                    elementNodes_st(element_dmg,:) = [];
                    rotation_angle(element_dmg,:) = [];
                    nodeCoordinates_st(empNodes,:) = [];
                end
            else
                element_dmg = find(sum(BB,1));
                while ~isempty(element_dmg)
                    ee = elementNodes_st(element_dmg(1),logical(BB(:,element_dmg(1))));
                    eeA = elementNodes_st(element_dmg(1),:);
                    [~,r] = max(sum(ismember(elementNodes_st(element_dmg(2:end)',:),ee),2));
                    rr = elementNodes_st(element_dmg(r+1),logical(BB(:,element_dmg(r+1))));
                    rrA = elementNodes_st(element_dmg(r+1),:);
               
                    if any(unique(nodeCoordinates_st(eeA,3)) < unique(nodeCoordinates_st(rrA,3)))
                        nodeCoordinates_st(ee,3) = nodeCoordinates_st(ee,3) - dmgNodesShift/2;
                        elementNodes_st(element_dmg(r+1),logical(BB(:,element_dmg(r+1)))) = ...
                            (1:length(element_dmg(r+1))) + length(nodeCoordinates_st);
                        nodeCoordinates_st = [nodeCoordinates_st; ...
                            [nodeCoordinates_st(rr,1:2), nodeCoordinates_st(rr,3) + dmgNodesShift/2]];
                    elseif any(unique(nodeCoordinates_st(eeA,3)) > unique(nodeCoordinates_st(rrA,3)))
                        nodeCoordinates_st(rr,3) = nodeCoordinates_st(rr,3) - dmgNodesShift/2;
                        elementNodes_st(element_dmg(1),logical(BB(:,element_dmg(1)))) = ...
                            (1:length(element_dmg(1))) + length(nodeCoordinates_st);
                        nodeCoordinates_st = [nodeCoordinates_st; ...
                            [nodeCoordinates_st(aa,1:2), nodeCoordinates_st(aa,3) + dmgNodesShift/2]];
                    end
                    element_dmg(1) = [];
                    element_dmg(r+1) = [];
                end
           end
           
        end
    case 'global'
        a = dmgGeometry(1)/2;
        b = dmgGeometry(2)/2;
        
        
        x0 = dmgLocalization(1);
        y0 = dmgLocalization(2);
        z0 = dmgLocalization(3);
        cc = round(cos(dmgAlpha*pi/180)*1e6)*1e-6;
        ss = round(sin(dmgAlpha*pi/180)*1e6)*1e-6;
        unqH = unique(nodeCoordinates_st(:,3));
        [~,h] = min(abs(unqH-z0));
        hNodes = nodes(nodeCoordinates_st(:,3)==unqH(h));
        X = nodeCoordinates_st(hNodes,1);
        Y = nodeCoordinates_st(hNodes,2);
        switch dmgShape
            case 'circ'
                A = a^2*ss^2 + b^2*cc^2;
                B = 2*(b^2-a^2)*ss*cc;
                C = a^2*cc^2 + b^2*ss^2;
                D = -2*A*x0-B*y0;
                E = -B*x0-2*C*y0;
                F = A*x0^2+B*x0*y0+C*y0^2-a^2*b^2;
                dmgNodes = hNodes(A*X.^2+B*X.*Y+C*Y.^2+D*X+E*Y+F<tol);
            case 'rect'
                dmgNodes = hNodes(abs((X-x0)*cc+(Y-y0)*ss)<=a & ...
                abs(((Y-y0)*cc-(X-x0)*ss))<=b);
            case 'poly'
                xv = [dmgGeometry(:,1); dmgGeometry(1,1)];
                yv = [dmgGeometry(:,2); dmgGeometry(1,2)];
                dmgNodes = hNodes(inpolygon(X,Y,xv,yv));
        end
end
elementNodes_dmg = elementNodes_st;
nodeCoordinates_dmg = nodeCoordinates_st;