function [ksi,wi] = gllnaw(n)
% calculate coordinates of nodes for 1D spectral element
% and gauss-lobatto-legendre weigths
% n - number of nodes (n-1) is approximation order
if n == 1
        ksi=zeros(1,n);
        wi=zeros(1,n);
        ksi(1)=0;
        wi(1)=0;
elseif n >1
    ksi = zeros(1,n);
    wi = zeros(1,n);
    N = n-1;
    ksi(1) = -1; ksi(end) = 1;
    wi(1) = 2/(N*(N+1)); wi(end) = wi(1);
    TOL = 4*eps;

    for j = 1:(N+1)/2-1
        delta = 1/TOL;
        ksi(j+1) = -cos((j+0.25)/N*pi-3/(8*N*pi)/(j+0.25));
        while abs(delta) > TOL*abs(ksi(j+1))
            [q,q_p,~] = qale(N,ksi(j+1));
            delta = -q/q_p;
            ksi(j+1) = ksi(j+1) + delta;
        end
        [~,~,L_n] = qale(N,ksi(j+1));
        ksi(n-j) = -ksi(j+1);
        wi(j+1) = 2/(N*(N+1)*L_n^2);
        wi(n-j) = wi(j+1);
    end
    if mod(N,2)==0
        [~,~,L_n] = qale(N,0.0);
        wi(N/2+1) = 2/(N*(N+1)*L_n^2);
    end
else
    disp('Chosen number of nodes is not available')
    wi=[]; ksi=[];return;
end;


    

