function [U_X, U_Y, U_Z, U_FX, U_FY, U_FZ] = displacementvectorglobal(Dof,Ut)
        U = reshape(Ut,[],Dof);
        U_X = U(:,1);    U_Y = U(:,2);     U_Z = U(:,3);
        if Dof == 3
            U_FX = [];     U_FY = [];     U_FZ = [];
        elseif Dof == 5
            U_FX = U(:,4);     U_FY = U(:,5);     U_FZ = [];
        else
            U_FX = U(:,4);     U_FY = U(:,5);     U_FZ = U(:,6);
        end