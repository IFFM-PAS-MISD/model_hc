%composite_Kudela2007
%composition of lamina

%P. Kudela et al. / Journal of Sound and Vibration 302 (2007) 728–745
%
'Fiber Density [kg/m3]';                rhof=1900;
'Resin Density [kg/m3]';                rhom=1250;
%'Resin content by weight [%]';          Wm=35;
'Nominal fibre volume';
vol_f=0.49;
'Resin Poisson_s ratio []';             nim=0.35; %Sierakowski p. 40
'Resin Tensil Modulus [Pa]';            em=3.43e9;
 e11_m=em;
 e22_m=em; e33_m=em; 
 g12_m=em/(2*(1+nim));
 g23_m=g12_m;

'Fiber Poisson_s ratio []';
    nif=0.2;
'Fiber Tensil Modulus [Pa]';
    ef=275.6e9;
 'Fiber Poisson_s ratio []';
ni12_f=nif; ni23_f=ni12_f;
'Fiber Tensil Modulus [Pa]';
e11_f=ef;
e22_f=0.1*e11_f; e33_f=e22_f; 
g12_f=e11_f/(2*(1+ni12_f)); g23_f=e22_f/(2*(1+ni23_f));
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matrix(1) - epoxy
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'Young modulus [Pa]';                      i_e11m(1) = e11_m;
                                           i_e22m(1) = e22_m;
                                           i_e33m(1) = e33_m;
                                           i_g12m(1) = g12_m;
                                           i_g23m(1) = g23_m;
'Poisson ratio';                           i_ni12m(1) = nim;
'density [kg/m3]';                         i_rhom(1) = rhom;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fibres(1) - carbon
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
'Young modulus [Pa]';                      i_e11f(1) = e11_f;
                                           i_e22f(1) = e22_f;
                                           i_e33f(1) = e33_f;
                                           i_g12f(1) = g12_f;
                                           i_g23f(1) = g23_f; 
'Poisson ratio';                           i_ni12f(1) = ni12_f; 
                                           i_ni23f(1) = ni23_f;
'density [kg/m3]';                         i_rhof(1) = rhof;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%electric properties
epsS=[];
e_p=[];



clear K E G rhof rhom Wm ni nif ef