function invKvvKvuU = invKvvKvuU_iSteps(inv_stiffness_V,activePhi,stiffness_uV,Ut)
        if ~isempty(inv_stiffness_V)
            invKvvKvuU = inv_stiffness_V*(stiffness_uV(:,activePhi)'*Ut);
        else
            invKvvKvuU = sparse([],[],[],size(activePhi,1),1,0);
        end