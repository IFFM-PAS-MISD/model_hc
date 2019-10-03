function KU = KU_piezo(KU,stiffness_uV,activePhi,invKvvKvuU)
         if ~isempty(stiffness_uV)
            KU = KU + stiffness_uV(:,activePhi)*invKvvKvuU;
         end