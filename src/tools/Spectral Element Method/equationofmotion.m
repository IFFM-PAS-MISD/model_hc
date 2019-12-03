function cmplCases = equationofmotion(structure,Um,Ut,q,Phi_electrode,N_f,G,d0,d1,M,MmC,...
    invMpC,excit_sh,ts,nr_exsh,parentFolder,name_project,case_name,durationtime,iSteps,...
    output_result,intLay,inputNumber,cmplCases,GDof,noFrames)
% EQUATIONOFMOTION   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: [output1,output2] = equationofmotion(input1,input2,input3) 
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
%    [output1,output2] = equationofmotion(input1,input2,input3) 
%    [output1,output2] = equationofmotion(input1,input2) 
%    [output1] = equationofmotion(input1,input2,input3) 
% 
% Other m-files required: none 
% Subfunctions: none 
% MAT-files required: none 
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2 
% 
%
% Author: Piotr Fiborek, D.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 
%format long
clc; tic
frm_int = floor(N_f/(noFrames)); proc_name = case_name; maxDisplacementCondition = 0.1;
Ut_XP = cell(size(structure,2),1);Ut_YP = cell(size(structure,2),1);Ut_ZP = cell(size(structure,2),1);
Ut_FXP = cell(size(structure,2),1);Ut_FYP = cell(size(structure,2),1);Ut_FZP = cell(size(structure,2),1);


for i = 1 : size(structure,2)
    [Ut_XP{i}, Ut_YP{i}, Ut_ZP{i}, Ut_FXP{i}, Ut_FYP{i}, Ut_FZP{i}] = ...
        displacementvectorlocal(structure(i).DOF, structure(i).numberElements);
end
%% 

