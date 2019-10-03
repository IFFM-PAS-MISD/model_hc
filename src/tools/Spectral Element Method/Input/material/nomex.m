%nomex

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix(1) - nomex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'Young modulus [Pa]';                      i_e11m(1) = 9e9;
                                           i_e22m(1) = 9e9;
'Poisson ratio';                           i_ni12m(1) = 0.30;
'density [kg/m3]';                         i_rhom(1) = 1384.0;                   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fibres(1) - []
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'Young modulus [Pa]';                      i_e11f(1) = 275.6e9;
                                           i_e22f(1) = 0.1*275.6e9;
'Poisson ratio';                           i_ni12f(1) = 0.2;
'density [kg/m3]';                         i_rhof(1) = 1900;    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%electric properties
epsS=[];
e_p=[];