function [parentFolder, name_project] = folderpreparation(parentFolder,name_project,case_name)
% FOLDERPREPARATION   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: [output1,output2] = folderpreparation(input1,input2,input3) 
% 
% Inputs: 
%    input1 - Description, string, dimensions [m, n], Units: ms 
%    input2 - Description, logical, dimensions [m, n], Units: m 
%    input3 - Description, double, dimensions [m, n], Units: N 
% 
% Outputs: 
%    output1 - Description, integer, dimensions [m, n], Units: - 
%    output2 - Description, double, dimensions [m, n], Units: m/s^2 
% 
% Example: 
%    [output1,output2] = folderpreparation(input1,input2,input3) 
%    [output1,output2] = folderpreparation(input1,input2) 
%    [output1] = folderpreparation(input1,input2,input3) 
% 
% Other m-files required: none 
% Subfunctions: none 
% MAT-files required: none 
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2 
% 

% Author: Piotr Fiborek, M.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 

if isempty(parentFolder); parentFolder = 'E:\SEM_files';end
if isempty(name_project); name_project = 'miscellaneous';end
% input folders
folderPath = fullfile(parentFolder,'src','models',name_project,...
              'input','case',case_name);
if ~exist(folderPath,'dir'); mkdir(folderPath); end
folderPath = fullfile(parentFolder,'src','models',name_project,...
              'input','excitation',case_name);
if ~exist(folderPath,'dir'); mkdir(folderPath); end
folderPath = fullfile(parentFolder,'src','models',name_project,...
              'input','mesh',case_name);
if ~exist(folderPath,'dir'); mkdir(folderPath); end
folderPath = fullfile(parentFolder,'src','models',name_project,...
              'input','stiffness',case_name);
if ~exist(folderPath,'dir'); mkdir(folderPath); end
% output folders
folderPath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',case_name,'charge');
if ~exist(folderPath,'dir'); mkdir(folderPath); end
          
folderPath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',case_name,'Um');
if ~exist(folderPath,'dir'); mkdir(folderPath); end

folderPath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',case_name,'Vt');
if ~exist(folderPath,'dir'); mkdir(folderPath); end

folderPath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',case_name,'voltage');
if ~exist(folderPath,'dir'); mkdir(folderPath); end
%---------------------- END OF CODE---------------------- 
% ================ [folderpreparation.m] ================  