for t = iSteps:N_f-1
    %%
    iSteps = iSteps+1;
    durationtime = procTime(iSteps,N_f,durationtime,proc_name);
    KU = cell(size(structure,2),1);
    F_r = cell(size(structure,2),1);
    for i = 1: size(structure,2)
        [Ut_X, Ut_Y, Ut_Z, Ut_FX, Ut_FY, Ut_FZ] = ...
            displacementvectorglobal(structure(i).DOF(1),Ut{i});
        Ut_XP{i} = local2global(Ut_XP{i},Ut_X,structure(i).I_G,structure(i).I_L);
        Ut_YP{i} = local2global(Ut_YP{i},Ut_Y,structure(i).I_G,structure(i).I_L);
        Ut_ZP{i} = local2global(Ut_ZP{i},Ut_Z,structure(i).I_G,structure(i).I_L);
        Ut_FXP{i} = local2global(Ut_FXP{i},Ut_FX,structure(i).I_G,structure(i).I_L);
        Ut_FYP{i} = local2global(Ut_FYP{i},Ut_FY,structure(i).I_G,structure(i).I_L);
        Ut_FZP{i} = local2global(Ut_FZP{i},Ut_FZ,structure(i).I_G,structure(i).I_L);
        KU{i} = KU_NbN(structure(i),Ut_XP{i},Ut_YP{i},Ut_ZP{i},Ut_FXP{i},Ut_FYP{i},Ut_FZP{i});
        
        if iSteps <= nr_exsh
            F_r{i} = structure(i).Force.*excit_sh(iSteps);
            if ~isempty(structure(i).piezo_type)
                structure(i).Phi(structure(i).voltageNode) = structure(i).Pn(1).*excit_sh(iSteps);
                invKvKvPp_act = structure(i).inv_stiffness_V*...
                    (structure(i).stiffness_V(structure(i).activePhi,structure(i).prescribedPhi)*...
                    structure(i).Phi(structure(i).prescribedPhi));
                f_act = round((structure(i).stiffness_uV(:,structure(i).activePhi)*invKvKvPp_act - ...
                    structure(i).stiffness_uV(:,structure(i).prescribedPhi)*...
                    structure(i).Phi(structure(i).prescribedPhi))*1e16)*1e-16;
            end
        else
            F_r{i} = sparse([],[],[],structure(i).GDof,1,0);
            if ~isempty(structure(i).piezo_type)
                structure(i).Phi(structure(i).voltageNode,1) = 0;  
                invKvKvPp_act = sparse([],[],[],size(structure(i).activePhi,1),1,0);
                f_act = sparse([],[],[],structure(i).GDof,1,0);
            end
        end
        if ~isempty(structure(i).piezo_type)
            invKvvKvuU = structure(i).inv_stiffness_V*(structure(i).stiffness_uV(:,structure(i).activePhi)'*Ut{i});
            KU{i} = KU{i} + structure(i).stiffness_uV(:,structure(i).activePhi)*invKvvKvuU;
            F_r{i} = F_r{i} + f_act;
            if strcmp(output_result(1),'y')||strcmp(output_result(4),'y')
                structure(i).Phi(structure(i).activePhi) = invKvvKvuU - invKvKvPp_act; 
                if strcmp(output_result(1),'y')
                    q_iSteps = structure(i).stiffness_uV'*Ut{i} - ...
                        structure(i).stiffness_V*structure(i).Phi;
                    q(i,iSteps) = sum(q_iSteps(structure(i).voltageNode)); 
                end
                if strcmp(output_result(4),'y')
                    Phi_byLay = reshape(structure(i).Phi,[],...
                        ((structure(i).DOF(3)-1)*structure(i).numElements(3)+1));
                    Phi_electrode(i,iSteps) = mean(Phi_byLay(:,structure(i).electrodeLayer));
                end
            end
        end
    end
    
    F_r = cell2mat(F_r);
    KU = cell2mat(KU);
    Ut = cell2mat(Ut);
    Um = cell2mat(Um);
    %clear F_r KU
    
    if ~isempty(intLay)
        lambda = d0\(d1*(2/ts^2*M*Ut - 1/ts^2*MmC*Um + F_r - KU)); 
        Up = invMpC*(2*M*Ut - MmC*Um + ts^2*(F_r - KU - G'*lambda));
    else
        Up = ts^2*invMpC*F_right;
    end
          %clear F_right lambda 
    Vt = (Up - Um)/(2*ts);
    Up = mat2cell(Up,cell2mat(GDof),1);    
    Um = mat2cell(Ut,cell2mat(GDof),1);
    Ut = Up;
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%    
    
    
    if ~mod(iSteps,frm_int)
        if strcmp(output_result(1),'y')
          filename = 'q.mat';
          filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',num2str(inputNumber),'charge',filename);
          save(filePath,'q')  
       end
       if strcmp(output_result(2),'y')
          filename = [num2str(iSteps),'.mat'];
          filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',num2str(inputNumber),'Um',filename);
          save(filePath,'Um')
       end
       if strcmp(output_result(3),'y')
          filename = [num2str(iSteps),'.mat'];
          filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',num2str(inputNumber),'Vt',filename);
          save(filePath,'Vt')      
       end
       if strcmp(output_result(4),'y')
          filename = 'Phi_electrode.mat';
          filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',num2str(inputNumber),'voltage',filename);
          save(filePath,'Phi_electrode')  
       end
        fileName = ['meantimeFile_',num2str(inputNumber),'.mat'];
        filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',num2str(inputNumber),fileName);
        save(filePath,'Um','Ut','q','Phi_electrode','iSteps','case_name','durationtime')
        if max(max(abs(cell2mat(Um)))) > maxDisplacementCondition || any(isnan(cell2mat(Um)))
        %any(cellfun(@(x) any(isnan(x)),Um))
            cmplCases = setdiff(cmplCases,inputNumber);
            disp('Element displacements exceed limits')
            return
        end
    end
end
durationtime = procTime(N_f,N_f,durationtime,proc_name);
durationtime_h = fix(durationtime/3600);
durationtime_m = fix(mod(durationtime,3600)/60);
durationtime_s = fix(mod(mod(durationtime,3600),60));
durationtime = [durationtime_h,durationtime_m,durationtime_s];

fileName = ['fulltimeFile_',num2str(inputNumber),'.mat'];
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',...
    num2str(inputNumber),fileName);
save(filePath,'Um','Ut','q','Phi_electrode','iSteps','case_name','durationtime')

fileName = ['meantimeFile_',num2str(inputNumber),'.mat'];
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',...
    num2str(inputNumber),fileName);
delete(filePath)
% ---------------------- END OF CODE -------------------

% ================ [equationofmotion.m] ================