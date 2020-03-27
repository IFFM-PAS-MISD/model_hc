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
folder_name = fullfile(parentFolder,'src','models',name_project);    
addpath(genpath(pwd),genpath(folder_name)),lastwarn('')

%%case_no=112;
newCase = case_no;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1 : length(case_no)
    fileName = ['fulltimeFile_',num2str(case_no(i)),'.mat'];
    filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',num2str(case_no(i)),fileName);
    if ~exist(filePath,'file')
        clearvars -except i case_no newCase name_project parentFolder; clc;
        
        folderpreparation(parentFolder,name_project,case_no(i));
        myFolder = fullfile(parentFolder,'src','models',name_project,'input','case');
        myFile = [name_project,'_',num2str(case_no(i)),'.m'];
        filePath = fullfile(myFolder,myFile);
        
        run(filePath)
        case_name = [name_project,'_',num2str(case_no(i)),'_',structure(1).material,'_',...
        freq_range,'_h_',num2str(structure(1).geometry(3)*1e3),'mm'];
    
        if  ~exist('noFrames','var'); noFrames = 2^9; end
        fileName = [name_project,'_',num2str(case_no(i)),'.mat'];
        filePath = fullfile(parentFolder,'src','models',name_project,'input','stiffness',fileName);
        if ~exist(filePath,'file')
            disp(case_name)
            structure = structure_preparation(structure,dmgStruct,name_project,parentFolder);
            freq_file = ['frequency_',name_project];
            run(freq_file)
            [excit_sh,N,nr_exsh] = excitationshape(freq_range,f_0,T,ts,N_c,1,'no',f_1,w_1);
            if  ~exist('N_f','var'); N_f = N; end
            %%%%%%%%%
            d_lambda;
            %%%%%%%%%
            disp(case_name)
            disp('Save structure to file....')
            save(filePath,'structure','GDof','d0','G','d1','M','invMpC','MmC','intLay',...
                'excit_sh','ts','nr_exsh','N_f','f_0','f_1','parentFolder','name_project',...
                'case_name','output_result','noFrames','-v7.3')
            disp('Save structure to file....done')
        end
    else
       newCase = setdiff(newCase, case_no(i)); 
    end
end
cmplCases = newCase;
%%

for i = 1 : length(newCase)
    clearvars -except i newCase cmplCases name_project parentFolder
        
    fileName = [name_project,'_',num2str(newCase(i)),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,...
              'input','stiffness',fileName);
    disp('Load structure from file....')
          load(filePath, 'structure','GDof','d0','G','d1','M','invMpC','MmC','intLay','excit_sh',...
              'ts','nr_exsh','N_f','f_0','f_1','parentFolder','name_project','case_name',...
              'output_result','noFrames');
    disp('Load structure from file....done')
     
    fileName = ['meantimeFile_',num2str(newCase(i)),'.mat'];
    filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',...
        num2str(newCase(i)),fileName);
    
    if exist(filePath,'file')
        load(filePath,'Um','Ut','q','Phi_electrode','iSteps','case_name','durationtime')
    else
        q = zeros(size(structure,2),N_f); Phi_electrode = zeros(size(structure,2),N_f);
        iSteps = 0; durationtime = 0;
       
        Um = cellfun(@(x) zeros(x,1),GDof,'uni',0);
        Ut = cellfun(@(x) zeros(x,1),GDof,'uni',0);
    end
    
    cmplCases = equationofmotion(structure,Um,Ut,q,Phi_electrode,N_f,G,d0,d1,M,MmC,invMpC,...
        excit_sh,ts,nr_exsh,parentFolder,name_project,case_name,durationtime,iSteps,output_result,...
        intLay,newCase(i),cmplCases,GDof,noFrames);
    
    
    
  %% 
  
end
switch  length(newCase)
    case 0
        disp('No new cases!')
    case 1
        disp(['New case: ' num2str(newCase)])
    otherwise
        disp(['New cases: ' num2str(newCase)])
end
switch  length(cmplCases)
    case 0
        disp('No completed cases!')
    case 1
        disp(['Completed case: ' num2str(cmplCases)])
    otherwise
        disp(['Completed cases: ' num2str(cmplCases)])
end
%------------------------ END OF CODE------------------------ 

% ================ [spectralelementmethod.m] ================  
