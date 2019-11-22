function delFiles(case_no, name_project, parentFolder)
if nargin == 0 || nargin > 3, help(mfilename); return; end
if nargin == 1
    name_project = 'miscellaneous';
    parentFolder = 'E:\SEM_files';
end
if nargin == 2 
    parentFolder = 'E:\SEM_files';
end

for i = 1:length(case_no)
    % Specify the path of file.
    myFile = [name_project,'_',num2str(case_no(i)),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,'input','stiffness',myFile);
    % Check to make sure that file actually exists and delete it. 
    if exist(filePath,'file')
        delete(filePath);
    end

    myFile = ['duration_cal_',num2str(case_no(i))];
    filePath = fullfile(parentFolder,'data','raw','num',name_project,'output',myFile);
    % Check to make sure that file actually exists and delete it. 
    if exist(filePath,'file')
        delete(filePath)
    end
    myFolder = fullfile(parentFolder,'data','raw','num',name_project,'output',num2str(case_no(i)));
    % Check to make sure that file actually exists and delete it. 
    if exist(myFolder,'dir')
        rmdir(myFolder,'s')
    end
end