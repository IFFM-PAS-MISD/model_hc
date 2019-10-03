% input data for plate
if  exist('structure','var'); clear structure; end
plotStyle=['k+';'b+';'k+';'r+';'b+';'r+';'r+';'r+';'r+'];
disp('.. Reading input data');

% Signal definition
'Project name';                      name_project='Honeycomb';
'Mesh';                              name_mesh='';
'Name structure';                    name_structure=[name_project, '_20'];
'delam_element file';                name_delam='non';
'interface_element file';            name_interface='non';
% Signal definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
freq_range='pulse_10kHz';% freq_range='1MHz';freq_range='0.5MHz';
                     % freq_range='pulse_signal';

run(['freq_input_',name_project]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% output output_result=[sum electric charges on the top electrode;...
%                       vector Um of the displacements;...
%                       vector Vt of the velocity;
%                       voltage of PZT sensors ]
output_result = ['n';'n';'y';'y'];
pl_no=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Materials
%case 1
%skin
DOF=5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
n=6;        % number of nodes on edge element on X,Y
switch DOF
    case 3
    nzeta=4;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
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
'number of material layers';      lay = 4;
'ply thickness [m]';              ply_thick=1.5/lay*1e-3;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = [0,90,0,90]*1; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0.49;
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
'in x direction - total length [m]';        Lx=500e-3;
'in y direction - total width [m]';         Ly=250e-3;
'in z direction - total thickness [m]';     Lz=sum(lh);
'shift in x direction - total length [m]';        shiftX=0e-3;
'shift in y direction - total width [m]';         shiftY=0e-3;
'shift in z direction - total thickness [m]';     shiftZ=0;
stAttach=[2;1]; % assign structure which element is attached to
interfaceElements=1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_core'; 
mesh_type='honeycomb_skin';
'honeycomb cell inner diagonal [m]';  D_h=ones(1,lay)*25.4e-3*3/4;
'honeycomb cell wall thickness [m]';  W_h=ones(1,lay)*25.4e-3*0.003;
stShape='rect';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile='';
plotSt='no'; % if 'yes' plot nodes
%force nodes and values
Pn=zeros(1,3); 
forceNode_range=[];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Materials
%case 2
L_str=length(structure);
%skin
DOF=5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='glue';

typeProp='full';% 'full' if material properties available or...
                 % 'ready' if S matrix available
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
'ply thickness [m]';              ply_thick=50e-6/lay;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = 0*90; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha= 0*[0.7e2;0.7e2;0.9e4;0.7e2;...
    0.7e2;0.7e2];
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
'in z direction - total thickness [m]';     Lz=sum(lh);

'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
stAttach=[L_str,L_str+2,;-1,1]; % assign structure which element is attached to
interfaceElements=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_core'; 
mesh_type='honeycomb_skin';
'honeycomb cell inner diagonal [m]';  D_h=ones(1,lay)*25.4e-3*3/4;
'honeycomb cell wall thickness [m]';  W_h=ones(1,lay)*25.4e-3*0.003;

pl_no=[];
stShape='rect';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile=[];


%force nodes and values

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%case 3
L_str=length(structure);
% core
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

DOF=6;      % degree of freedom 3 for 3d, 5 for 2d, 6 for core
%n=6;        % number of nodes on edge element on X,Y
switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='aluminium';
ply_thick=5e-3;
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
'in z direction - total thickness [m]';     Lz=5e-3;
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha=0*[0.7e2;0.7e2;0.9e4;0.7e2;0.7e2;0.7e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
stAttach=[L_str,L_str+2;-1,1]; % assign structure which element is attached to
interfaceElements=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder 
% 'base' acc to base plate
mesh_type='honeycomb_core';
numberElementsX=2;
numberElementsY=2;
numberElementsZ=1;
inputfile=[];

pl_no=[];
%force nodes and values

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Materials
%case 4
L_str=length(structure);
%skin
DOF=5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='glue';

typeProp='full';% 'full' if material properties available or...
                 % 'ready' if S matrix available
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
'ply thickness [m]';              ply_thick=50e-6/lay;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = 0*90; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha= 0*[0.7e2;0.7e2;0.9e4;0.7e2;...
    0.7e2;0.7e2];
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
'in z direction - total thickness [m]';     Lz=sum(lh);

'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
stAttach=[L_str,L_str+2,;-1,1]; % assign structure which element is attached to
interfaceElements=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_core'; 
mesh_type='honeycomb_skin';

pl_no=[];
stShape='rect';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile=[];


%force nodes and values

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%Materials
%case 5
L_str=length(structure);
%skin
DOF=5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
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
'number of material layers';      lay = 4;
'ply thickness [m]';              ply_thick=1.5/lay*1e-3;
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = [0,90,0,90]*1; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0.49;
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
'in z direction - total thickness [m]';     Lz=sum(lh);

'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
stAttach=[L_str,L_str+2,L_str+4;-1,1,1]; % assign structure which element is attached to
interfaceElements=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder, 'honeycomb_skin',
% 'honeycomb_core'; 
mesh_type='honeycomb_skin';
'honeycomb cell inner diagonal [m]';  D_h=ones(1,lay)*25.4e-3*3/4;
'honeycomb cell wall thickness [m]';  W_h=ones(1,lay)*25.4e-3*0.003;

pl_no=[];
stShape='rect';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile=[];


%force nodes and values

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%case 6
L_str=length(structure);
% adhesive layer
DOF=5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='glue';
ply_thick=50e-6;
typeProp='full'; % 'full' if material properties available or...
                 %'ready' if S matrix available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'fiber_type-no or type of fiber'; fiber_type=[];
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha=[0.0e2;0.0e2;0.0e4;0.0e2;0.0e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stShape='circ'; %shape of the construction element: 'circ' or 'rect'
'in x direction - total length [m]';        Lx=10.0e-3;
'in y direction - total width [m]';         Ly=10.0e-3;
'in z direction - total thickness [m]';     Lz=sum(lh);
'shift in x direction - total length [m]';   shiftX=-143e-3;
'shift in y direction - total width [m]';    shiftY=0e-3;
'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
%assign structure which element is attached to
stAttach=[L_str,L_str+2;-1,1];
'honeycomb cell inner diagonal [m]';  D_h=ones(1,lay)*25.4e-3*3/4;
'honeycomb cell wall thickness [m]';  W_h=ones(1,lay)*25.4e-3*0.003;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder 
% 'base' acc to base plate
mesh_type='base';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile='cell_hex_0.75inch_PZT_D10mm';

%force nodes and values

'delam_element file';                name_delam='non';
'interface_element file';            name_interface='non';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type=[];
%piezo_type{2}='sensor';

pl_no=[];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%
%case 7
L_str=length(structure);
% piezoelectric transducer
DOF=3;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='piezo_nce51';
ply_thick=0.5e-3;
typeProp='ready'; % 'full' if E,ni,rho available or...
                  %'ready' if S matrix available 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'fiber_type-no or type of fiber'; fiber_type=[];
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha=[0.0e2;0.0e2;0.0e4;0.0e2;0.0e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stShape='circ'; %shape of the construction element: 'circ' or 'rect'
'in x direction - total length [m]';        Lx=10.0e-3;
'in y direction - total width [m]';         Ly=10.0e-3;
'in z direction - total thickness [m]';     Lz=sum(lh);
'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
%assign structure which element is attached to
stAttach=[L_str;-1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder 
% 'base' acc to base plate
mesh_type='base';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile='cell_hex_0.75inch_PZT_D10mm';

%force nodes and values

'delam_element file';                name_delam='non';
'interface_element file';            name_interface='non';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type='actuator';
%piezo_type{2}='sensor';

pl_no=[];
Pn=5*ones(1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%case 8
L_str=length(structure);
% adhesive layer
DOF=5;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='glue';
ply_thick=50e-6;
typeProp='full'; % 'full' if material properties available or...
                 %'ready' if S matrix available
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'fiber_type-no or type of fiber'; fiber_type=[];
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha=[0.0e2;0.0e2;0.0e4;0.0e2;0.0e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stShape='circ'; %shape of the construction element: 'circ' or 'rect'
'in x direction - total length [m]';        Lx=10.0e-3;
'in y direction - total width [m]';         Ly=10.0e-3;
'in z direction - total thickness [m]';     Lz=sum(lh);
'shift in x direction - total length [m]';   shiftX=143e-3;
'shift in y direction - total width [m]';    shiftY=0e-3;
'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str-1).geometry(6));
%assign structure which element is attached to
stAttach=[L_str-2,L_str+2;-1,1];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder 
% 'base' acc to base plate
mesh_type='base';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile='cell_hex_0.75inch_PZT_D10mm';

%force nodes and values

'delam_element file';                name_delam='non';
'interface_element file';            name_interface='non';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type=[];
%piezo_type{2}='sensor';

pl_no=[];
Pn=zeros(1,3);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%%
%case 9
L_str=length(structure);
% piezoelectric transducer
DOF=3;   % degree of freedom 3 for 3d, 5 for 2d
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch DOF
    case 3
    nzeta=3;   % number of nodes on edge element on Z
    case 5
    nzeta=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_material='piezo_nce51';
ply_thick=0.5e-3;
typeProp='ready'; % 'full' if E,ni,rho available or...
                  %'ready' if S matrix available 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% properites of material layers
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'fiber_type-no or type of fiber'; fiber_type=[];
'number of material layers';      lay = 1;     
'stack thickness sequence [m]';   lh = ones(1,lay)*ply_thick; 
'stack angle sequence [deg]';     lalpha = ones(1,lay)*0; 
'stack matrix sequnce';           lmat = ones(1,lay)*1; 
'stack fibres sequece';           lfib = ones(1,lay)*1; 
'volume fraction of fibres';      lvol = ones(1,lay)*0;
'damping coefficients';           alpha=[0.0e2;0.0e2;0.0e4;0.0e2;0.0e2];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% geometry definition
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stShape='circ'; %shape of the construction element: 'circ' or 'rect'
'in x direction - total length [m]';        Lx=10.0e-3;
'in y direction - total width [m]';         Ly=10.0e-3;
'in z direction - total thickness [m]';     Lz=sum(lh);
'shift in z direction - total thickness [m]';shiftZ=...
    (structure(L_str).geometry(6)+structure(L_str).geometry(3)/2+Lz/2);
%assign structure which element is attached to
stAttach=[L_str;-1];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Boundary condition available: 'cccc','cccf','ssff','ffff''ssss' 
BC='ffff'; 
% mesh generation
% mesh type rectangular:if 'rect' put number of elements for X,Y,Z
% if 'file_mesh' put the file name from \Input folder 
% 'base' acc to base plate
mesh_type='base';
numberElementsX=1;
numberElementsY=1;
numberElementsZ=1;
inputfile='cell_hex_0.75inch_PZT_D10mm';

%force nodes and values

'delam_element file';                name_delam='non';
'interface_element file';            name_interface='non';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%piezoelectricity
%piezo_type=cell(piezo_type,1);
piezo_type='sensor_open';
%piezo_type{2}='sensor';


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
structure_content                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% temperature effect
%[structure(:).temp_effect]=deal([]);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                               damage                                    % 
% structure(i).dmgShape='circ'|'rect'
%
dmgNumber=1;
dmgGeometry=cell(dmgNumber,1);
dmgShape=cell(dmgNumber,1);
[structure(:).dmgShape] = deal(dmgShape);
[structure(:).dmgGeometry] = deal(dmgGeometry);
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% dmgShape{1}='circ';
% 'in x direction - total length [m]';         Lx_dmg=380*2e-3;
% 'in y direction - total width [m]';          Ly_dmg=250*2e-3;
% 'shift in x direction - total length [m]';   shiftX_dmg=-250e-3;
% 'shift in y direction - total width [m]';    shiftY_dmg=250e-3;
% 'shift in z direction - total thickness [m]';
% shiftZ_dmg=round((structure(2).geometry(6)+structure(2).geometry(3)/2)*...
%     1e8)*1e-8;
% 'rotation angle around z axis [deg]';        alpha_dmg=45;
% dmgGeometry{1}=[Lx_dmg,Ly_dmg,shiftX_dmg,shiftY_dmg,shiftZ_dmg,alpha_dmg];
% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% dmgShape{2}='rect';
% 'in x direction - total length [m]';         Lx_dmg=132e-3;
% 'in y direction - total width [m]';          Ly_dmg=114e-3;
% 'shift in x direction - total length [m]';   shiftX_dmg=0e-3;
% 'shift in y direction - total width [m]';    shiftY_dmg=0e-3;
% 'shift in z direction - total thickness [m]';
% shiftZ_dmg=round((structure(2).geometry(6)-structure(2).geometry(3)/2)*...
%     1e8)*1e-8;
% 'rotation angle around z axis [deg]';        alpha_dmg=0;
% dmgGeometry{2}=[Lx_dmg,Ly_dmg,shiftX_dmg,shiftY_dmg,shiftZ_dmg,alpha_dmg];
% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% dmgShape{3}='circ';
% 'in x direction - total length [m]';         Lx_dmg=180e-3;
% 'in y direction - total width [m]';          Ly_dmg=100e-3;
% 'shift in x direction - total length [m]';   shiftX_dmg=290e-3;
% 'shift in y direction - total width [m]';    shiftY_dmg=180e-3;
% 'shift in z direction - total thickness [m]';
% 
% shiftZ_dmg=round((structure(2).geometry(6)-structure(2).geometry(3)/2)*...
%     1e8)*1e-8;
% 'rotation angle around z axis [deg]';        alpha_dmg=40;
% dmgGeometry{3}=[Lx_dmg,Ly_dmg,shiftX_dmg,shiftY_dmg,shiftZ_dmg,alpha_dmg];
% %                                                                         %
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% structure(2).dmgGeometry{1}=dmgGeometry{1};
% structure(2).dmgShape{1}=dmgShape{1};
% structure(3).dmgGeometry{1}=dmgGeometry{1};
% structure(3).dmgShape{1}=dmgShape{1};
% 
% structure(1).dmgGeometry{2}=dmgGeometry{2};
% structure(1).dmgShape{2}=dmgShape{2};
% structure(2).dmgGeometry{2}=dmgGeometry{2};
% structure(2).dmgShape{2}=dmgShape{2};
% 
% structure(1).dmgGeometry{3}=dmgGeometry{3};
% structure(1).dmgShape{3}=dmgShape{3};
% structure(2).dmgGeometry{3}=dmgGeometry{3};
% structure(2).dmgShape{3}=dmgShape{3};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%                     End of structure               %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



