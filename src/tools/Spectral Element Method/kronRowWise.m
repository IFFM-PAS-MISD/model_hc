function z = kronRowWise(x,y)
        
        z = zeros(size(x,1),size(y,2)*size(y,2));
        for ii = 1 : size(x,1)
            z(ii,:) = kron(x(ii,:),y(ii,:));
        end