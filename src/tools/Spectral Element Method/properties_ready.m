function properties_ready(structure_material,temp_effect,filePath,properties)
if temp_effect~=20
    % T_g=215 deg C from [Chamis1983]
    Fm = sqrt((215-temp_effect)/(215-20));
    % alpha=5e-5 from http://www.kayelaby.npl.co.uk
    %Fr = 1/(1+5e-5*(structure_i.temp_effect-20));
    Fr = 1;
else
    Fm = 1;
    Fr = 1;
end

lh = properties(1,:);
h = sum(lh);
lay_i = length(lh); lalpha = properties(2,:); lmat = properties(3,:);
lfib = properties(4,:); lvol = properties(5,:);
eval(['run input\material\' structure_material])
alphaF = zeros(1,lay_i);
e11_m = zeros(1,lay_i); rhom = zeros(1,lay_i); ni12_m = zeros(1,lay_i);
vol = zeros(1,lay_i); e11_f = zeros(1,lay_i); rhof = zeros(1,lay_i); 
ni12_f = zeros(1,lay_i); e22_f = zeros(1,lay_i); ni23_f = zeros(1,lay_i);

    for i = 1:lay_i;
        % matrix properties %%%%%%fibres properties %%%%%%%%%%%%%%%%%
        e11_m(i) = Fm*i_e11m(lmat(i));        e11_f(i) = i_e11f(lfib(i));
        if exist('i_e22f','var')
            e22_f(i) = i_e22f(lfib(i));
        else
            e22_f(i) = i_ef(lfib(i));
        end
        if exist('i_ni23f','var')
            ni23_f(i) = i_ni23f(lfib(i));
        else
            ni23_f(i) = i_ni12f(lfib(i));
        end
        rhom(i) = Fr*i_rhom(lmat(i));       rhof(i) = i_rhof(lfib(i));
        ni12_m(i) = i_ni12m(lmat(i));       ni12_f(i) = i_ni12f(lfib(i));
        vol(i) = lvol(i);                   alphaF(i) = lalpha(i);
    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sierakowski page 46 eq. 2.33
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
rho = rhof.*vol+rhom.*(1-vol);
[q11, q12, q13, q22, q23, q33, q44, q55, q66] = ...
    functionalHahn(e11_m, e11_f, e22_f, ni12_m, ni12_f, ni23_f, vol);
save(filePath,'q11', 'q12', 'q13', 'q22', 'q23', 'q33', 'q44', 'q55', 'q66','rho')  