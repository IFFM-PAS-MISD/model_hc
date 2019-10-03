function Phi_electrode = Phi_electrode_iSteps(Phi_electrode,Phi,nrNodesZ,iSteps)
         if ~isempty(Phi)
            Phi_electrode(iSteps) = mean(Phi(:,nrNodesZ));
         end