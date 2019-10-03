function durationtime = equationofmotion(N_f,Um,Ut,G,invd0,d1,M,MmC,invMpC,excit_sh,...
    ts,nr_exsh,q,Phi_electrode,parentFolder,name_project,case_name,Dof,GDof,nrNodesX,nrNodesZ,nrNodesY,...
    Jacob_P11inv,Jacob_P12inv,Jacob_P21inv,Jacob_P22inv,Jacob_P13inv,Jacob_P23inv,Jacob_P31inv,...
    Jacob_P32inv,Jacob_P33inv,numberNodes,w_P,c_xpx,c_xpy,c_xpz,c_ypx,c_ypy,c_ypz,c_zpx,c_zpy,c_zpz,...
    a11,a12,a16,a22,a26,a66,b11,b12,b16,b22,b26,b66,d11,d12,d16,d22,d26,d66,a44_2d,a45_2d,a55_2d,c11,...
    c12,c13,c14,c15,c16,c21,c22,c23,c24,c25,c26,c31,c32,c33,c34,c35,c36,c41,c42,c43,c44,c45,c46,c51,...
    c52,c53,c54,c55,c56,c61,c62,c63,c64,c65,c66,rotation_angle,shapeFunction_P,naturalDerivativesX_P,...
    naturalDerivativesY_P,naturalDerivativesZ_P,nrElements,I_L,I_G, iSteps,Force,Pn,voltageNode,groundNode,...
    stiffness_V,inv_stiffness_V,Phi,activePhi,prescribedPhi,stiffness_uV,durationtime,output_result,intLay,inputNumber)
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
clc; tic
frm_int = floor(N_f/(512)); proc_name = case_name; maxDisplacementCondition = 0.1;
[Ut_XP, Ut_YP, Ut_ZP, Ut_FXP, Ut_FYP, Ut_FZP] =...
    cellfun(@displacementvectorlocal, Dof, nrNodesX, nrNodesZ, nrNodesY, nrElements,'uni',0);
