% find interface nodes
function [prescintSt]=prescint_nodes(structure_i,structure_att,k)
%structure_i=structure(i);k=structure_i.stAttach(1,ii);structure_att=structure(k);
I=find(structure_i.stAttach(1,:)==k,1);
nodes_dmg=find(structure_i.nodes_dmg(:,I)==1);
prescintSt=structure_i.prescint(:,I);
interfaceElements=find(structure_i.interfaceElements(:,I)==1);
elementNodes=structure_i.elementNodes;
DOF=structure_i.DOF(1);
n=structure_i.DOF(2);
n_zeta=structure_i.DOF(3);
numberNodes=max(max(elementNodes));
if isfield(structure_i,'cellPZT')
    cellPZT=structure_i.cellPZT;
else
    cellPZT=0;
end
switch DOF
    case {5,6}
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%       
    if ~strcmp(structure_i.mesh_type,'honeycomb_skin')&&...
       ~strcmp(structure_i.mesh_type,'honeycomb_core')
        prescint=cell(DOF,1);
        for i=1:n^2
            prescint{1}=[prescint{1}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                0*numberNodes];            
            prescint{2}=[prescint{2}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                1*numberNodes];
            prescint{3}=[prescint{3}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                2*numberNodes];
            prescint{4}=[prescint{4}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                3*numberNodes];            
            prescint{5}=[prescint{5}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                4*numberNodes];
        end
    elseif strcmp(structure_i.mesh_type,'honeycomb_skin')&&...
           strcmp(structure_att.mesh_type,'honeycomb_core')
            prescint=cell(DOF,1);
        for i=[1:n,2*n:n:n^2]
            if i<=n
                prescint{1}=[prescint{1}
                    [setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    0*numberNodes; 
                    setdiff(elementNodes(cellPZT{1},i),nodes_dmg)+0*numberNodes]];
                prescint{2}=[prescint{2}
                    [setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    1*numberNodes; 
                    setdiff(elementNodes(cellPZT{1},i),nodes_dmg)+1*numberNodes]];
                prescint{3}=[prescint{3}
                    [setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    2*numberNodes; 
                    setdiff(elementNodes(cellPZT{1},i),nodes_dmg)+2*numberNodes]];
                prescint{4}=[prescint{4}
                    [setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    3*numberNodes; 
                    setdiff(elementNodes(cellPZT{1},i),nodes_dmg)+3*numberNodes]];
                prescint{5}=[prescint{5}
                    [setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    4*numberNodes; 
                    setdiff(elementNodes(cellPZT{1},i),nodes_dmg)+4*numberNodes]];
            else
                prescint{1}=[prescint{1}
                    setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    0*numberNodes];
                prescint{2}=[prescint{2}
                    setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    1*numberNodes];
                prescint{3}=[prescint{3}
                    setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    2*numberNodes];
                prescint{4}=[prescint{4}
                    setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    3*numberNodes];
                prescint{5}=[prescint{5}
                    setdiff(elementNodes(setdiff(interfaceElements,cellPZT{2}),i),nodes_dmg)+...
                    4*numberNodes];  
            end
        
        end
        
    elseif strcmp(structure_i.mesh_type,'honeycomb_skin')&&...
           ~strcmp(structure_att.mesh_type,'honeycomb_core')
        prescint=cell(DOF,1);
        for i=1:n^2
            prescint{1}=[prescint{1}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                0*numberNodes];            
            prescint{2}=[prescint{2}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                1*numberNodes];
            prescint{3}=[prescint{3}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                2*numberNodes];
            prescint{4}=[prescint{4}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                3*numberNodes];            
            prescint{5}=[prescint{5}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                4*numberNodes];
        end    
    elseif strcmp(structure_i.mesh_type,'honeycomb_core')
        DOF=3;
        prescint=cell(DOF,1);
        switch structure_i.stAttach(2,I)
            case -1
                I2=0;
            case 1
                I2=n^2-n;
        end
        for i=(1:n)+I2
            prescint{1}=[prescint{1}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                0*numberNodes];            
            prescint{2}=[prescint{2}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                1*numberNodes];
            prescint{3}=[prescint{3}
                setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                2*numberNodes];
        end    
    end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
    case 3
        if ~strcmp(structure_i.mesh_type,'honeycomb_skin')
            prescint=cell(DOF,1);
            switch structure_i.stAttach(2,I)
                case -1
                    I2=0;
                case 1
                    I2=n^2*(n_zeta-1);
            end
            for i=(1:n^2)+I2
                prescint{1}=[prescint{1}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    0*numberNodes];            
                prescint{2}=[prescint{2}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    1*numberNodes];
                prescint{3}=[prescint{3}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    2*numberNodes];    
            end
        elseif strcmp(structure_i.mesh_type,'honeycomb_skin')&&...
            strcmp(structure_att.mesh_type,'honeycomb_core') 
            prescint=cell(DOF,1); 
            switch structure_i.stAttach(2,I)
                case -1
                    I2=0;
                case 1
                    I2=n^2*(n_zeta-1);
            end
            for i=[1:n,2*n:n:n^2]+I2
                prescint{1}=[prescint{1}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    0*numberNodes];            
                prescint{2}=[prescint{2}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    1*numberNodes];
                prescint{3}=[prescint{3}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    2*numberNodes];
            end  
        elseif strcmp(structure_i.mesh_type,'honeycomb_skin')&&...
            ~strcmp(structure_att.mesh_type,'honeycomb_core') 
            prescint=cell(DOF,1);
            switch structure_i.stAttach(2,I)
                case -1
                    I2=0;
                case 1
                    I2=n^2*(n_zeta-1);
            end
            for i=(1:n^2)+I2
                prescint{1}=[prescint{1}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    0*numberNodes];            
                prescint{2}=[prescint{2}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    1*numberNodes];
                prescint{3}=[prescint{3}
                    setdiff(elementNodes(interfaceElements,i),nodes_dmg)+...
                    2*numberNodes];
            end      
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    
end
prescint=unique(nonzeros(cell2mat(prescint)));
prescintSt(1:size(prescint,1))=prescint;
end