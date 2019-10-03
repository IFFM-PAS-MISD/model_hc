function [elementNodes_dmg,nodeCoordinates_dmg,nodes_dmg]=...
    damage_input(structure_i,structure_att,ii)
% structure_i = structure(i);structure_att = structure(structure(i).stAttach(1,ii));
dmgGeometry = structure_i.geometry(1:end-1);
nodesShift_dmg = structure_i.dmgGeometry(end);
nodeCoordinates_st = round(structure_i.nodeCoordinates*1e8)*1e-8;
nodeCoordinates_att = round(structure_att.nodeCoordinates*1e8)*1e-8;
elementNodes_st = structure_i.elementNodes;
n = structure_i.DOF(2);
nzeta = structure_i.DOF(3);    
switch structure_i.DOF(1)
    case 5
        nzeta_lay = 1:n^2;
        nn = 2*n;
        h = structure_i.stAttach(2,ii)*structure_i.geometry(3);
    case 6
        if structure_i.stAttach(2,ii)==-1
        nzeta_lay = 1:n;
        elseif structure_i.stAttach(2,ii)==1
        nzeta_lay = n^2-n+1:n^2*nzeta;
        end
        nn = 2;
        h = 0;
    case 3
        if structure_i.stAttach(2,ii)==-1
            nzeta_lay = 1:n^2;
        elseif structure_i.stAttach(2,ii)==1
            nzeta_lay = n^2*(nzeta-1)+1:n^2*nzeta;
        end
        nn = 2*n;
        h = 0;
end
switch structure_att.DOF(1)
    case 5
        h2 = -structure_i.stAttach(2,ii)*structure_att.geometry(3);
    case 6    
        h2 = 0;
    case 3
        h2 = 0;
end
nodes_dmg = cell(size(find(~cellfun(@isempty,structure_i.dmgShape)),1),1);
if isempty(cell2mat(nodes_dmg));shiftZ_dmg = [];end;
    scale = 1e6;
    tol = 1e-8;
    dmgNum = find(~cellfun(@isempty,structure_i.dmgShape)&~cellfun(@isempty,structure_att.dmgShape));
    nodes_dmg = cell(length(dmgNum),1);
    interfaceElements = cell(length(dmgNum),1);
    for kk = 1:length(dmgNum)
        Lx_dmg = dmgGeometry{dmgNum(kk)}(1);
        Ly_dmg = dmgGeometry{dmgNum(kk)}(2);
        shiftX_dmg = dmgGeometry{dmgNum(kk)}(3);
        shiftY_dmg = dmgGeometry{dmgNum(kk)}(4);
        shiftZ_dmg = dmgGeometry{dmgNum(kk)}(5);
        dmgShape = structure_i.dmgShape{dmgNum(kk)};
        cc = round(cos(alpha*pi/180)*1e6)*1e-6;
        ss = round(sin(alpha*pi/180)*1e6)*1e-6;
        if strcmp(dmgShape,'circ')
            nodes_dmg{kk} = find(round((((nodeCoordinates_st(:,1)-shiftX_dmg)*cc+...
                (nodeCoordinates_st(:,2)-shiftY_dmg)*ss).^2/(Lx_dmg/2)^2+...
                ((nodeCoordinates_st(:,1)-shiftX_dmg)*ss-(nodeCoordinates_st(:,2)-shiftY_dmg)*cc).^2/...
                (Ly_dmg/2)^2)*scale)/scale<=1&abs(nodeCoordinates_st(:,3)+h/2-shiftZ_dmg)<tol);
        elseif strcmp(dmgShape,'rect')
            nodes_dmg{kk} = find(...
                abs(round(((nodeCoordinates_st(:,1)-shiftX_dmg)*cc+...
                (nodeCoordinates_st(:,2)-shiftY_dmg)*ss)*scale)/scale)<=Lx_dmg/2&...
                abs(round(((nodeCoordinates_st(:,2)-shiftY_dmg)*cc-...
                (nodeCoordinates_st(:,1)-shiftX_dmg)*ss)*scale)/scale)<=Ly_dmg/2&...
                abs(nodeCoordinates_st(:,3)+h/2-shiftZ_dmg)<tol);
        elseif strcmp(dmgShape,'polygon')
