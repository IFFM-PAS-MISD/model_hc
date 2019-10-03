function structure = structurecontent(structure,...
    structure_material,fiber_type,DOF,n,nzeta,lh,lalpha,lmat,lfib,...
    lvol,lh_f,lh_w,la_f,la_w,lphi_x,lphi_y,lg_f,lg_w,D_h,W_h,alpha,...
    typeProp,stShape,stAttach,interfaceElements,name_interface,...
    name_delam,Lx,Ly,Lz,shiftX,shiftY,shiftZ,BC,plotSt,mesh_type,...
    inputfile,numberElementsX,numberElementsY,numberElementsZ,piezo_type,...
    epsS,e_p,Pn,forceNode_range,output_result)
% STRUCTURECONTENT   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: [output1,output2] = structurecontent(input1,input2,input3) 
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
%    [output1,output2] = structurecontent(input1,input2,input3) 
%    [output1,output2] = structurecontent(input1,input2) 
%    [output1] = structurecontent(input1,input2,input3) 
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

if exist('structure','var')
    s_struct=size(structure,2)+1;
else
    s_struct=1;
end
if exist('D_h','var')==0; D_h=[]; end
if exist('W_h','var')==0; W_h=[]; end

structure(s_struct)=struct('material',structure_material,'fiber_type',...
  fiber_type,'DOF',[DOF,n,nzeta],'properties',[lh;lalpha;lmat;lfib;...
  lvol;lh_f;lh_w;la_f;la_w;lphi_x;lphi_y;lg_f;lg_w;D_h;W_h],'damp_coef',alpha,...
  'typeProp',typeProp,'stShape',stShape,'stAttach',stAttach,...
  'interfaceElements',interfaceElements,'int_file',name_interface,...
  'damage_file',name_delam,'geometry',[Lx;Ly;Lz;shiftX;shiftY;shiftZ],...
  'BC',BC,'plotSt',plotSt,'mesh_type',mesh_type,'inputfile',inputfile,...
  'numElements',[numberElementsX;numberElementsY;numberElementsZ],...
  'piezo_type',piezo_type,'epsS',epsS,'e_p',e_p,'Pn',Pn,...
  'forceNode_range',forceNode_range,'output_result',output_result);


%---------------------- END OF CODE---------------------- 

% ================ [structurecontent.m] ================  
