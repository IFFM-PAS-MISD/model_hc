function repedgematrix = repedgegeometry(edgematrix,nEdges,n_int)      
        
        repedgematrix = repmat(reshape(edgematrix',[],1),1,n_int);
        repedgematrix = reshape(repedgematrix',[],1);
        repedgematrix = (reshape(repedgematrix',nEdges*n_int,[]))';