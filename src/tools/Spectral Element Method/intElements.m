function interface=intElements(structure_i,structure_att,ii)
%ii=i;structure_i=structure(i);structure_att=structure(structure(i).stAttach(1,ii));

% int_file = structure_i.int_file;
% file_folder = 'Input\Mesh\';
% file_patch = [file_folder,int_file,'.txt'];
% if exist(file_patch,'file')
%     fid = fopen(num2str(file_patch));
%     tline = fgetl(fid);
%     tlines = cell(0,1);
%     while ischar(tline)
%         tlines{end+1,1} = tline;
%         tline = fgetl(fid);
%     end
%     fclose(fid);
%     if strcmp(tlines{ii},'all')
%         interfaceElements=1:structure_i.numberElements;
%     else
%         interfaceElements=str2num(tlines{ii});
%     end
% else 
    if structure_i.geometry(1) >= structure_att.geometry(1)||...
            structure_i.geometry(2) >= structure_att.geometry(2)
        stShape=structure_att.stShape;
        Lx = structure_att.geometry(1);
        Ly = structure_att.geometry(2);
        shiftX_att = structure_att.geometry(4);
        shiftY_att = structure_att.geometry(5);

    elseif structure_i.geometry(1) < structure_att.geometry(1)||...
                structure_i.geometry(2) < structure_att.geometry(2)
            stShape = structure_i.stShape;
            Lx = structure_i.geometry(1);
            Ly = structure_i.geometry(2);
            shiftX_att = structure_i.geometry(4);
            shiftY_att = structure_i.geometry(5);
    end
    n = structure_i.DOF(2);
    nzeta = structure_i.DOF(3);    
    if structure_i.DOF(1) == 5
        shiftZ = structure_i.geometry(6);
        nzeta_lay = 0;
    elseif structure_i.DOF(1) == 3 || strcmp(structure_i.mesh_type,'honeycomb_core')
        shiftZ = round((structure_i.geometry(6)+structure_i.stAttach(2,ii)*...
        (structure_i.geometry(3)/2))*1e8)*1e-8;
        if structure_i.stAttach(2,ii) == -1
            nzeta_lay = 0;
        elseif structure_i.stAttach(2,ii) == 1
            nzeta_lay = nzeta-1; 
        end
    end
    nodeCoordinates_st = structure_i.nodeCoordinates;
    elementNodes_st = structure_i.elementNodes;
    scale = 1e6;
    tolerance = 1e-8;
    if strcmp(stShape,'circ')
        nodes_st = find(round(sqrt((nodeCoordinates_st(:,1)-shiftX_att).^2+ ...
            (nodeCoordinates_st(:,2)-shiftY_att).^2)*scale)/scale<=Lx/2&...
            abs(nodeCoordinates_st(:,3)-shiftZ)<tolerance);
    elseif strcmp(stShape,'rect')
        nodes_st = find(abs(round((nodeCoordinates_st(:,1)-shiftX_att)*scale)/scale)<=Lx/2&...
            abs(round((nodeCoordinates_st(:,2)-shiftY_att)*scale)/scale)<=Ly/2&...
            abs(nodeCoordinates_st(:,3)-shiftZ)<tolerance);   
    end
    ee = 0;
    interfaceElements = zeros(1,1);
    if ~strcmp(structure_i.mesh_type,'honeycomb_core') && ...
            ~strcmp(structure_att.mesh_type,'honeycomb_skin')
        for e = 1:size(elementNodes_st,1)
            if size(find(ismember(elementNodes_st(e,1+n^2*nzeta_lay:...
                    n^2*(nzeta_lay+1)),nodes_st)==0),2)<=2*n;
                ee = ee+1;
                interfaceElements(ee,:) = e;
            end

        end
    else 
        for e = 1:size(elementNodes_st,1)
            ee = ee+1;
            interfaceElements(ee,:) = e;
        end   
    end
% end
interface = zeros(size(elementNodes_st,1),1);
if  any(interfaceElements~=0)
    interface(interfaceElements(:))=1;
end