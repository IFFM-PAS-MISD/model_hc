% nodes_generator
function [nodeCoordinates,elementNodes,thicknessElementNo] = ...
    nodes_generator(structure_prev,structure_i,k)

%k=i;structure_i=structure(i);structure_prev=structure(structure(i).stAttach(1,1));


Lz = structure_i.geometry(3);
nodeCoordinates_st = structure_prev.nodeCoordinates;
elementNodes_st = structure_prev.elementNodes;
%thicknessElementNo=structure_i.thicknessElementNo;

if structure_i.DOF(1) == 5
    shiftZ = structure_i.geometry(6);
elseif structure_i.DOF(1) == 3
    shiftZ = round((structure_i.geometry(6)-structure_i.geometry(3)/2)*1e8)*1e-8; 
end

n = structure_i.DOF(2);
nzeta_prev = structure_prev.DOF(3);
n_zeta = structure_i.DOF(3);
zeta = structure_i.zeta;

I = find(structure_prev.stAttach(1,:)==k,1);
interfaceElements = find(structure_prev.interfaceElements(:,I));
nodes_st = unique(elementNodes_st(interfaceElements,1+n^2*(nzeta_prev-1):...
    n^2*nzeta_prev));
nodeCoordinates = zeros(length(nodes_st)*(structure_i.numElements(3)*(n_zeta-1)+1),3);
nodeCoordinates(1:length(nodes_st),1:2) = nodeCoordinates_st(nodes_st,1:2);
elementNodes_int = zeros(size(interfaceElements,1),n^2);
for e = 1:size(interfaceElements,1)
    ee = interfaceElements(e,1);
    [~,ii] = ismember(elementNodes_st(ee,1+n^2*(nzeta_prev-1):n^2*nzeta_prev),nodes_st);
    elementNodes_int(e,:) = ii;
end
elementNodes = cell(structure_i.numElements(3),1);
elementNodes{1} = zeros(size(interfaceElements,1),n^2*n_zeta);
elementNodes{1}(:,1:n^2) = elementNodes_int;

for i = 2:n_zeta
    max_Nodes = max(max(elementNodes{1}));
    elementNodes{1}(:,1+n^2*(i-1):n^2*i) = elementNodes_int+max_Nodes;
    nodeCoordinates(1+length(nodes_st)*(i-1):length(nodes_st)*i,1:2) = nodeCoordinates_st(nodes_st,1:2);    
    nodeCoordinates(1+length(nodes_st)*(i-1):length(nodes_st)*i,3) = Lz/structure_i.numElements(3)/2+...
        zeta(i)*Lz/structure_i.numElements(3)/2;
end
thicknessElementNo = cell(structure_i.numElements(3),1);
thicknessElementNo{1} = ones(size(elementNodes{1},1),1);
nodes_leyer = elementNodes{1};
for ii = 2:structure_i.numElements(3)
    max_Nodes = max(max(elementNodes));
    elementNodes_el = zeros(size(nodes_leyer));
    elementNodes_el(:,1:n^2) = elementNodes(1+size(nodes_leyer)*...
        (ii-2):size(nodes_leyer)*(ii-1),1+n^2*(n_zeta-1):end);
    elementNodes_el(:,1+n^2:end) = nodes_leyer(:,1:size(nodes_leyer,2)-n^2)+max_Nodes;
    elementNodes{ii} = elementNodes_el;
    nodeCoordinates(1+size(nodes_st,1)*((ii-1)*(n_zeta-1)+1):...
        size(nodes_st,1)*(ii*(n_zeta-1)+1),1:2) = ...
        nodeCoordinates(1+size(nodes_st,1)*((ii-2)*(n_zeta-1)+1):...
        size(nodes_st,1)*((ii-1)*(n_zeta-1)+1),1:2);
    nodeCoordinates(1+size(nodes_st,1)*((ii-1)*(n_zeta-1)+1):...
        size(nodes_st,1)*(ii*(n_zeta-1)+1),3) = ...
        nodeCoordinates(1+size(nodes_st,1)*((ii-2)*(n_zeta-1)+1):...
        size(nodes_st,1)*((ii-1)*(n_zeta-1)+1),3)+...
        Lz/structure_i.numElements(3);
    thicknessElementNo{ii} = ii*ones(size(elementNodes_el,1),1);
end
elementNodes = cell2mat(elementNodes);
thicknessElementNo = cell2mat(thicknessElementNo);
nodeCoordinates(:,3) = nodeCoordinates(:,3)+shiftZ;