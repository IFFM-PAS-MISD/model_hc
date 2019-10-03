clc;
case_no = 11;

name_project = 'model_hc';
parentFolder = 'E:\SEM_files';

fileName = [name_project,'_',num2str(case_no),'.mat'];
filePath = fullfile(parentFolder,'src','models',name_project,...
           'input','stiffness',fileName);
disp('Load structure from file....')
load(filePath, 'structure','excit_sh','ts','nr_exsh','N_f','parentFolder',...
    'name_project','case_name','output_result');
disp('Load structure from file....done')

strNo = 1;

nElementsX = 270;
nElementsY = 180;
Lx = 0.95*structure(strNo).geometry(1);
Ly = 0.95*structure(strNo).geometry(2);

shift_x = structure(strNo).geometry(4);
shift_y = structure(strNo).geometry(5);
shift_z = structure(strNo).geometry(6);

nrNodesX = structure(strNo).DOF(2);
nrNodesY = structure(strNo).DOF(2);
nrNodesZ = structure(strNo).DOF(3);

[nodeCoordinates_interface, ~] = ...
    rectangularMesh(Lx,Ly,nElementsX,nElementsY,shift_x,shift_y,shift_z);
nodeCoordinates_strNo = structure(strNo).nodeCoordinates;
elementNodes_strNo = structure(strNo).elementNodes;
nrElements = size(elementNodes_strNo,1);

[shapeFunction_strNo,ownerElement,~,expNodes] = spectral2meshgrid(nrNodesX,nrNodesY,nodeCoordinates_strNo,...
    elementNodes_strNo,nodeCoordinates_interface);

x = nodeCoordinates_interface(:,1);
xx = reshape(x, nElementsX+1,nElementsY+1);
y = nodeCoordinates_interface(:,2);
yy = reshape(y, nElementsX+1,nElementsY+1);
DOF = structure(strNo).DOF(1);
I_L = reshape(structure(strNo).I_L,[],1);
I_G = reshape(structure(strNo).I_G,[],1);
Vz_P = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
%%
step = floor(N_f/512);
iSteps = step; 
filename = [num2str(iSteps),'.mat'];
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
          'output',num2str(case_no),'Vt',filename);
      figure(1)
surf(xx,yy,zeros(size(xx,1),size(yy,2)))
shading interp;view(2);axis square;axis equal;
C1 = 1;
aa = 1.0;
data.Vt = cell(512,1);
data.Vt{1} = zeros(size(xx));
data.time = linspace(0,N_f*ts-ts,512);
while exist(filePath,'file')
    disp(iSteps)
    C1 = C1 +1 ;
    load(filePath,'Vt')
    Vz = reshape(Vt{strNo},[],DOF);
    Vz = Vz(:,3);
    Vz_P(I_L) = Vz(I_G);
    Vz_P = reshape(Vz_P,nrNodesX*nrNodesY,[])';
    Vz_rec = Vz_P(ownerElement,:);
    Vz_rec = reshape(Vz_rec',[],1);
    Vz_rec = shapeFunction_strNo*Vz_rec;
    VV = reshape(Vz_rec, nElementsX+1,nElementsY+1);
    VV(expNodes) = 0;
    data.Vt{C1} = VV;
   figure(1)
    surf(xx,yy,VV)
    shading interp;view(2);axis square;axis equal;
    caxis([-aa*max(max(Vz)) aa*max(max(Vz))]);
    iSteps = iSteps+step;
    filename = [num2str(iSteps),'.mat'];
    filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
          'output',num2str(case_no),'Vt',filename);
    %pause
    clc
end
data.Vt{C1} = [];
data.X = xx;
data.Y = yy;
%%
filename = 'data.mat';
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
          'output',num2str(case_no),filename);
save(filePath,'data')


