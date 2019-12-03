clc;
case_no = 100;

name_project = 'model_hc'; parentFolder = 'E:\model_hc';
%name_project='model_hc'; parentFolder='E:\model_hc'; 

fileName = [name_project,'_',num2str(case_no),'.mat'];
filePath = fullfile(parentFolder,'src','models',name_project,...
           'input','stiffness',fileName);
disp('Load structure from file....')
load(filePath, 'structure','GDof','excit_sh','ts','nr_exsh','N_f','parentFolder',...
    'name_project','case_name','output_result','noFrames');
disp('Load structure from file....done')

strNo = 1;


Lx = 0.95*structure(strNo).geometry(1);
Ly = 0.95*structure(strNo).geometry(2);

lambda = 15e-3;
nElementsX = ceil(Lx/(lambda/6));
nElementsY = ceil(Ly/(lambda/6));

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

[shapeFunction_strNo,ownerElement,~,expNodes] = spectral2meshgrid(1e-5,nrNodesX,nrNodesY,nodeCoordinates_strNo,...
    elementNodes_strNo,nodeCoordinates_interface);

x = nodeCoordinates_interface(:,1);
xx = reshape(x, nElementsX+1,nElementsY+1);
y = nodeCoordinates_interface(:,2);
yy = reshape(y, nElementsX+1,nElementsY+1);
DOF = structure(strNo).DOF(1);
I_L = reshape(structure(strNo).I_L,[],1);
I_G = reshape(structure(strNo).I_G,[],1);
Vz_P = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);

data.Vt = cell(noFrames,1);
data.Vt{1} = zeros(size(xx,1),size(yy,2));
data.time = linspace(0,N_f*ts-ts,noFrames);
maxV = zeros(noFrames,1);
%%
dirPath = dir(fullfile(parentFolder,'data','raw','num' ,name_project,...
          'output',num2str(case_no),'Vt'));
dirPath(1:2) = [];
filesNo = cell(size(dirPath,1),1);
[filesNo{:}] = deal(dirPath(:).name);
filesNo = cellfun(@(x) str2double(x(1:end-4)), filesNo, 'uni',0 );
[~,fileOrder] = sort(cell2mat(filesNo));
dirPath = dirPath(fileOrder);

aa = 1:size(dirPath,1);
for C1 = aa(ismember(aa,find(cellfun(@isempty, data.Vt))-1))
    clc; disp([num2str(C1), ' from ', ...
        num2str(max(aa(ismember(aa,find(cellfun(@isempty, data.Vt))-1))))])
    filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
          'output',num2str(case_no),'Vt', dirPath(C1).name);
    load(filePath,'Vt')
    Vt = mat2cell(Vt,cell2mat(GDof),1);   
    Vz = reshape(Vt{strNo},[],DOF);
    Vz = Vz(:,3);
    Vz_P(I_L) = Vz(I_G);
    Vz_P = reshape(Vz_P,nrNodesX*nrNodesY,[])';
    Vz_rec = Vz_P(ownerElement,:);
    Vz_rec = reshape(Vz_rec',[],1);
    Vz_rec = shapeFunction_strNo*Vz_rec;
    VV = reshape(Vz_rec, nElementsX+1,nElementsY+1);
    VV(expNodes) = 0;
    data.Vt{C1+1} = VV;
    maxV(C1+1) = max(max(abs(VV)));
end
cc = 5e-2*max(maxV);
WaveAnimation
%% PZT voltage
clc;
col_line = {'b','r','y','g','c','k','r'};
c_l = 0;
aa = 40.1e3;
for case_no = [100:105]
    c_l = c_l + 1;
    name_project = 'model_hc'; parentFolder = 'E:\model_hc';
    %name_project = 'miscellaneous'; parentFolder = 'E:\SEM_files';
    fileName = [name_project,'_',num2str(case_no),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,...
               'input','stiffness',fileName);
    disp('Load structure from file....')
    load(filePath, 'structure','excit_sh','ts','nr_exsh','N_f','parentFolder',...
        'name_project','case_name','output_result');
    disp('Load structure from file....done')
    pztNo = [7 7 7];
    fileName = 'Phi_electrode.mat';
    filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',num2str(case_no),'voltage',fileName);
    load(filePath, 'Phi_electrode');
    hold on
    timeVector = (0:N_f-1)*ts;
    if ~isempty(Phi_electrode(pztNo(1),:))
        plot(timeVector(:)*1e6,Phi_electrode(pztNo(1),:),col_line{c_l})
    end
end
%%
filePath = 'E:\SEM_files\Honeycomb\Output\Honeycomb_101_composite_PF2_pulse_signal_h_1mm_\structure_save.mat';
%filePath = 'E:\SEM_files\Honeycomb\Temp\Honeycomb_101_composite_PF2_pulse_signal_h_1mm_\structure_save.mat';
disp('Load structure from file....')
load(filePath, 'structure_load')
disp('Load structure from file....done')
plot(timeVector(1:aa),structure_load(5).Phi_electrode(1:aa),'g')
%aa_101=structure_load(5).Phi_electrode(1:aa);
% figure(2)
% plot(aa_0-aa_100,'b')
% hold on
% plot(aa_100-aa_101,'r')
%%
hold on
filePath = 'E:\SEM_files\Honeycomb\Temp\Honeycomb_101_composite_PF2_pulse_signal_h_1mm_\structure_save.mat';
disp('Load structure from file....')
load(filePath, 'structure_load')
disp('Load structure from file....done')
plot(structure_load(5).Phi_electrode(1:aa),'r')
%%
data.X = xx;
data.Y = yy;
filename = 'data.mat';
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
          'output',num2str(case_no),filename);
save(filePath,'data')


