function spectralelementmethod(case_no, name_project, parentFolder)
% SPECTRALELEMENTMETHOD   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: spectralelementmethod(case_no, name_project, parentFolder) 
% 
% Inputs: 
%    case_no - number of case, int, Units: [] 
%    name_project - name of the project, str, Units: [] 
%    parentFolder - name of the parent folder, str, Units: [] 
% 
% Outputs: 
%    save files in: parentFolder\data\raw\num
%     
% 
% Example: 
%    spectralelementmethod(1,'Project','E:\') 
%    spectralelementmethod(1,'Project')   
%    spectralelementmethod(1) 
% 
% Other m-files required: none 
% Subfunctions: none 
% MAT-files required: none 
% See also: 
% 

% Author: Piotr Fiborek, M.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 
if nargin == 0 || nargin > 3, help(mfilename); return; end
    if nargin == 1
        name_project = 'miscellaneous';
        parentFolder = 'E:\SEM_files';
    end
    if nargin == 2 
        parentFolder = 'E:\SEM_files';
    end
folder_name = fullfile(parentFolder,name_project,'src','models');    
addpath(genpath(pwd),genpath(folder_name)),lastwarn('')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for inputNumber = case_no
    clearvars -except inputNumber case_no name_project parentFolder; clc;
    
    folderpreparation(parentFolder,name_project,inputNumber);
    folder_dst = fullfile(parentFolder,'src','models',name_project,'input','case');
    fileName = [name_project,'_',num2str(inputNumber),'.m'];
    folder_src = fullfile(pwd,'input','case',fileName);
    filePath = fullfile(folder_dst,fileName);
    
    if exist(folder_src,'file')
        if exist(filePath,'file')
            renameFileNo = 1;
            renameFile = fullfile(folder_dst,[name_project,'_',...
                num2str(inputNumber),'_',num2str(renameFileNo),'.m']); 
            while exist(renameFile,'file')
                renameFileNo = renameFileNo + 1;    
                renameFile = fullfile(folder_dst,[name_project,'_',...
                    num2str(inputNumber),'_',num2str(renameFileNo),'.m']);
            end
            movefile(filePath, renameFile)
        end
        movefile(folder_src, filePath)
    end
    
    run(filePath)
    case_name = [name_project,'_',num2str(inputNumber),'_',structure(1).material,'_',...
    freq_range,'_h_',num2str(structure(1).geometry(3)*1e3),'mm'];
    
    
    fileName = [name_project,'_',num2str(inputNumber),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,'input','stiffness',fileName);
    if ~exist(filePath,'file')
         
       structure = structure_preparation(structure,dmgStruct);
       [excit_sh,ts,nr_exsh] = excitationshape(freq_range,f_0,f_1,T,N,N_c,w1,1,'no');
       %%%%%%%%%
       d_lambda;
       %%%%%%%%%
       disp('Save structure to file....')
       save(filePath,'structure','invd0','G','d1','M','invMpC','MmC','intLay','excit_sh','ts','nr_exsh',...
           'N_f','f_0','f_1','parentFolder','name_project','case_name','output_result')
       disp('Save structure to file....done')
    end
end
%%
for inputNumber = case_no
    clearvars -except inputNumber case_no name_project parentFolder
        
    fileName = [name_project,'_',num2str(inputNumber),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,...
              'input','stiffness',fileName);
    disp('Load structure from file....')
          load(filePath, 'structure','invd0','G','d1','M','invMpC','MmC','intLay','excit_sh','ts','nr_exsh',...
           'N_f','f_0','f_1','parentFolder','name_project','case_name','output_result');
    disp('Load structure from file....done')
      
        
    nrElements = field2cell(structure,'numberElements');
    Dof = field2cell(structure,'DOF');
    nrNodesX =cellfun(@(x) x(2), Dof, 'UniformOutput',false);
    nrNodesZ =cellfun(@(x) x(3), Dof, 'UniformOutput',false);
    nrNodesY =cellfun(@(x) x(4), Dof, 'UniformOutput',false);
    Dof =cellfun(@(x) x(1), Dof, 'UniformOutput',false);
    
    GDof = field2cell(structure,'GDof');
    Um =cellfun(@(x) zeros(x,1), GDof, 'UniformOutput',false);
    Ut =cellfun(@(x) zeros(x,1), GDof, 'UniformOutput',false);
    I_G = field2cell(structure,'I_G');
    I_L = field2cell(structure,'I_L');
    
        
    Jacob_P11inv = field2cell(structure,'Jacob_P11inv');
    Jacob_P12inv = field2cell(structure,'Jacob_P12inv');
    Jacob_P21inv = field2cell(structure,'Jacob_P21inv');
    Jacob_P22inv = field2cell(structure,'Jacob_P22inv');
    Jacob_P13inv = field2cell(structure,'Jacob_P13inv');
    Jacob_P23inv = field2cell(structure,'Jacob_P23inv');
    Jacob_P31inv = field2cell(structure,'Jacob_P31inv');
    Jacob_P32inv = field2cell(structure,'Jacob_P32inv');
    Jacob_P33inv = field2cell(structure,'Jacob_P33inv');
    shapeFunction_P = field2cell(structure,'shapeFunction_P');
    naturalDerivativesX_P = field2cell(structure,'naturalDerivativesX_P');
    naturalDerivativesY_P = field2cell(structure,'naturalDerivativesY_P');
    naturalDerivativesZ_P = field2cell(structure,'naturalDerivativesZ_P');
    
    numberNodes = field2cell(structure,'numberNodes');
    w_P = field2cell(structure,'w_P');    
    
    c_xpx = field2cell(structure,'c_xpx');
    c_xpy = field2cell(structure,'c_xpy');c_xpz = field2cell(structure,'c_xpz');
    c_ypx = field2cell(structure,'c_ypx');c_ypy = field2cell(structure,'c_ypy');
    c_ypz = field2cell(structure,'c_ypz');c_zpx = field2cell(structure,'c_zpx');
    c_zpy = field2cell(structure,'c_zpy');c_zpz = field2cell(structure,'c_zpz');
    
    a11 = field2cell(structure,'a11');    a12 = field2cell(structure,'a12');
    a16 = field2cell(structure,'a16');    a22 = field2cell(structure,'a22');
    a26 = field2cell(structure,'a26');    a66 = field2cell(structure,'a66');
    b11 = field2cell(structure,'b11');    b12 = field2cell(structure,'b12');
    b16 = field2cell(structure,'b16');    b22 = field2cell(structure,'b22');
    b26 = field2cell(structure,'b26');    b66 = field2cell(structure,'b66');
    d11 = field2cell(structure,'d11');    d12 = field2cell(structure,'d12');
    d16 = field2cell(structure,'d16');    d22 = field2cell(structure,'d22');
    d26 = field2cell(structure,'d26');    d66 = field2cell(structure,'d66');
    a44_2d = field2cell(structure,'a44_2d'); a45_2d = field2cell(structure,'a45_2d');
    a55_2d = field2cell(structure,'a55_2d');
    
    c11 = field2cell(structure,'c11');    c12 = field2cell(structure,'c12');
    c13 = field2cell(structure,'c13');    c14 = field2cell(structure,'c14');
    c15 = field2cell(structure,'c15');    c16 = field2cell(structure,'c16');
    c21 = field2cell(structure,'c21');    c22 = field2cell(structure,'c22');
    c23 = field2cell(structure,'c23');    c24 = field2cell(structure,'c24');
    c25 = field2cell(structure,'c25');    c26 = field2cell(structure,'c26');
    c31 = field2cell(structure,'c31');    c32 = field2cell(structure,'c32');
    c33 = field2cell(structure,'c33');    c34 = field2cell(structure,'c34');
    c35 = field2cell(structure,'c35');    c36 = field2cell(structure,'c36');
    c41 = field2cell(structure,'c41');    c42 = field2cell(structure,'c42');
    c43 = field2cell(structure,'c43');    c44 = field2cell(structure,'c44');
    c45 = field2cell(structure,'c45');    c46 = field2cell(structure,'c46');
    c51 = field2cell(structure,'c51');    c52 = field2cell(structure,'c52');
    c53 = field2cell(structure,'c53');    c54 = field2cell(structure,'c54');
    c55 = field2cell(structure,'c55');    c56 = field2cell(structure,'c56');
    c61 = field2cell(structure,'c61');    c62 = field2cell(structure,'c62');
    c63 = field2cell(structure,'c63');    c64 = field2cell(structure,'c64');
    c65 = field2cell(structure,'c65');    c66 = field2cell(structure,'c66');
    rotation_angle = field2cell(structure,'rotation_angle');
    
    q = cell(length(structure),1);
    Phi = field2cell(structure,'Phi');
    Phi_electrode = cell(length(structure),1);
    piezo_type = cell(length(structure),1);
    Vt = cell(length(structure),1);
    for iStruct = 1:length(structure)
        if ~isempty(structure(iStruct).piezo_type)
            q{iStruct}=zeros(1,N_f);
            Phi_electrode{iStruct} = zeros(1,N_f);
            piezo_type{iStruct} = structure(iStruct).piezo_type;
        end
        
            Vt{iStruct} = zeros(structure(iStruct).GDof,1);
        
    end
    
    
    Force = field2cell(structure,'Force');
    Pn = field2cell(structure,'Pn');
    voltageNode = field2cell(structure,'voltageNode');
    groundNode = field2cell(structure,'groundNode');
    
    stiffness_V = field2cell(structure,'stiffness_V');
    activePhi = field2cell(structure,'activePhi');
    prescribedPhi = field2cell(structure,'prescribedPhi');
    stiffness_uV = field2cell(structure,'stiffness_uV');
    inv_stiffness_V = cellfun(@(x,y) x(y,y)^(-1),stiffness_V,activePhi,'uni',0);
    iSteps = 0; durationtime = 0;
    
    fileName = ['meantimeFile_',num2str(inputNumber),'.mat'];
    filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',num2str(inputNumber),fileName);
    if exist(filePath,'file')
        load(filePath,'Um','Ut','q','Phi_electrode','iSteps','case_name','durationtime')
    end
    fileName = ['fulltimeFile_',num2str(inputNumber),'.mat'];
    filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',num2str(inputNumber),fileName);
    if ~exist(filePath,'file')
        duration_cal = equationofmotion(N_f,Um,Ut,G,invd0,d1,M,MmC,invMpC,excit_sh,ts,nr_exsh,q,Phi_electrode,...
            parentFolder,name_project,case_name,Dof,GDof,nrNodesX,nrNodesZ,nrNodesY,Jacob_P11inv,Jacob_P12inv,...
            Jacob_P21inv,Jacob_P22inv,Jacob_P13inv,Jacob_P23inv,Jacob_P31inv,Jacob_P32inv,Jacob_P33inv,...
            numberNodes,w_P,c_xpx,c_xpy,c_xpz,c_ypx,c_ypy,c_ypz,c_zpx,c_zpy,c_zpz,a11,a12,a16,a22,a26,a66,b11,...
            b12,b16,b22,b26,b66,d11,d12,d16,d22,d26,d66,a44_2d,a45_2d,a55_2d,c11,c12,c13,c14,c15,c16,c21,c22,...
            c23,c24,c25,c26,c31,c32,c33,c34,c35,c36,c41,c42,c43,c44,c45,c46,c51,c52,c53,c54,c55,c56,c61,c62,...
            c63,c64,c65,c66,rotation_angle,shapeFunction_P,naturalDerivativesX_P,naturalDerivativesY_P,...
            naturalDerivativesZ_P,nrElements,I_L,I_G, iSteps,Force,Pn,voltageNode,groundNode,stiffness_V,...
            inv_stiffness_V,Phi,activePhi,prescribedPhi,stiffness_uV,durationtime,output_result,intLay,...
            inputNumber);
    end
  %% 
  file_name = ['duration_cal_',num2str(inputNumber),'.mat']; 
  patch_file = fullfile('E:','SEM_files','data','raw','num',name_project,'output',file_name);
  save(patch_file,'duration_cal');
end

%------------------------ END OF CODE------------------------ 

% ================ [spectralelementmethod.m] ================  