%          plot(nodeCoordinates_st(:,1),nodeCoordinates_st(:,2),'b+')
%          axis equal
%          hold on
            shiftZ_dmg = dmgGeometry{kk}(1,6);
            polyCoord = dmgGeometry{kk}(:,1:5);
            nodes_dmg{kk} = zeros(size(nodeCoordinates_st,1),2);
            for pC = 1:size(polyCoord,1)
                x1 = polyCoord(pC,1);x2=polyCoord(pC,3);
                y1 = polyCoord(pC,2);y2=polyCoord(pC,4);
                xx = nodeCoordinates_st(:,1)>=x1&nodeCoordinates_st(:,1)<=x2;
                if dmgGeometry{kk}(pC,5)==1
                    yy = nodeCoordinates_st(xx,2)>=...
                        y1+(y2-y1)/(x2-x1)*(nodeCoordinates_st(xx,1)-x1);
                        xx(xx) = yy;
                    nodes_dmg{kk}(:,1) = nodes_dmg{kk}(:,1)|xx;
%                 plot(nodeCoordinates_st(find(nodes_dmg{kk}(:,1)),1),...
%                     nodeCoordinates_st(find(nodes_dmg{kk}(:,1)),2),'ro')
%                 pause()
                elseif dmgGeometry{kk}(pC,5)==-1
                    yy = nodeCoordinates_st(xx,2)<=...
                        y1+(y2-y1)/(x2-x1)*(nodeCoordinates_st(xx,1)-x1);
                    xx(xx) = yy;
                    nodes_dmg{kk}(:,2) = nodes_dmg{kk}(:,2)|xx;
%                 plot(nodeCoordinates_st(find(nodes_dmg{kk}(:,2)),1),...
%                     nodeCoordinates_st(find(nodes_dmg{kk}(:,2)),2),'yo')
%                 pause()
                end
            end
            nodes_dmg{kk} = find(nodes_dmg{kk}(:,1)&nodes_dmg{kk}(:,2));
        end
        ee = 0;
        for e = 1:size(elementNodes_st,1)
            if size(find(ismember(elementNodes_st(e,nzeta_lay),nodes_dmg{kk})==0),2)<=nn;
                ee = ee+1;
                interfaceElements{kk}(ee,:) = e;
            end
        end
    end
    interfaceElements = unique(cell2mat(interfaceElements));
    uniqueCoord = unique(nodeCoordinates_st(:,3));
    if isfield(structure_i,'dmgShape')&&~isempty(structure_i.dmgShape)&&~isempty(shiftZ_dmg)
        if shiftZ_dmg==intersect(uniqueCoord+h/2,unique(nodeCoordinates_att(:,3))+h2/2)
            if  any(interfaceElements~=0)
                n_dmg = unique(cell2mat(nodes_dmg)); 
                nodes_dmg = zeros(size(nodeCoordinates_st,1),1);
                nodes_dmg(n_dmg) = 1;
                elementNodes_dmg = elementNodes_st;
                nodeCoordinates_dmg = nodeCoordinates_st;
            end
        elseif any(shiftZ_dmg==uniqueCoord(2:end-1))
            nodeRng = find(shiftZ_dmg==uniqueCoord(2:end-1))*n^2+1:...
                (find(shiftZ_dmg==uniqueCoord(2:end-1))+1)*n^2;
            nodes_dmg = unique(elementNodes_st(interfaceElements,nodeRng));
            elementNodes_dmg = elementNodes_st(interfaceElements,nodeRng);
            for row_n = 1:size(elementNodes_dmg,1)    
                for col_n = 1:size(elementNodes_dmg,2) 
                    elementNodes_dmg(row_n,col_n) = find(elementNodes_dmg(row_n,col_n)==...
                        nodes_dmg);
                end
            end
            elementNodes_dmg = elementNodes_dmg+length(structure_i.nodeCoordinates);
            elementNodes_st(interfaceElements,nzeta_lay)=elementNodes_dmg;
            elementNodes_dmg = elementNodes_st;
            nodeCoordinates_dmg = structure_i.nodeCoordinates(nodes_dmg,:);
            nodeCoordinates_dmg(:,3) = nodeCoordinates_dmg(:,3)+nodesShift_dmg;
            nodeCoordinates_dmg = [structure_i.nodeCoordinates;nodeCoordinates_dmg];
            nodes_dmg = zeros(size(nodeCoordinates_st,1),1);
        else
            nodes_dmg = zeros(size(nodeCoordinates_st,1),1);
            elementNodes_dmg = elementNodes_st;
            nodeCoordinates_dmg = nodeCoordinates_st;    
        end
    else
        nodes_dmg = zeros(size(nodeCoordinates_st,1),1);
        elementNodes_dmg = elementNodes_st;
        nodeCoordinates_dmg = nodeCoordinates_st;
    end
end
% plot(nodeCoordinates_st(:,1),nodeCoordinates_st(:,2),'b+')
% hold on
% plot(nodeCoordinates_st(nodes_dmg{3},1),nodeCoordinates_st(nodes_dmg{3},2),'r+')
% axis equal
% nodes_dmg=cell2mat(nodes_dmg); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%