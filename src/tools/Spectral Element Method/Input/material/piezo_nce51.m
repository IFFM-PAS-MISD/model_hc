%piezo
%nce51 Noliac
% load
%Mesh generation
%Lx_piezo=10e-003;
%Ly_piezo=10e-003;
%Lz_piezo=0.5e-003;
%elastic stiffness matrix E
q11=134e009;
q22=134e009;
q12=88.9e009; 
q13=90.9e009;
q23=90.9e009;
q33=121e009;
q44=20.5e009;
q55=20.5e009;
q66=22.4e009;
rho=7850;

eps_0=8.85e-012;
eps11=906;
eps33=823;
epsS=[eps11 0 0;
0 eps11 0;
0 0 eps33]*eps_0;

e15=13.7;
e31=-6.06;
e33=17.2;
e_p=[0 0 0 0 e15 0;
0 0 0 e15 0 0;
e31 e31 e33 0 0 0];

