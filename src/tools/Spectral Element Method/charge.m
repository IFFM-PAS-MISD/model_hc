function q = charge(q,stiffness_uV,Um,KV,nrNodesZ,C1)
         if ~isempty(stiffness_uV)
            q_C1 = reshape((stiffness_uV'*Um-KV),[],nrNodesZ);
            q(C1) = sum(q_C1(:,nrNodesZ));
         end