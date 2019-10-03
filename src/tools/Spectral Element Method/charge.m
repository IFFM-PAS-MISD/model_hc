function q = charge(q,stiffness_uV,Um,stiffness_V,Phi,voltageNode,iSteps)
         if ~isempty(stiffness_uV)
            q_iSteps = stiffness_uV'*Um - stiffness_V*Phi;
            q(iSteps) = sum(q_iSteps(voltageNode));
         end