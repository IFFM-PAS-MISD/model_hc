% piezo function

function [prescribedPhi,Phi,groundNode,voltageNode] = piezo_function(structure_i)
%structure_i=structure(i);
nodeCoordinates_piezo = structure_i.nodeCoordinates;
piezo_type = structure_i.piezo_type;
zz_piezo = nodeCoordinates_piezo(:,3);
h = structure_i.geometry(3);
shiftZ = structure_i.geometry(6);
numberNodes_piezo = size(nodeCoordinates_piezo,1);
Phi = zeros(numberNodes_piezo,1);
if shiftZ ~=0
    sign_h = sign(shiftZ);
else
    sign_h = 1;
end
%E0=1e10;
if ~isempty(piezo_type)
    switch piezo_type
        case 'actuator_full'
            groundNode_bot = find(nodeCoordinates_piezo(:,3)==...
                min(abs(nodeCoordinates_piezo(:,3))));
            groundNode_bb = find((sqrt(nodeCoordinates_piezo(:,1).^2+...
                (nodeCoordinates_piezo(:,2)-...
                structure_i.geometry(2)/2).^2))<=(1e-3)&...
                nodeCoordinates_piezo(:,2)>0&nodeCoordinates_piezo(:,3)>min...
                (abs(nodeCoordinates_piezo(:,3))));
            groundNode_b = groundNode_bb(sqrt(nodeCoordinates_piezo...
                (groundNode_bb,1).^2+nodeCoordinates_piezo...
                (groundNode_bb,2).^2)>=0.97*structure_i.geometry(2)/2);
            groundNode_tp = find((sqrt(nodeCoordinates_piezo(:,1).^2+...
                (nodeCoordinates_piezo(:,2)-...
                structure_i.geometry(2)/2).^2))<=(1e-3)&...
                nodeCoordinates_piezo(:,2)>0&...
                nodeCoordinates_piezo(:,3)==max(abs(nodeCoordinates_piezo(:,3))));
            groundNode = unique([groundNode_bot;groundNode_b;groundNode_tp]);
            groundNode_ta = find((sqrt(nodeCoordinates_piezo(:,1).^2+...
                (nodeCoordinates_piezo(:,2)-...
                structure_i.geometry(2)/2).^2))<=(2e-3)&...
                nodeCoordinates_piezo(:,2)>0&...
                nodeCoordinates_piezo(:,3)==max(abs(nodeCoordinates_piezo(:,3))));
            voltageNodet = find(zz_piezo==max(abs(nodeCoordinates_piezo(:,3))));
            voltageNode = voltageNodet(ismember(voltageNodet,...
                groundNode_ta)==0);
            prescribedPhi = [groundNode;voltageNode];
        case 'actuator'
            groundNode = find(abs(zz_piezo-(shiftZ-sign_h*h/2))<=1e-6);
            voltageNode = find(abs(zz_piezo-(shiftZ+sign_h*h/2))<=1e-6);
            prescribedPhi = [groundNode;voltageNode];
        case 'sensor_open'
            % force vector (distributed load applied at zz=0)
            groundNode = find(abs(zz_piezo-(shiftZ-sign_h*h/2))<=1e-6);
            voltageNode = [];
            prescribedPhi = groundNode;
        case 'sensor_closed'
            % force vector (distributed load applied at zz=0)
            groundNode = find(abs(zz_piezo-(shiftZ-sign_h*h/2))<=1e-6);
            V0NodeZ1 = find(abs(zz_piezo-(shiftZ+sign_h*h/2))<=1e-6);
            voltageNode = [];
            prescribedPhi = [groundNode;V0NodeZ1];
       
    end
else
    prescribedPhi = sparse([],[],[],0,1,0);   Phi = sparse([],[],[],0,1,0);
    groundNode = sparse([],[],[],0,1,0);   voltageNode = sparse([],[],[],0,1,0); 
end
