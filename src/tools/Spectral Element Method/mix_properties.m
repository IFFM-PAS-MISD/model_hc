function [s11,s12,s13,s14,s15,s16,s22,s23,s24,s25,s26,s33,...
    s34,s35,s36,s44,s45,s46,s55,s56,s66,h1,h2,m11,J11,e_p,epsS,VF,h,lay_i] = ...
    mix_properties(structure_i)

%structure_i = structure(i);

structure_material = structure_i.material;
if isfield(structure_i,'temp_effect')&&~isempty(structure_i.temp_effect)
    % T_g = 215 deg C from [Chamis1983]
    Fm = sqrt((215-structure_i.temp_effect)/(215-20));
    % alpha = 5e-5 from http://www.kayelaby.npl.co.uk
    %Fr = 1/(1+5e-5*(structure_i.temp_effect-20));
    Fr = 1;
else
    Fm = 1;
    Fr = 1;
end 


if strcmp(structure_i.mesh_type,'honeycomb_core')
    lh = structure_i.properties(end,:);
else
    lh = structure_i.properties(1,:);
end
h = sum(lh);
lay_i = length(lh);lalpha = structure_i.properties(2,:);
lmat = structure_i.properties(3,:);lfib = structure_i.properties(4,:);
lvol = structure_i.properties(5,:);fiber_type = structure_i.fiber_type;
run(structure_material)
alphaF = zeros(1,lay_i);
if strcmp(structure_i.typeProp,'full')
    e11_m = zeros(1,lay_i);rhom = zeros(1,lay_i);ni12_m = zeros(1,lay_i);vol = zeros(1,lay_i);
    e11_f = zeros(1,lay_i);rhof = zeros(1,lay_i);ni12_f = zeros(1,lay_i);
    e22_f = zeros(1,lay_i);ni23_f = zeros(1,lay_i);

    for i = 1:lay_i;
        % matrix properties %%%%%%fibres properties %%%%%%%%%%%%%%%%%
        e11_m(i) = Fm*i_e11m(lmat(i));         e11_f(i) = i_e11f(lfib(i));
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
        ni12_m(i) = i_ni12m(lmat(i));          ni12_f(i) = i_ni12f(lfib(i));
        vol(i) = lvol(i);                   alphaF(i) = lalpha(i);
    end;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sierakowski page 46 eq. 2.33
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%   
    rho = rhof.*vol+rhom.*(1-vol);
    [q11, q12, q13, q22, q23, q33, q44, q55, q66] = ...
    functionalHahn(e11_m, e11_f, e22_f, ni12_m, ni12_f, ni23_f, vol);
end

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global single layer properties 
% wykreslone sa: s13 s23 s33 s36, bo epsz = 0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% elastic properties %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if strcmpi(fiber_type,'unidirectional')==1 || isempty(fiber_type)==1
    alphar = alphaF*pi/180;
    m = round(cos(alphar)*1e12)*1e-12; n = round(sin(alphar)*1e12)*1e-12;
    h1 = zeros(1,lay_i);
    h2 = zeros(1,lay_i);
    h2(1) = h/2; h1(1) = h/2-lh(1);
    if lay_i > 1
        for i = 2:lay_i;
            h2(i) = h2(i-1)-lh(i-1);
            h1(i) = h1(i-1)-lh(i);
        end;
    end
    m11 = 0; J11 = 0;
    for i = 1:lay_i;
        % mass matrix components %%%%%%%%%%%%%%%%%
        m11 = m11+rho(:,i).*(h2(i)-h1(i));
        J11 = J11+rho(:,i).*(h2(i)^3-h1(i)^3)/3;
    end
    s11 = q11.*m.^4+2*(q12+2*q66).*m.^2.*n.^2+q22.*n.^4;
    s12 = (q11+q22-4*q66).*m.^2.*n.^2+q12.*(m.^4+n.^4);
    s13 = q13.*m.^2+q23.*n.^2; s14 = 0*q11; s15 = 0*q11;
    s16 = (q11-q12-2*q66).*m.^3.*n+(q12-q22+2*q66).*m.*n.^3;
    s22 = q11.*n.^4+2*(q12+2*q66).*m.^2.*n.^2+q22.*m.^4;
    s23 = q13.*n.^2+q23.*m.^2; s24 = 0*q11;s25 = 0*q11;
    s26 = (q11-q12-2*q66).*n.^3.*m+(q12-q22+2*q66).*n.*m.^3;
    s33 = q33;s34 = 0*q11;s35 = 0*q11;s36 = (q13-q23).*m.*n;
    s44 = q44.*m.^2+q55.*n.^2;s45 = (q55-q44).*m.*n;
    s46 = 0*q11;s55 = q55.*m.^2+q44.*n.^2;
    s56 = 0*q11;s66 = (q11+q22-2*q12-2*q66).*m.^2.*n.^2+q66.*(m.^4+n.^4);
    
    VF = zeros(1,lay_i);
