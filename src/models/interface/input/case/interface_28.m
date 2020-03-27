% input data for plate
% name_project='interface';, parentFolder='E:\model_hc'; 'model_hc','E:\model_hc'
if  exist('structure','var'); clear structure; end
plotStyle = ['k+';'b+';'k+';'r+';'b+';'r+';'r+';'r+';'r+'];
disp('.. Reading input data');

% Signal definition

'Project name';                      name_project = 'interface';
'Mesh';                              name_mesh = '';
'delam_element file';                name_delam = 'non';
'interface_element file';            name_interface = 'non';
% Signal definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_range = 'pulse_50kHz_1';% freq_range='1MHz';freq_range='0.5MHz';% freq_range='pulse_signal';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output output_result=[sum electric charges on the top electrode;...
%                       vector Um of the displacements;...
%                       vector Vt of the velocity;
%                       voltage of PZT sensors ]
output_result = ['n';'n';'y';'y'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Materials
%case 2
% aluminium
DOF = 5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'number of nodes on edge element on X,Y';   n = 144;
switch DOF
    case 3
    nzeta = 6;   % number of nodes on edge element on Z
    case 5
    nzeta = 1;
end
n_y = n;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material = 'aluminium';
typeProp = 'full'; % 'full' if material properties available or...
                 %'ready' if S matrix available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
piezo_type = [];
epsS = [];         % electric properties
e_p = [];          % electric properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'fiber_type-no or type of fiber'; fiber_type = 'unidirectional';
'number of material layers';      lay = 1;
'ply thickness [m]';              ply_thick = 1.0/lay*1e-3;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = 0*1; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha = 0*[0.7e4;0.7e4;0.7e4;0.7e4;0.7e4];
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
'in x direction - total length [m]';                Lx = 400e-3;
'in y direction - total width [m]';                 Ly = 400e-3;
'in z direction - total thickness [m]';             Lz = sum(lh);
'shift in x direction - total length [m]';          shiftX = 0e-3;
'shift in y direction - total width [m]';           shiftY = 0e-3;
'shift in z direction - total thickness [m]';       shiftZ = 0e-3;
stAttach = [2 3;1 1;false false]; % assign structure which element is attached to
interfaceElements = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC = 'ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_skin'; 
mesh_type = 'rect';
'honeycomb cell inner diagonal [m]';  D_h = [];
'honeycomb cell wall thickness [m]';  W_h = [];
stShape = 'rect';
numberElementsX = 1;
numberElementsY = 1;
numberElementsZ = 1;
inputfile = 'plate_500_500_2_pzt_f50_50kHz_00mm_12';
plotSt = 'no'; % if 'yes' plot nodes
%force nodes and values
Pn = zeros(1,3); 
forceNode_range = [];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%Materials
%case 6
L_str = length(structure);
% PZT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material = 'piezo_nce51';
ply_thick = 0.5e-3;
DOF = 3;      % degree of freedom 3 for 3d, 5 for 2d
n = 6;
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
'shift in x direction - total length [m]';  shiftX = -75e-3;
'shift in y direction - total width [m]';   shiftY = 0e-3;
'shift in z direction - total thickness [m]';     shiftZ =...
    (structure(L_str).geometry(6) + (structure(L_str).geometry(3)+Lz)/2);
%assign structure which element is attached to
stAttach = [L_str; -1; true]; % assign structure which element is attached to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type = 'actuator';
mesh_type = 'gmsh';
inputfile = 'pzt_f50_50kHz';
%piezo_type = 'sensor';
Pn = 10*ones(1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Materials
%case 7

% PZT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material = 'piezo_nce51';
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
'shift in x direction - total length [m]';  shiftX = 75e-3;
'shift in y direction - total width [m]';   shiftY = 0e-3;
'shift in z direction - total thickness [m]';     shiftZ =...
    (structure(L_str).geometry(6) + (structure(L_str).geometry(3)+Lz)/2);
%assign structure which element is attached to
stAttach = [L_str; -1; true]; % assign structure which element is attached to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type = 'sensor_open';
%piezo_type = 'sensor';
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