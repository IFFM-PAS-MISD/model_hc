function Phi_electrode = Phi_electrode_C1(Phi_electrode,Phi,nrNodesZ,C1)
         if ~isempty(Phi)
            Phi_electrode(C1) = mean(Phi(:,nrNodesZ));
         end