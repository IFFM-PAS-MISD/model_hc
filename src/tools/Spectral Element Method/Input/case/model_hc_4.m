% input data for plate
if  exist('structure','var'); clear structure; end
plotStyle=['k+';'b+';'k+';'r+';'b+';'r+';'r+';'r+';'r+'];
disp('.. Reading input data');

% Signal definition

'Project name';                      name_project = 'model_hc';
'Mesh';                              name_mesh = '';
'delam_element file';                name_delam = 'non';
'interface_element file';            name_interface = 'non';
% Signal definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_range = 'pulse_15kHz';% freq_range='1MHz';freq_range='0.5MHz';
                     % freq_range='pulse_signal';

run('freq_input_model_hc');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output output_result=[sum electric charges on the top electrode;...
%                       vector Um of the displacements;...
%                       vector Vt of the velocity;
%                       voltage of PZT sensors ]
output_result = ['n';'n';'y';'y'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Materials
%case 1
% carbon fiber
DOF = 5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'number of nodes on edge element on X,Y';   n = 6;
switch DOF
    case 3
    nzeta = 4;   % number of nodes on edge element on Z
    case 5
    nzeta = 1;
end
n_y = n;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='composite_PF2';
typeProp='full'; % 'full' if material properties available or...
                 %'ready' if S matrix available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
piezo_type=[];
epsS=[];         % electric properties
e_p=[];          % electric properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'fiber_type-no or type of fiber'; fiber_type='unidirectional';
'number of material layers';      lay = 8;
'ply thickness [m]';              ply_thick=1.0/lay*1e-3;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = [0,90,0,90,90,0,90,0]*1; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0.50;
'damping coefficients';           alpha=[0.7e4;0.7e4;0.7e4;0.7e4;0.7e4];
'thickness of the fill [m]';      lh_f = [];
'thickness of the warp [m]';      lh_w = [];
'width of the fill [m]';          la_f = [];
'thickness of the warp [m]';      la_w = [];
'width of the fill gap [m]';      lg_f = [];
'thickness of the warp gap [m]';  lg_w = [];
'phase shift x [m]';              lphi_x = [];
'phase shift y [m]';              lphi_y = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'in x direction - total length [m]';                Lx = 480e-3;
'in y direction - total width [m]';                 Ly = 314e-3;
'in z direction - total thickness [m]';             Lz = sum(lh);
'shift in x direction - total length [m]';          shiftX = 0e-3;
'shift in y direction - total width [m]';           shiftY = 0e-3;
'shift in z direction - total thickness [m]';       shiftZ = 0e-3;
stAttach = [2;1;false]; % assign structure which element is attached to
interfaceElements = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC = 'ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_skin'; 
mesh_type = 'rect';
'honeycomb cell inner diagonal [m]';  D_h = [];%ones(1,lay) * 19.0e-3;
'honeycomb cell wall thickness [m]';  W_h = [];%ones(1,lay) * 70.0e-6;
stShape = 'rect';
numberElementsX = 29;
numberElementsY = 19;
numberElementsZ = 1;
inputfile = '';
plotSt = 'no'; % if 'yes' plot nodes
%force nodes and values
Pn = zeros(1,3); 
forceNode_range = [];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%case 2
L_str = length(structure);
% core
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DOF = 6;      % degree of freedom 3 for 3d, 5 for 2d, 6 for core
n = 3;
switch DOF
    case 3
    nzeta = 4;   % number of nodes on edge element on Z
    case 5
    nzeta = 1;
end
n_y = 4;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material = 'aluminium';
ply_thick = 10e-3;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'in x direction - total length [m]';                Lx = 500e-3;
'in y direction - total width [m]';                 Ly = 314e-3;
'in z direction - total thickness [m]';     Lz = 10e-3;
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha = 0*[0.7e2;0.7e2;0.9e4;0.7e2;0.7e2;0.7e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'shift in z direction - total thickness [m]';           shiftZ = ...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
stAttach = [L_str,L_str+2;-1,1;false,false]; % assign structure which element is attached to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mesh_type = 'honeycomb_core';
%force nodes and values
'honeycomb cell inner diagonal [m]';  D_h = ones(1,lay) * 19.0e-3;
'honeycomb cell wall thickness [m]';  W_h = ones(1,lay) * 50.0e-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Materials
%case 3
L_str = length(structure);
% carbon fiber
DOF = 5;   % degree of freedom 3 for 3d, 5 for 2d
n = 6;
switch DOF
    case 3
    nzeta = 4;   % number of nodes on edge element on Z
    case 5
    nzeta = 1;
end
n_y = n;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material = 'composite_PF2';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'fiber_type-no or type of fiber'; fiber_type = 'unidirectional';
'number of material layers';      lay = 8;
'ply thickness [m]';              ply_thick = 1.0/lay*1e-3;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = [0,90,0,90,90,0,90,0]*1; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0.5;
'damping coefficients';           alpha = [0.7e4;0.7e4;0.7e4;0.7e4;0.7e4];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'in x direction - total length [m]';                Lx = 480e-3;
'in y direction - total width [m]';                 Ly = 314e-3;
'in z direction - total thickness [m]';             Lz = sum(lh);
'shift in x direction - total length [m]';          shiftX = 0e-3;
'shift in y direction - total width [m]';           shiftY = 0e-3;
'shift in z direction - total thickness [m]';       shiftZ = ...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
stAttach = [L_str, L_str+2, L_str+3; -1,1,1;false,false,false]; % assign structure which element is attached to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_core'; 
mesh_type = 'rect';
numberElementsX = 20;
numberElementsY = 20;
numberElementsZ = 1;
'honeycomb cell inner diagonal [m]';  D_h = [];%ones(1,lay) * 19.0e-3;
'honeycomb cell wall thickness [m]';  W_h = [];%ones(1,lay) * 50.0e-6;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Materials
%case 4
L_str = length(structure);
% PZT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material = 'piezo_P502';
ply_thick = 0.5e-3;
DOF = 3;      % degree of freedom 3 for 3d, 5 for 2d
switch DOF
    case 3
    nzeta = 4;   % number of nodes on edge element on Z
    case 5
    nzeta = 1;
end
n_y = n;
typeProp = 'ready'; % 'full' if E,ni,rho available or...
                  %'ready' if S matrix available 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha = [0.0e2;0.0e2;0.0e4;0.0e2;0.0e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stShape = 'circ'; %shape of the construction element: 'circ' or 'rect'
'in x direction - total length [m]';        Lx = 10.0e-3;
'in y direction - total width [m]';         Ly = 10.0e-3;
'in z direction - total thickness [m]';     Lz = sum(lh);
'shift in x direction - total length [m]';  shiftX = -85.86e-3;
'shift in y direction - total width [m]';   shiftY = 0e-3;
'shift in z direction - total thickness [m]';     shiftZ =...
    (structure(L_str).geometry(6) + (structure(L_str).geometry(3)+Lz)/2);
%assign structure which element is attached to
stAttach = [L_str; -1; true]; % assign structure which element is attached to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'honeycomb cell inner diagonal [m]';  D_h = [];%ones(1,lay) * 19.0e-3;
'honeycomb cell wall thickness [m]';  W_h = [];%ones(1,lay) * 50.0e-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type = 'actuator';
mesh_type = 'file_mesh';
inputfile = 'PZTd10_24';
%piezo_type = 'sensor';
Pn = 10*ones(1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Materials
%case 5

% PZT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material = 'piezo_P502';
ply_thick = 0.5e-3;

typeProp = 'ready'; % 'full' if E,ni,rho available or...
                  %'ready' if S matrix available 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha = [0.0e2;0.0e2;0.0e4;0.0e2;0.0e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stShape = 'circ'; %shape of the construction element: 'circ' or 'rect'
'in x direction - total length [m]';        Lx = 10.0e-3;
'in y direction - total width [m]';         Ly = 10.0e-3;
'in z direction - total thickness [m]';     Lz = sum(lh);
'shift in x direction - total length [m]';  shiftX = 85.56e-3;
'shift in y direction - total width [m]';   shiftY = 0e-3;
'shift in z direction - total thickness [m]';     shiftZ =...
    (structure(L_str).geometry(6) + (structure(L_str).geometry(3)+Lz)/2);
%assign structure which element is attached to
stAttach = [L_str; -1; true]; % assign structure which element is attached to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'honeycomb cell inner diagonal [m]';  D_h = [];%ones(1,lay) * 19.0e-3;
'honeycomb cell wall thickness [m]';  W_h = [];%ones(1,lay) * 50.0e-6;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type = 'sensor_open';
mesh_type = 'file_mesh';
inputfile = 'PZTd10_24';
%piezo_type = 'sensor';
Pn = 10*ones(1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temperature effect
%[structure(:).temp_effect]=deal([0]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               damage                                    % 
dmgStruct = struct('shape',{},'type',{} ,'geometry',{},'structure',{},'localization',{});
dmgNumber = 1;
dmgShape = 'rect';
dmgType = 'global';
dmgPrpReduction = 0;
dmgStructure = 2;
'in x direction - total length [m]';           Lx_dmg = 20e-3;
'in y direction - total width [m]';            Ly_dmg = 67e-3;
'in z direction - total thickness [m]';        Lz_dmg = 0;
% Lz_dmg = 0; for disconected nodes
'shift in x direction - total length [m]';     shiftX_dmg = 0e-3;
'shift in y direction - total width [m]';      shiftY_dmg = 0e-3;
'shift in z direction - total thickness [m]';  shiftZ_dmg = ...
    -structure(2).geometry(3)/2 + structure(2).geometry(6);
'rotation angle around z axis [deg]';          alpha_dmg = 0;
'distance between disconected nodes';          nodesShift_dmg = 0;
dmgGeometry = [Lx_dmg,Ly_dmg,Lz_dmg, nodesShift_dmg];
dmgLocalization = [shiftX_dmg,shiftY_dmg,shiftZ_dmg,alpha_dmg];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dmgStruct(dmgNumber).geometry = dmgGeometry;
dmgStruct(dmgNumber).localization = dmgLocalization;
dmgStruct(dmgNumber).shape = dmgShape;
dmgStruct(dmgNumber).type = dmgType;
dmgStruct(dmgNumber).structure = dmgStructure;
dmgStruct(dmgNumber).dmgPrpReduction = dmgPrpReduction;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 'shape' - 'circ', 'rect', 'poly'
% 'type' - 'global' for interface disconection; 'local' for damage in the
% element
% 'geometry' - [length_x,length_y, thickness, nodesShift_dmg]; thickness=0
% for disconected nodes
% 'structure' - in which structure damage occured or master structure for
% damage in the interface
% 'localization' - [shiftX,shiftY,shiftZ,angle] 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                     End of structure               %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%