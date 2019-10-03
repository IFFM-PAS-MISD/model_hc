clc
case_no = 104;
col_lin = '-b';  
name_project = 'smart2019';
parentFolder = 'E:\SEM_files';

fileName = [name_project,'_',num2str(case_no),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,...
              'input','stiffness',fileName);
    disp('Load structure from file....')
          load(filePath, 'structure','d0','G','d1','M','invMpC','MmC','intLay',...
              'excit_sh','ts','nr_exsh','N_f','parentFolder','name_project',...
              'case_name','output_result');
    disp('Load structure from file....done')


filename ='Phi_electrode.mat';
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output', num2str(case_no), 'voltage',filename);
load(filePath,'Phi_electrode')
hold on
plot(Phi_electrode{end}/1,col_lin)
%%

clc
case_no = 113;
col_lin = '-r';  
name_project = 'smart2019';
parentFolder = 'E:\SEM_files';

fileName = [name_project,'_',num2str(case_no),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,...
              'input','stiffness',fileName);
    disp('Load structure from file....')
          load(filePath, 'structure','d0','G','d1','M','invMpC','MmC','intLay',...
              'excit_sh','ts','nr_exsh','N_f','parentFolder','name_project',...
              'case_name','output_result');
    disp('Load structure from file....done')


filename ='Phi_electrode.mat';
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output', num2str(case_no), 'voltage',filename);
load(filePath,'Phi_electrode')

plot(Phi_electrode{end}/1,col_lin)
hold on
%%


tic
G_k1 = sparse(max(max(elementNodes_interface)),size(nodeCoordinates_k1,1),0);
                G{i,k1} = sparse(nx_k1*ny_k1,nx_int*ny_int,0);
                unqOEI = unique(ownerElement_interface);
                for iOE_I = 1:length(unqOEI)
                    
                    clc; disp([num2str(iOE_I) ' from ' num2str(length(unqOEI))])
                    iSparse = reshape(repmat(reshape(elementNodes_interface(ownerElement_interface(...
                        ownerElement_interface==unqOEI(iOE_I)),:)',1,[]),nx_k1*ny_k1,1),[],1);
                    jSparse = reshape(repmat((reshape(elementNodes_k1(ownerElement_k1(...
                        ownerElement_interface==unqOEI(iOE_I)),:)',1,[]))',1,nx_k1*ny_k1),[],1);
                    ig = reshape(repmat((ownerElement_interface==unqOEI(iOE_I))',nx_k1*ny_k1,1),[],1);
                    G_k1 = G_k1 + sparse(iSparse,jSparse,reshape(g(ig,:)',[],1),length(ownerElement_interface),...
                        size(nodeCoordinates_k1,1));
                end
toc
tic                
G_k1_1 = sparse(max(max(elementNodes_interface)),size(nodeCoordinates_k1,1),0);
for iOE_I = 1:length(ownerElement_interface)
      clc; disp([num2str(iOE_I) ' from ' num2str(length(ownerElement_interface))])
      iSparse = repmat(elementNodes_interface(ownerElement_interface(iOE_I),:)',1,nx_k1*ny_k1);
      jSparse = repmat(elementNodes_k1(ownerElement_k1(iOE_I),:),nx_int*ny_int,1);
      G_k1_1 = G_k1_1 + sparse(iSparse,jSparse,(g((1:nx_k1*ny_k1)+(iOE_I-1)*nx_k1*ny_k1,:))',...
      length(ownerElement_interface),size(nodeCoordinates_k1,1));
 
end
toc