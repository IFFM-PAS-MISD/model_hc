function [coords,nodes] = automesh_multi_pzt_simple(mesh_filename,parentFolder,modelfolder)
% AUTOMESH_MULTI_PZT_SIMPLE   automatic mesh generation including 1 delamination region based on geo file
%    for the case of multi pzts; it uses gmsh external software 
% 
% Syntax: [nodes,coords,den_under,den_above,I_G,I_L] = automesh_multi_pzt_simple(mesh_filename,modelfolder,figfilename)
% 
% Inputs: 
%    shape_order - element shape function order, integer, Number of nodes in one direction is shape_order+1
%    mesh_filename - file name for mesh, string
%    modelfolder - corresponding model folder name
%    figfilename - file name for png figure of mesh
%    isDelamOn - boolean, if true - split nodes at delamination
% 
% Outputs: 
%    nodes - nodes of spectral elements (topology), integer, dimensions [NofElements, NofNodes] 
%    coords - coordinates of spectral element nodes, double, dimensions [NofNodes, 3], Units: m 
%    den_under - delaminated element numbers under split interface
%    den_above - delaminated element numbers above split interface
%    I_G,I_L - global and corresponding local node number for parallel computation
% 
% Example: 
%    [nodes,coords,den_under,den_above,I_G,I_L] = automesh_multi_pzt_simple(mesh_filename,modelfolder,figfilename)
% 
% Other m-files required: quad2spectral_Fiborek.m, split_delam_nodes_flat_shell.m, nodesMaps_Fiborek.m 
% Subfunctions: none 
% MAT-files required: none 
% geo-files required: all delam1*.geo in geo folder
% See also:
% 

% Author: Pawel Kudela, D.Sc., Ph.D., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pk@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 

figfilename = fullfile(parentFolder,'src','models',modelfolder,'input','mesh',[mesh_filename,'.png']);
gmsh_path = fullfile(parentFolder,'bin','external','gmsh','gmsh ');
mesh_geometry_path = fullfile(parentFolder,'src','models',modelfolder,'input','mesh','geo',filesep);
mesh_output_path = fullfile(parentFolder,'src','models',modelfolder,'input','mesh','gmsh_out',filesep);
spec_mesh_output_path = fullfile(parentFolder,'src','models',modelfolder,'input','mesh',filesep);
gmsh_options = ' -2 -format auto -v 1 -o '; % non-verbose
%gmsh_options = ' -2 -format auto -o '; % verbose
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gmsh_command = [gmsh_path, mesh_geometry_path, mesh_filename,'.geo', gmsh_options, mesh_output_path, mesh_filename,'.m'];

% run external gmsh.exe - make mesh file from geometry file
status = system(gmsh_command);
if(status)
    disp('Mesh generation in gmsh failed');
end

% load mesh into matlab
run([mesh_output_path, mesh_filename,'.m']);
[nodes,coords]=change_turn_quad(msh.QUADS(:,1:4),msh.POS(:,1:3));
msh.QUADS(:,1:4) = nodes;
plot_mesh(msh,figfilename);
pause(3)
close all;
pause(3)


% delete gmsh out m file
delete([mesh_output_path, mesh_filename,'.m']);


%save([spec_mesh_output_path,mesh_filename,'.mat'],'nodes','coords','pztEl','delamEl','IG1','IG2','IG3','IG4','IG5','IG6','IG7','IG8','IG9','IG10','IG11','IG12','IL1','IL2','IL3','IL4','IL5','IL6','IL7','IL8','IL9','IL10','IL11','IL12','mesh_min','mesh_max','shape_order','den_under','den_above');
save([spec_mesh_output_path,mesh_filename,'.mat'],'nodes','coords');

%---------------------- END OF CODE---------------------- 

% ================ [automesh_multi_pzt_simple.m] ================  