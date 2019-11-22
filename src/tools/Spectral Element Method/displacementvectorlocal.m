function [U_XP, U_YP, U_ZP, U_FXP, U_FYP, U_FZP] = ...
            displacementvectorlocal(Dof,nrElements)
        nrNodesX = Dof(2);nrNodesZ = Dof(3);nrNodesY = Dof(4);
        U_XP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        U_YP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        U_ZP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        U_FXP = [];     U_FYP = [];     U_FZP = [];
        if Dof(1) == 5
            U_FXP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FYP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FZP = [];
        elseif Dof(1) == 6
            U_FXP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FYP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
            U_FZP = zeros(nrNodesX*nrNodesY*nrNodesZ*nrElements,1);
        end