elseif strcmpi(fiber_type,'plain_h')==1
    a_f = structure_i.properties(8);
    a_w = structure_i.properties(9);
    g_f = structure_i.properties(12); 
    g_w = structure_i.properties(13); 

    RVE_str = struct('geometry',[(a_f+g_f)/2 (a_w+g_w)/2 0 (a_f+g_f)/4 (a_w+g_w)/4 0],...
    'numElements',[5,5],'mesh_type','rect','inputfile','');
    [RVE_str.ksi,RVE_str.wix] = gll(structure_i.DOF(2));
    [RVE_str.eta,RVE_str.wiy] = gll(structure_i.DOF(2));
    [RVE_str.zeta,RVE_str.wiz] = gll(structure_i.DOF(3));
    [RVE_str.DOF] = structure_i.DOF;
    [RVE_str.numberElements,RVE_str.nodeCoordinates,RVE_str.elementNodes] =  ...
        mesh_generator(RVE_str,1);
    [RVE_str.elementNodes,RVE_str.nodeCoordinates,~] = ...
    quad2spectral(RVE_str.elementNodes,RVE_str.nodeCoordinates,RVE_str,RVE_str.DOF(2)-1);
    RVE_str.nodeCoordinates = round(RVE_str.nodeCoordinates*1e12)*1e-12;
    x = RVE_str.nodeCoordinates(:,1);
    y = RVE_str.nodeCoordinates(:,2);
    s11 = []; s12 = []; s13 = []; s14 = []; s15 = []; s16 = []; s21 = []; s22 = []; s23 = []; 
    s24 = []; s25 = []; s26 = []; s31 = []; s32 = []; s33 = []; s34 = []; s35 = []; s36 = [];
    s41 = []; s42 = []; s43 = []; s44 = []; s45 = []; s46 = []; s51 = []; s52 = []; s53 = [];
    s54 = []; s55 = []; s56 = []; s61 = []; s62 = []; s63 = []; s64 = []; s65 = []; s66 = [];

    h0 = linspace(h/2-sum(lh(1:4))/2,-(h/2-sum(lh(1:4))/2),floor(lay_i/4));
    h1 = zeros(size(x,1),lay_i);
    h2 = zeros(size(x,1),lay_i);
 
    for ii = 1:lay_i/4
        [z_fw,theta_fw,lvol_w] = plain_weave(structure_i,lvol(2),[x,y],ii,'no');
        %lvol_w = lvol(1:4);
        VF = repmat(lvol_w,size(z_fw,1),lay_i/4);
        h2(:,1+4*(ii-1)) = sum(lh(1:4))/2+h0(ii); h1(:,1+4*(ii-1)) = ...
            max(z_fw,[],2)+h0(ii);   
        h2(:,2+4*(ii-1)) = z_fw(:,1)+h0(ii); h1(:,2+4*(ii-1)) = z_fw(:,2)+h0(ii);
        h2(:,3+4*(ii-1)) = z_fw(:,3)+h0(ii); h1(:,3+4*(ii-1)) = z_fw(:,4)+h0(ii);
        h2(:,4+4*(ii-1)) = min(z_fw,[],2)+h0(ii); h1(:,4+4*(ii-1)) = ...
            -sum(lh(1:4))/2+h0(ii);
        plain_prop    
    end
    h2 = round(h2*1e8)*1e-8;
    h1 = round(h1*1e8)*1e-8;
else    
    [z_fw,theta_fw,lvol_w] = plain_weave(structure_i,lvol(2),structure_i.XY_P,...
    1,'no');

    plain_prop
    
    h2 = repmat(h2,structure_i.DOF(3),1); h1 = repmat(h1,structure_i.DOF(3),1);
    VF = repmat(vol_w,size(z_fw,1)*structure_i.DOF(3),1);
    s11 = repmat(s11,structure_i.DOF(3),1); s12 = repmat(s12,structure_i.DOF(3),1);
    s13 = repmat(s13,structure_i.DOF(3),1); s14 = repmat(s14,structure_i.DOF(3),1);
    s15 = repmat(s15,structure_i.DOF(3),1); s16 = repmat(s16,structure_i.DOF(3),1);
    s22 = repmat(s22,structure_i.DOF(3),1); s23 = repmat(s23,structure_i.DOF(3),1);
    s24 = repmat(s24,structure_i.DOF(3),1); s25 = repmat(s25,structure_i.DOF(3),1); 
    s26 = repmat(s26,structure_i.DOF(3),1); s33 = repmat(s33,structure_i.DOF(3),1); 
    s34 = repmat(s34,structure_i.DOF(3),1); s35 = repmat(s35,structure_i.DOF(3),1); 
    s36 = repmat(s36,structure_i.DOF(3),1); s44 = repmat(s44,structure_i.DOF(3),1);
    s45 = repmat(s45,structure_i.DOF(3),1); s46 = repmat(s46,structure_i.DOF(3),1);
    s55 = repmat(s55,structure_i.DOF(3),1); s56 = repmat(s56,structure_i.DOF(3),1);
    s66 = repmat(s66,structure_i.DOF(3),1); 
end

