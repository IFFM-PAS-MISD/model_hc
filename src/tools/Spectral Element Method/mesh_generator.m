% mesh_generator
function [nodeCoordinates,elementNodes,rotation_angle]= ...
    mesh_generator(structure,actSt)

%actSt=1;structure_i=structure(actSt);
%%
structure_i = structure(actSt);
Lx = structure_i.geometry(1);
Ly = structure_i.geometry(2);
numberElementsX = structure_i.numElements(1);
numberElementsY = structure_i.numElements(2);
mesh_type = structure_i.mesh_type;
inputfile = structure_i.inputfile;
shift_x = structure_i.geometry(4);
shift_y = structure_i.geometry(5);
shift_z = structure_i.geometry(6);

switch mesh_type
    case 'rect'
        [nodeCoordinates,elementNodes_str] = ...
            rectangularMesh(Lx,Ly,numberElementsX,numberElementsY,shift_x,shift_y,shift_z);
    case 'honeycomb_skin'
        [nodeCoordinates,elementNodes_str] = honeycomb_skin(structure,actSt);
    case 'honeycomb_core'
        [nodeCoordinates,elementNodes_str,rotation_angle] = honeycomb_core(structure,actSt);  
    case 'file_mesh'
        folder_name = 'Input\Mesh\';
        filename = ['nodeCoordinates_',inputfile,'.txt'];
        file_patch = [folder_name,filename];
        fid = fopen(num2str(file_patch));
        nodeCoordinates_str = textscan(fid, '%f %f');
        fclose(fid);
        nodeCoordinates_strX = nodeCoordinates_str{1};
        nodeCoordinates_strY = nodeCoordinates_str{2};
        nodeCoordinates(:,1) = nodeCoordinates_strX + shift_x;
        nodeCoordinates(:,2) = nodeCoordinates_strY + shift_y;
        nodeCoordinates(:,3) = zeros(size(nodeCoordinates,1),1) + shift_z;
        filename = ['elementNodes_',inputfile,'.txt'];
        file_patch = [folder_name,filename];
        fid = fopen(num2str(file_patch));
        elements = textscan(fid,'%d %d %d %d %d');
        fclose(fid); 
        elementNodes_str = [elements{2},elements{3},elements{4},elements{5}];
end
numberElements = size(elementNodes_str,1);
if strcmp(structure_i.mesh_type,'file_mesh')
    elementNodes = zeros(numberElements,4);
    format long
    for j = 1:numberElements;
        element = nodeCoordinates(elementNodes_str(j,:),:);
        [~,IX] = sort(element(:,3));
        element_st3 = element(IX,:);
        elementNodes_st = elementNodes_str(j,IX);

        [~,IX] = sort(element_st3(:,2));
        element_st2 = element_st3(IX,:);
        elementNodes_st = elementNodes_st(1,IX);

        for i = [1 3]
            switch i
                case 1
                    order = 'ascend';
                otherwise
                    order = 'descend';
            end
            [~,IX] = sort(element_st2(i:i+1,1),order);
            elementNodes_st(1,i:i+1) = elementNodes_st(1,IX+(i-1));
        end
        elementNodes(j,:) = elementNodes_st;
    end
else
  elementNodes = elementNodes_str;  
end
if ~strcmp(structure_i.mesh_type,'honeycomb_core')
    rotation_angle = zeros(size(elementNodes,1),3);
end