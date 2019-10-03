%folder_preparation

if ~exist('name_project','var'); name_project='';end

folder_prep=['E:\SEM_files\',name_project];

if exist([folder_prep,'\Stiffness\'],'dir')==0
   mkdir([folder_prep,'\Stiffness\']);
end
if exist([folder_prep,'\Temp\',case_name,'\'],'dir')==0
   mkdir([folder_prep,'\Temp\',case_name,'\']);
end
if exist([folder_prep,'\Output\',case_name,'\'],'dir')==0
   mkdir([folder_prep,'\Output\',case_name,'\']);
end
for o_r=1:size(structure,2)
if strcmp(structure(1).output_result(2),'y')
 if exist([folder_prep,'\Output\',case_name,'\Um_',num2str(o_r),'\'],'dir')==0
    mkdir([folder_prep,'\Output\',case_name,'\Um_',num2str(o_r),'\']);   
 end
end

if strcmp(structure(1).output_result(3),'y')
 
 if exist([folder_prep,'\Output\',case_name,'\Vt_',num2str(o_r),'\'],'dir')==0
    mkdir([folder_prep,'\Output\',case_name,'\Vt_',num2str(o_r),'\']);   
 end
end
end