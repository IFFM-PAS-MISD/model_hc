function [U_XP, U_YP, U_ZP, U_FXP, U_FYP, U_FZP] = ...
            displacementvectorlocal(Dof, nrNodesX,nrNodesZ,nrNodesY,nrElements)
        U_XP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        U_YP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        U_ZP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        U_FXP = [];     U_FYP = [];     U_FZP = [];
        if Dof == 5
            U_FXP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FYP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FZP = [];
        elseif Dof == 6
            U_FXP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FYP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FZP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        end