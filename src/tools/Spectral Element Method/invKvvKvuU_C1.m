function invKvvKvuU = invKvvKvuU_C1(stiffness_V,activePhi,stiffness_uV,Ut)
        if ~isempty(stiffness_V)
            invKvvKvuU = stiffness_V(activePhi,activePhi)\(stiffness_uV(:,activePhi)'*Ut);
        else
            invKvvKvuU = [];
        end