%%
for t = iSteps:N_f-1
    iSteps = iSteps+1;
    durationtime = procTime(iSteps,N_f,durationtime,proc_name);
    [Ut_X, Ut_Y, Ut_Z, Ut_FX, Ut_FY, Ut_FZ] = ...
        cellfun(@displacementvectorglobal, Dof,Ut, 'uni',0);
    Ut_XP = cellfun(@local2global, Ut_XP,Ut_X,I_G,I_L, 'uni',0);
    Ut_YP = cellfun(@local2global, Ut_YP,Ut_Y,I_G,I_L, 'uni',0);
    Ut_ZP = cellfun(@local2global, Ut_ZP,Ut_Z,I_G,I_L, 'uni',0);
    Ut_FXP = cellfun(@local2global, Ut_FXP,Ut_FX,I_G,I_L, 'uni',0);
    Ut_FYP = cellfun(@local2global, Ut_FYP,Ut_FY,I_G,I_L, 'uni',0);
    Ut_FZP = cellfun(@local2global, Ut_FZP,Ut_FZ,I_G,I_L, 'uni',0);
   if iSteps<=nr_exsh
       F_right = cellfun(@(x) x.*excit_sh(iSteps), Force, 'uni',0);
       iSteps_vol = cellfun(@(x) x(1).*excit_sh(iSteps), Pn, 'uni',0);
       Phi = cellfun(@(x,y,z) selectPhi(x,y,z),Phi, voltageNode, iSteps_vol, 'uni',0);
       invKvKvPp_act = cellfun(@(u,w,x,y,z) u*(w(x,y)*z(y)),...
           inv_stiffness_V,stiffness_V,activePhi,prescribedPhi,Phi, 'uni',0);
       f_act = cellfun(@(u,w,x,y,z) u(:,w)*x-u(:,z)*y(z),stiffness_uV,...
           activePhi,invKvKvPp_act,Phi,prescribedPhi, 'uni',0);
    else
       F_right = cellfun(@(x) sparse([],[],[],x,1,0),GDof, 'uni',0);
       
       invKvKvPp_act = cellfun(@(x) sparse([],[],[],size(x,1),1,0),activePhi, 'uni',0);
       
       f_act = cellfun(@(x) sparse([],[],[],x,1,0),GDof, 'uni',0);
    end
    invKvvKvuU = cellfun(@(w,x,y,z) invKvvKvuU_iSteps(w,x,y,z), inv_stiffness_V,...
        activePhi,stiffness_uV,Ut,'uni',0);
    KU = cellfun(@KU_NbN,Dof,Jacob_P11inv,Jacob_P12inv,Jacob_P21inv,...
        Jacob_P22inv,Jacob_P13inv,Jacob_P23inv,Jacob_P31inv,Jacob_P32inv,...
        Jacob_P33inv,shapeFunction_P,naturalDerivativesX_P,naturalDerivativesY_P,...
        naturalDerivativesZ_P,Ut_XP,Ut_YP,Ut_ZP,Ut_FXP,Ut_FYP,Ut_FZP,I_G,I_L,...
        numberNodes,w_P,c_xpx,c_xpy,c_xpz,c_ypx,c_ypy,c_ypz,c_zpx,c_zpy,c_zpz,...
        a11,a12,a16,a22,a26,a66,b11,b12,b16,b22,b26,b66,d11,d12,d16,d22,d26,...
        d66,a44_2d,a45_2d,a55_2d,c11,c12,c13,c14,c15,c16,c21,c22,c23,c24,c25,...
        c26,c31,c32,c33,c34,c35,c36,c41,c42,c43,c44,c45,c46,c51,c52,c53,c54,...
        c55,c56,c61,c62,c63,c64,c65,c66,rotation_angle, 'uni',0);
    KU = cellfun(@(w,x,y,z) KU_piezo(w,x,y,z),KU,stiffness_uV,activePhi,invKvvKvuU, 'uni',0);
    f = cellfun(@(x,y) F_piezo(x,y), F_right, f_act, 'uni',0);
  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    Fr = cell2mat(f) - cell2mat(KU) + M*cell2mat(Ut) - MmC*cell2mat(Um);
    if ~isempty(intLay)
      lambda = invd0*(d1*Fr); 
      Up = mat2cell(invMpC*(Fr - G'*lambda),cell2mat(GDof)',1);
    else
       Up = mat2cell(invMpC*Fr,cell2mat(GDof)',1);
    end
    Vt = cellfun(@(x,y) (x-y)/(2*ts) ,Up,Um, 'uni',0);
    Um = Ut; Ut = Up;
    if strcmp(output_result(1),'y')||strcmp(output_result(4),'y')
       Phi_act = cellfun(@(x,y) x-y,invKvvKvuU,invKvKvPp_act, 'uni',0); 
       Phi = cellfun(@(x,y,z) selectPhi(x,y,z),Phi, activePhi, Phi_act, 'uni',0); 
        if strcmp(output_result(1),'y')
           q = cellfun(@(u,v,w,x,y,z) charge(u,v,w,x,y,z,iSteps),q,stiffness_uV,Um,stiffness_V,Phi,...
               groundNode, 'uni',0); 
        end
        if strcmp(output_result(4),'y')
           Phi_byLay = cellfun(@(x,y) reshape(x,[],y),Phi,nrNodesZ, 'uni',0);
           Phi_electrode = cellfun(@(x,y,z) Phi_electrode_iSteps(x,y,z,iSteps),Phi_electrode,Phi_byLay,...
               nrNodesZ,'uni',0);
        end
    end
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
        if max(max(abs(Um{1}))) > maxDisplacementCondition||...
            any(cellfun(@(x) any(isnan(x)),Um))
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
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',num2str(inputNumber),fileName);
save(filePath,'Um','Ut','q','Phi_electrode','iSteps','case_name','durationtime')

fileName = ['meantimeFile_',num2str(inputNumber),'.mat'];
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,'output',num2str(inputNumber),fileName);
delete(filePath)
%---------------------- END OF CODE---------------------- 

% ================ [equationofmotion.m] ================  
