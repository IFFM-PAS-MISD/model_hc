function shapeFunction = sparseSF(Sxi,Seta,Szeta )
         
         if isempty(Szeta)
            if isempty(Seta)
                shapeFunction = Sxi;
            else    
                shapeFunction = kron(Seta,Sxi);
            end
         else
            shapeFunction = kron(kron(Szeta,Seta),Sxi);
         end
         shapeFunction = round(shapeFunction*1e8)*1e-8;
         % shapeFunction(abs(shapeFunction)<1e-8) = 0;
         shapeFunction = sparse(shapeFunction);