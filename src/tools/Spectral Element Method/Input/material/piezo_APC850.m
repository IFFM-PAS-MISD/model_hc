% piezo_APC850.m
% Propertis of Piezoelectric Material APC-850

SE_11 = 15.3e-012; % Compliance, in plane [1/Pa]
SE_33 = 17.3e-012; % Compliance, thickness wise [1/Pa]

eps_0 = 8.85e-012; % Dielectric constant in vacuum [F/m]
epsT_33 = 1750*eps_0; % Dielectric constant [F/m]

d_33 = 400e-012;   % Thickness wise induced-strain coefficient [m/V]
d_31 = -175e-012;  % In-plane induced-strain coefficient [m/V]

k_33 = 0.72;       % Coupling factor, parallel to electric field []
k_31 = 0.36;       % Coupling factor, transverce to electric field []
k_p = 0.63;        % Coupling factor, transverce to electric field polar motion []
ny = 0.30;         % Poisson's ration []
rho = 7700;        % Density [kg/m^3]
