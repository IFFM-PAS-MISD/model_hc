% calculate  shape functions of spectral element

function [shapeFunction,naturalDerivatives]=shape_function(xi,eta,zeta,...
    n,n_zeta,n_eta)


switch nargin
    case 4
     n_eta = n;
     n_zeta = n;
    case 5
     n_eta = n;   
end


[ksi,~] = gll(n);
[Eta,~] = gll(n_eta);
[dzeta,~] = gll(n_zeta);
[Q_ksi] = Vandermonde_v2(ksi,n);
[Q_eta] = Vandermonde_v2(Eta,n_eta);
[Q_zeta] = Vandermonde_v2(dzeta,n_zeta);

[Sxi,Dxi] = shape1D_v2(n,Q_ksi,xi);
[Seta,Deta] = shape1D_v2(n_eta,Q_eta,eta);
[Szeta,Dzeta] = shape1D_v2(n_zeta,Q_zeta,zeta);

shapeFunction=(kron(kron(Szeta,Seta),Sxi))';

naturalDerivativesX=(kron(kron(Szeta,Seta),Dxi))';
naturalDerivativesY=(kron(kron(Szeta,Deta),Sxi))';
naturalDerivativesZ=(kron(kron(Dzeta,Seta),Sxi))';

naturalDerivatives=[naturalDerivativesX,naturalDerivativesY,...
    naturalDerivativesZ];

shapeFunction=round(shapeFunction*1e12)*1e-12;
naturalDerivatives=round(naturalDerivatives*1e12)*1e-12;


