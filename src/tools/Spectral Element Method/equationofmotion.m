function equationofmotion(Um,Ut,G,d0,d1,M,MmC,iMpC,excit_sh,ts,nr_exsh,N_f,q,Phi_electrode,...
    parentFolder,name_project,case_name,Dof,GDof,nrNodesX,nrNodesZ,Jacob_P11inv,Jacob_P12inv,...
    Jacob_P21inv,Jacob_P22inv,Jacob_P13inv,Jacob_P23inv,Jacob_P31inv,Jacob_P32inv,Jacob_P33inv,...
    numberNodes,w_P,c_xpx,c_xpy,c_xpz,c_ypx,c_ypy,c_ypz,c_zpx,c_zpy,c_zpz,a11,a12,a16,a22,a26,...
    a66,b11,b12,b16,b22,b26,b66,d11,d12,d16,d22,d26,d66,a44_2d,a45_2d,a55_2d,c11,c12,c13,c14,...
    c15,c16,c21,c22,c23,c24,c25,c26,c31,c32,c33,c34,c35,c36,c41,c42,c43,c44,c45,c46,c51,c52,...
    c53,c54,c55,c56,c61,c62,c63,c64,c65,c66,rotation_angle,shapeFunction_P,naturalDerivativesX_P,...
    naturalDerivativesY_P,naturalDerivativesZ_P,nrElements,I_L,I_G, iSteps,Force,Pn,voltageNode,...
    stiffness_V,Phi,activePhi,prescribedPhi,stiffness_uV,durationtime,output_result)
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

% Author: Piotr Fiborek, D.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 
clc; tic
frm_int = floor(N_f/(512)); proc_name = case_name; maxDisplacementCondition = 0.1;
[Ut_XP, Ut_YP, Ut_ZP, Ut_FXP, Ut_FYP, Ut_FZP] =...
    cellfun(@displacementvectorlocal, Dof, nrNodesX, nrNodesZ, nrElements,...
    'UniformOutput',false);
