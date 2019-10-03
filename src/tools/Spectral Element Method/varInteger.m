% varInteger

function Var_Int=varInteger(var_int,structure_i)

%var_int=a15;


a_f=structure_i.properties(8);
a_w=structure_i.properties(9);
g_f=structure_i.properties(12); 
g_w=structure_i.properties(13); 
n_zeta=structure_i.DOF(3);
RVE_str=struct('geometry',[(a_f+g_f)/2 (a_w+g_w)/2 0 (a_f+g_f)/4 (a_w+g_w)/4 0],...
    'numElements',[5,5],'mesh_type','rect','inputfile','');
[RVE_str.ksi,RVE_str.wix]=gll(structure_i.DOF(2));
[RVE_str.eta,RVE_str.wiy]=gll(structure_i.DOF(2));
[RVE_str.zeta,RVE_str.wiz]=gll(structure_i.DOF(3));
[RVE_str.DOF]=structure_i.DOF;

[RVE_str.numberElements,RVE_str.nodeCoordinates,RVE_str.elementNodes]= ...
    mesh_generator(RVE_str);
[RVE_str.elementNodes,RVE_str.nodeCoordinates]=...
    quad2spectral(RVE_str.elementNodes,RVE_str.nodeCoordinates,RVE_str,RVE_str.DOF(2)-1);
RVE_str.nodeCoordinates=round(RVE_str.nodeCoordinates*1e12)*1e-12;

numberElements=RVE_str.numberElements;
nodeCoordinates=RVE_str.nodeCoordinates;
elementNodes=RVE_str.elementNodes;

Var_Int=0;

n=RVE_str.DOF(2);
ksi=RVE_str.ksi;wi_x=RVE_str.wix;
eta=RVE_str.eta;wi_y=RVE_str.wiy;
zeta=RVE_str.zeta;wi_z=RVE_str.wiz;
[gaussLocations2D,gaussWeights2D]=gaussQuadrature(ksi,eta,zeta,wi_x,wi_y,wi_z,5);
for e=1:numberElements;
    indice=elementNodes(e,1:n^2);
   for q=1:n^2
    GaussPoint=gaussLocations2D(q,:);
    xi=GaussPoint(1);
    eta=GaussPoint(2);
    zeta=[];
    [~,naturalDerivatives]=shape_function(xi,eta,zeta,n,1);
    [JacobianMatrix,~,~]=...
    Jacobian(nodeCoordinates(indice,1:2),naturalDerivatives(:,1:2));
    Var_Int=Var_Int+var_int(indice(q))*gaussWeights2D(q)*det(JacobianMatrix);
   end
   
   
end

Var_Int=4/((a_f+g_f)*(a_w+g_w))*Var_Int;







