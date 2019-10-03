%piezo
%Sonox P502
%elastic stiffness matrix C
d33=440e-12;
d31=-185e-12;
d15=560e-12;
d_p=[0 0 0 0 d15 0;
0 0 0 d15 0 0;
d31 d31 d33 0 0 0];
eps_0=8.85e-012;
epsS11=1260;
epsS33=875;
epsT11=1950;
epsT33=1850;
kp=0.62;
k15=0.74;
ny13=0.44; % assumed SonoxP502_SmatrixB
epsS=[epsS11 0 0;
0 epsS11 0;
0 0 epsS33]*eps_0;
epsT=[epsT11 0 0;
0 epsT11 0;
0 0 epsT33]*eps_0;
cD55=6.5e10;


s11=18.5e-12;
s33=20.7e-12;
s12=-s11+2*d31^2/kp^2/epsT(3,3); % SonoxP502_SmatrixB eq:(54)
ny12=-s12/s11;
s13=-ny13*s11; %SonoxP502_SmatrixB eq:(55)
s23=s13; %SonoxP502_SmatrixB eq:(56)
s55=1/(cD55*(1-k15^2)); %efunda piezo sd=se-d'*epsT^(-1)*d
s44=s55;
s66=2*(1+ny12)*s11; %SonoxP502_SmatrixB eq:(56)

S_E=[s11 s12 s13 0 0 0;
    s12 s11 s23 0 0 0;
    s13 s23 s33 0 0 0;
    0 0 0 s44 0 0;
    0 0 0 0 s55 0;
    0 0 0 0 0 s66];

C_E=S_E^(-1);
q11=C_E(1,1);
q22=C_E(2,2);
q12=C_E(1,2); 
q13=C_E(1,3);
q23=C_E(2,3);
q33=C_E(3,3);
q44=C_E(4,4);
q55=C_E(5,5);
q66=C_E(6,6);
rho=7740;
e_p=d_p*C_E; %efunda piezo e=d*S_E^(-1)
