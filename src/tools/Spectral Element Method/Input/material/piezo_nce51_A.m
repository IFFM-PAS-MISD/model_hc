% piezo_nce51.m
% Propertis of Piezoelectric Material APC-850

SE_11 = 16.88e-012; % Compliance, in plane [1/Pa]
SE_33 = 21.34e-012; % Compliance, thickness wise [1/Pa]

eps_0 = 8.85e-012; % Dielectric constant in vacuum [F/m]
epsT_33 = 1900*eps_0; % Dielectric constant [F/m]

d_33 = 443e-012;   % Thickness wise induced-strain coefficient [m/V]
d_31 = -208e-012;  % In-plane induced-strain coefficient [m/V]

k_33 = 0.74;       % Coupling factor, parallel to electric field []
k_31 = 0.38;       % Coupling factor, transverce to electric field []
k_p = 0.65;        % Coupling factor, transverce to electric field polar motion []
ny = 0.32;         % Poisson's ration []
rho = 7850;        % Density [kg/m^3]
