function Phi_electrode = Phi_electrode_iSteps(Phi_electrode,Phi,stAttach2,iSteps)
         if ~isempty(Phi)
            if stAttach2 == 1
                Phi_electrode(iSteps) = mean(Phi(:,1));
            elseif stAttach2 == -1
                Phi_electrode(iSteps) = mean(Phi(:,end));
            end
         end