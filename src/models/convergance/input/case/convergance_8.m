% input data for plate
% username = 'pfiborek'; name_project='convergance'; 
% parentFolder = fullfile(filesep,'home',username,'Documents','GITHub','model_hc');
if  exist('structure','var'); clear structure; end
plotStyle=['k+';'b+';'k+';'r+';'b+';'r+';'r+';'r+';'r+'];
disp('.. Reading input data');

% Signal definition
groupNo = 1;
noFrames = 2048;
'Project name';                      name_project = 'convergance';
'Mesh';                              name_mesh = '';
'delam_element file';                name_delam = 'non';
'interface_element file';            name_interface = 'non';
% Signal definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_range = 'chirp_250kHz';% freq_range='1MHz';freq_range='0.5MHz';
                     % freq_range='pulse_signal';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output output_result=[sum electric charges on the top electrode;...
%                       vector Um of the displacements;...
%                       vector Vt of the velocity;
%                       voltage of PZT sensors ]
output_result = ['n';'n';'y';'n'];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Materials
%case 1
% carbon fiber
DOF = 5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'number of nodes on edge element on X,Y';   n = 8;
switch DOF
    case 3
    nzeta = 4;   % number of nodes on edge element on Z
    case 5
    nzeta = 1;
end
n_y = n;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
groupNo = 2;
structure_material='composite_model_hc';
typeProp='ready'; % 'full' if material properties available or...
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
'number of material layers';      lay = 1;
'ply thickness [m]';              ply_thick = 1e-3/lay;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = 0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0.476;
'damping coefficients';           alpha = [1.5e4;1.5e4;5.0e4;1.5e4;1.5e4];
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
'in x direction - total length [m]';                Lx = 250e-3;
'in y direction - total width [m]';                 Ly = 250e-3;
'in z direction - total thickness [m]';             Lz = sum(lh);
'shift in x direction - total length [m]';          shiftX = 0e-3;
'shift in y direction - total width [m]';           shiftY = 0e-3;
'shift in z direction - total thickness [m]';       shiftZ = 0*Lz;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC = 'ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_skin'; 
mesh_type = 'gmsh';
inputfile = 'plate_500_500';
'honeycomb cell inner diagonal [m]';  l_h = []; h_h = []; t_h = [];
'honeycomb cell wall thickness [m]';  w_h = [];

stShape = 'rect';
numberElementsX = 40;
numberElementsY = 16;
numberElementsZ = 1;
plotSt = 'no'; % if 'yes' plot nodes
%force nodes and values
Pn = zeros(1,3); 
forceNode_range = [];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Materials
%case 4
L_str = length(structure);
% PZT
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
groupNo = 1;
structure_material = 'glue';
ply_thick = 0.1e-3;
typeProp = 'full';
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
'shift in x direction - total length [m]';  shiftX = 0e-3;
'shift in y direction - total width [m]';   shiftY = 0e-3;
'shift in z direction - total thickness [m]';     shiftZ =...
    (structure(L_str).geometry(6) + (structure(L_str).geometry(3)+Lz)/2);
%assign structure which element is attached to
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type = [];
mesh_type = 'gmsh_base';
inputfile = 'plate_500_500';
%piezo_type = 'sensor';
Pn = 1*ones(1,3); 
forceNode_range = [-5e-3,-5e-3, shiftZ; 5e-3,5e-3, shiftZ];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temperature effect
%[structure(:).temp_effect]=deal([0]);
%%
%                               interface
% struct.pair = [master, slave];
L_str = 1;

intStruct(L_str).pair = [2, 1];
intStruct(L_str).rangeX = [-0.5 0.5] * structure(intStruct(L_str).pair(1)).geometry(1) + ...
    structure(intStruct(L_str).pair(1)).geometry(4);
intStruct(L_str).rangeY = [-0.5 0.5] * structure(intStruct(L_str).pair(1)).geometry(2) + ...
    structure(intStruct(L_str).pair(1)).geometry(5);
intStruct(L_str).rangeZ = [-0.5 -0.5] * structure(intStruct(L_str).pair(1)).geometry(3) + ...
    structure(intStruct(L_str).pair(1)).geometry(6);
intStruct(L_str).h =...
    [-0.5*structure(intStruct(L_str).pair(1)).geometry(3), 0.5*structure(intStruct(L_str).pair(2)).geometry(3)];
intStruct(L_str).type = 'circ';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               damage                                    % 
dmgStruct = struct('shape',{},'type',{} ,'geometry',{},'structure',{},'localization',{});

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %                                                                       %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %                                                                       %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                     End of structure               %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%