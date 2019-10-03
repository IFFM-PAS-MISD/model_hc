function [Q]=Vandermonde_v2(ksi,n)

%[Q]=Vandermonde(ksi,n)
% Calculate coefficients for Vandermonde matrices for shape function representation
% n - number of nodes

for i=1:n
    for j=1:n
        V(i,j)=ksi(j)^(i-1);
    end;
end
Q=inv(V);