%%
for t = iSteps:N_f-1
    iSteps = iSteps+1;
    durationtime = procTime(iSteps,N_f,durationtime,proc_name);
    [Ut_X, Ut_Y, Ut_Z, Ut_FX, Ut_FY, Ut_FZ] = ...
        cellfun(@displacementvectorglobal, Dof,Ut, 'UniformOutput',false);
    Ut_XP =cellfun(@local2global, Ut_XP,Ut_X,I_G,I_L, 'UniformOutput',false);
    Ut_YP =cellfun(@local2global, Ut_YP,Ut_Y,I_G,I_L, 'UniformOutput',false);
    Ut_ZP =cellfun(@local2global, Ut_ZP,Ut_Z,I_G,I_L, 'UniformOutput',false);
    Ut_FXP =cellfun(@local2global, Ut_FXP,Ut_FX,I_G,I_L, 'UniformOutput',false);
    Ut_FYP =cellfun(@local2global, Ut_FYP,Ut_FY,I_G,I_L, 'UniformOutput',false);
    Ut_FZP =cellfun(@local2global, Ut_FZP,Ut_FZ,I_G,I_L, 'UniformOutput',false);
   if iSteps<=nr_exsh
       F_right = cellfun(@(x) x.*excit_sh(iSteps), Force, 'UniformOutput',false);
       iSteps_vol = cellfun(@(x) x(1).*excit_sh(iSteps), Pn, 'UniformOutput',false);
       Phi = cellfun(@(x,y,z) selectPhi(x,y,z),Phi, voltageNode, iSteps_vol, 'UniformOutput',false);
       invKvKvPp_act = cellfun(@(w,x,y,z) w(x,x)\(w(x,y)*z(y)),...
           stiffness_V,activePhi,prescribedPhi,Phi, 'UniformOutput',false);
       f_act = cellfun(@(u,w,x,y,z) u(:,w)*x-u(:,z)*y(z),stiffness_uV,...
           activePhi,invKvKvPp_act,Phi,prescribedPhi, 'UniformOutput',false);
    else
       F_right = cellfun(@(x) sparse([],[],[],x,1,0),GDof, 'UniformOutput',false);
       
       invKvKvPp_act = cellfun(@(x) sparse([],[],[],size(x,1),1,0),activePhi, 'UniformOutput',false);
       
       f_act = cellfun(@(x) sparse([],[],[],x,1,0),GDof, 'UniformOutput',false);
    end
    invKvvKvuU = cellfun(@(w,x,y,z) invKvvKvuU_iSteps(w,x,y,z), stiffness_V,activePhi,...
            stiffness_uV,Ut,'UniformOutput',false);
    KU = cellfun(@KU_NbN,Dof,Jacob_P11inv,Jacob_P12inv,Jacob_P21inv,...
    Jacob_P22inv,Jacob_P13inv,Jacob_P23inv,Jacob_P31inv,Jacob_P32inv,...
    Jacob_P33inv,shapeFunction_P,naturalDerivativesX_P,naturalDerivativesY_P,...
    naturalDerivativesZ_P,Ut_XP,Ut_YP,Ut_ZP,Ut_FXP,Ut_FYP,Ut_FZP,I_G,I_L,...
    numberNodes,w_P,c_xpx,c_xpy,c_xpz,c_ypx,c_ypy,c_ypz,c_zpx,c_zpy,c_zpz,...
    a11,a12,a16,a22,a26,a66,b11,b12,b16,b22,b26,b66,d11,d12,d16,d22,d26,...
    d66,a44_2d,a45_2d,a55_2d,c11,c12,c13,c14,c15,c16,c21,c22,c23,c24,c25,...
    c26,c31,c32,c33,c34,c35,c36,c41,c42,c43,c44,c45,c46,c51,c52,c53,c54,...
    c55,c56,c61,c62,c63,c64,c65,c66,rotation_angle, 'UniformOutput',false);
    KU = cellfun(@(w,x,y,z)...
        KU_piezo(w,x,y,z),KU,stiffness_uV,activePhi,invKvvKvuU, 'UniformOutput',false);
    f = cellfun(@(x,y) F_piezo(x,y), F_right,f_act, 'UniformOutput',false);
    Ut_f = cell2mat(Ut);
    Um_f = cell2mat(Um);
    f_f = cell2mat(f);
    KU_f = cell2mat(KU);
    if size(Ut,1)>1
        lambda = d0\(d1*(2./ts^2*M*Ut_f-1./ts^2*MmC*Um_f+f_f-KU_f));
        Up_f = iMpC*(2*M*Ut_f-MmC*Um_f+ts^2*(f_f-KU_f-(G)'*lambda));
    else
        Up_f = iMpC*(2*M*Ut_f-MmC*Um_f+ts^2*(f_f-KU_f));
    end
    Vt_f = (-Um_f+Up_f)/(2*ts);
    Up = mat2cell(Up_f,cell2mat(GDof)',1);
    if strcmp(output_result(3),'y') 
       Vt = mat2cell(Vt_f,cell2mat(GDof)',1);
    end
    Um = Ut; Ut = Up;
    if strcmp(output_result(1),'y')||strcmp(output_result(4),'y')
       Phi_c1 = cellfun(@(x,y) x-y,invKvvKvuU,invKvKvPp_act, 'UniformOutput',false); 
       Phi = cellfun(@(x,y,z) selectPhi(x,y,z),Phi, activePhi, Phi_c1, 'UniformOutput',false); 
        if strcmp(output_result(1),'y')
           KV = cellfun(@(x,y) x*y,stiffness_V,Phi, 'UniformOutput',false); 
           q = cellfun(@(u,w,x,y,z) charge(u,w,x,y,z,iSteps),q,stiffness_uV,Um,KV,nrNodesZ, 'UniformOutput',false); 
        end
        if strcmp(output_result(4),'y')
           Phi = cellfun(@(x,y) reshape(x,[],y),Phi,nrNodesZ, 'UniformOutput',false);
           Phi_electrode = cellfun(@(x,y,z) Phi_electrode_iSteps(x,y,z,iSteps),Phi_electrode,Phi,nrNodesZ,'UniformOutput',false);
        end
    end
    if ~mod(iSteps,frm_int)
        if strcmp(output_result(1),'y')
          filename='q.mat';
          filePath=fullfile(parentFolder,'data','raw','num' ,name_project,...
              '\output\',case_name,'charge',filename);
          save(filePath,'Um')  
       end
       if strcmp(output_result(2),'y')
          filename=[folder_name,num2str(iSteps),'.mat'];
          filePath=fullfile(parentFolder,'data','raw','num' ,name_project,...
              '\output\',case_name,'Um',filename);
          save(filePath,'Um')  
       end
       if strcmp(output_result(3),'y')
          filename=[folder_name,num2str(iSteps),'.mat'];
          filePath=fullfile(parentFolder,'data','raw','num' ,name_project,...
              '\output\',case_name,'Vt',filename);
          save(filePath,'Vt')      
       end
       if strcmp(output_result(4),'y')
          filename='Phi_electrode.mat';
          filePath=fullfile(parentFolder,'data','raw','num' ,name_project,...
              '\output\',case_name,'voltage',filename);
          save(filePath,'Phi_electrode')  
       end
      filePath=fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',case_name,'meantimeFile.mat');
      save(filePath,'Um','Ut','q','Phi_electrode','iSteps','case_name','durationtime')
        if max(max(abs(Um{1}))) > maxDisplacementCondition||...
            any(cellfun(@(x) any(isnan(x)),Um))
            disp('Element displacements exceed limits')
            return
        end
    end
end
durationtime_h = fix(durationtime/3600);
durationtime_m = fix(mod(durationtime,3600)/60);
durationtime_s = fix(mod(mod(durationtime,3600),60));
durationtime = [durationtime_h,durationtime_m,durationtime_s];
filePath=fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output',case_name,'meantimeFile.mat');
save(filePath,'Um','Ut','q','Phi_electrode','iSteps','case_name','durationtime')
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%functions%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Phi_electrode = Phi_electrode_iSteps(Phi_electrode,Phi,nrNodesZ,iSteps)
         if ~isempty(Phi)
            Phi_electrode(iSteps) = mean(Phi(:,nrNodesZ));
         end
function q = charge(q,stiffness_uV,Um,KV,nrNodesZ,iSteps)
         if ~isempty(stiffness_uV)
            q_iSteps = reshape((stiffness_uV'*Um-KV),[],nrNodesZ);
            q(iSteps) = sum(q_iSteps(:,nrNodesZ));
         end
function F_right = F_piezo(F_right,f_act)
         if ~isempty(f_act)
            F_right = F_right+f_act;
         end
function KU = KU_piezo(KU,stiffness_uV,activePhi,invKvvKvuU)
         if ~isempty(stiffness_uV)
            KU = KU+stiffness_uV(:,activePhi)*invKvvKvuU;
         end
function invKvvKvuU = invKvvKvuU_iSteps(stiffness_V,activePhi,stiffness_uV,Ut)
        if ~isempty(stiffness_V)
            invKvvKvuU = stiffness_V(activePhi,activePhi)\(stiffness_uV(:,activePhi)'*Ut);
        else
            invKvvKvuU = [];
        end
function  Phi = selectPhi(Phi,voltageNode,iSteps_vol)
         Phi(voltageNode) = iSteps_vol;
function Ut_P = local2global(Ut_P,Ut,I_G,I_L)
             I_L = reshape(I_L,[],1);
             I_G = reshape(I_G,[],1);
        if isempty(Ut)
            Ut_P = [];
        else
            Ut_P(I_L) = Ut(I_G);
        end
function [U_XP, U_YP, U_ZP, U_FXP, U_FYP, U_FZP] = ...
            displacementvectorlocal(Dof, nrNodesX, nrNodesZ, nrElements)
        U_XP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
        U_YP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
        U_ZP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
        U_FXP = [];     U_FYP = [];     U_FZP = [];
        if Dof == 5
            U_FXP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
            U_FYP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
            U_FZP = [];
        elseif Dof == 6
            U_FXP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
            U_FYP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
            U_FZP = zeros(nrNodesX^2*nrNodesZ*nrElements,1);
        end
function [U_X, U_Y, U_Z, U_FX, U_FY, U_FZ] = displacementvectorglobal(Dof,Ut)
        U = reshape(Ut,[],Dof);
        U_X = U(:,1);    U_Y = U(:,2);     U_Z = U(:,3);
        if Dof == 3
            U_FX = [];     U_FY = [];     U_FZ = [];
        elseif Dof == 5
            U_FX = U(:,4);     U_FY = U(:,5);     U_FZ = [];
        else
            U_FX = U(:,4);     U_FY = U(:,5);     U_FZ = U(:,6);
        end
%---------------------- END OF CODE---------------------- 

% ================ [equationofmotion.m] ================  
