%mechanical materials properties
function [rho,J11,a11,a12,a16,a22,a26,a66,a44_2d,a45_2d,a55_2d,b11,b12,b16,...
b22,b26,b66,d11,d12,d16,d22,d26,d66,c11,c12,c13,c14,c15,c16,c21,c22,c23,...
c24,c25,c26,c31,c32,c33,c34,c35,c36,c41,c42,c43,c44,c45,c46,c51,c52,c53,...
c54,c55,c56,c61,c62,c63,c64,c65,c66,e_p,epsS] = ...
structure_prop_full(structure_i)
%structure_i = structure(i);
%%

n = structure_i.DOF(2);
n_zeta = structure_i.DOF(3);
thicknessElementNo = structure_i.thicknessElementNo;
lh = structure_i.properties(1,:);
fiber_type = structure_i.fiber_type;

DOF = structure_i.DOF(1);
[s11,s12,s13,s14,s15,s16,s22,s23,s24,s25,s26,s33,...
    s34,s35,s36,s44,s45,s46,s55,s56,s66,h1,h2,m11,J11,e_p,epsS,VF,h,lay_i] = ...
    mix_properties(structure_i);

if length(unique(thicknessElementNo))==1
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    a44_2d = 0; a45_2d = 0; a55_2d = 0;a11 = 0;a12 = 0;a16 = 0;a22 = 0;a26 = 0;a66 = 0;
    vf = 0;
    b11 = 0; b12 = 0; b16 = 0; b22 = 0; b26 = 0; b66 = 0;
    d11 = 0; d12 = 0; d16 = 0; d22 = 0; d26 = 0; d66 = 0;
    %a11 = 0;a12 = 0;a22 = 0;a16 = 0;a26 = 0;a66 = 0;%membrane 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% global multilayer properties
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i = 1:lay_i;
        vf = vf+VF(:,i).*(h2(:,i)-h1(:,i));
        h_1 = h2(:,i)-h1(:,i);
        h_2 = (h2(:,i).^2-h1(:,i).^2)./2;
        h_3 = (h2(:,i).^3-h1(:,i).^3)./3;
% stiffness matrix components %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        k = 5/4;
        a44_2d = a44_2d+s44(:,i).*k.*(h_1-4/3.*(h2(:,i).^3-h1(:,i).^3)/h.^2);
        a45_2d = a45_2d+s45(:,i).*k.*(h2(:,i)-h1(:,i)-4/3.*(h2(:,i).^3-h1(:,i).^3)/h.^2);
        a55_2d = a55_2d+s55(:,i).*k.*(h2(:,i)-h1(:,i)-4/3.*(h2(:,i).^3-h1(:,i).^3)/h.^2);
%memebrane
   
        a11 = a11+s11(:,i).*h_1; a12 = a12+s12(:,i).*h_1;
        a16 = a16+s16(:,i).*h_1; a22 = a22+s22(:,i).*h_1;
        a26 = a26+s26(:,i).*h_1; a66 = a66+s66(:,i).*h_1;

        b11 = b11+s11(:,i).*h_2; b12 = b12+s12(:,i).*h_2;
        b16 = b16+s16(:,i).*h_2; b22 = b22+s22(:,i).*h_2;
        b26 = b26+s26(:,i).*h_2; b66 = b66+s66(:,i).*h_2;
  
        d11 = d11+s11(:,i).*h_3; d12 = d12+s12(:,i).*h_3;
        d16 = d16+s16(:,i).*h_3; d22 = d22+s22(:,i).*h_3;
        d26 = d26+s26(:,i).*h_3; d66 = d66+s66(:,i).*h_3;
    end;
    if strcmpi(fiber_type,'plain_h')==1
    % in plane integer
        a44_2d = varInteger(a44_2d,structure_i);
        a45_2d = varInteger(a45_2d,structure_i);
        a55_2d = varInteger(a55_2d,structure_i);
        a11 = varInteger(a11,structure_i); a12 = varInteger(a12,structure_i);
        a16 = varInteger(a16,structure_i); a22 = varInteger(a22,structure_i);
        a26 = varInteger(a26,structure_i); a66 = varInteger(a66,structure_i);

        b11 = varInteger(b11,structure_i); b12 = varInteger(b12,structure_i);
        b16 = varInteger(b16,structure_i); b22 = varInteger(b22,structure_i);
        b26 = varInteger(b26,structure_i); b66 = varInteger(b66,structure_i);

        d11 = varInteger(d11,structure_i); d12 = varInteger(d12,structure_i);
        d16 = varInteger(d16,structure_i); d22 = varInteger(d22,structure_i);
        d26 = varInteger(d26,structure_i); d66 = varInteger(d66,structure_i);
    end
    a44_2d = round(a44_2d*1e12)*1e-12;
    a45_2d = round(a45_2d*1e12)*1e-12;
    a55_2d = round(a55_2d*1e12)*1e-12;  
    a11 = round(a11*1e12)*1e-12;a12 = round(a12*1e12)*1e-12;a16 = round(a16*1e12)*1e-12;
    a22 = round(a22*1e12)*1e-12;a26 = round(a26*1e12)*1e-12;a66 = round(a66*1e12)*1e-12;

    b11 = round(b11*1e12)*1e-12;b12 = round(b12*1e12)*1e-12;b16 = round(b16*1e12)*1e-12;
    b22 = round(b22*1e12)*1e-12;b26 = round(b26*1e12)*1e-12;b66 = round(b66*1e12)*1e-12;
    d11 = round(d11*1e12)*1e-12;d12 = round(d12*1e12)*1e-12;d16 = round(d16*1e12)*1e-12;
    d22 = round(d22*1e12)*1e-12;d26 = round(d26*1e12)*1e-12;d66 = round(d66*1e12)*1e-12;   
    
    if length(lh)>1
 %C.T Sun and Sijaian Li Three-Dimensional Effective Elastic Constants for
 % Thick Laminates Journal of Composite Materials 22 629-639 (1989)
        vk = lh/h; vk = repmat(vk,size(s11,1),1);
        c33 = 1./sum(vk./s33,2);lambda33 = repmat(c33,1,size(s11,2));
        c13 = sum(vk.*s13,2)+sum((s33(:,2:end)-lambda33(:,2:end)).*vk(:,2:end).*...
     (repmat(s13(:,1),1,size(s13,2)-1)-s13(:,2:end))./s33(:,2:end),2);
        lambda13 = repmat(c13,1,size(s11,2));
        c11 = sum(vk.*s11,2)+sum((s13(:,2:end)-lambda13(:,2:end)).*vk(:,2:end).*...
     (repmat(s13(:,1),1,size(s13,2)-1)-s13(:,2:end))./s33(:,2:end),2);
        c12 = sum(vk.*s12,2)+sum((s13(:,2:end)-lambda13(:,2:end)).*vk(:,2:end).*...
     (repmat(s23(:,1),1,size(s23,2)-1)-s23(:,2:end))./s33(:,2:end),2);
        c23 = sum(vk.*s23,2)+sum((s33(:,2:end)-lambda33(:,2:end)).*vk(:,2:end).*...
     (repmat(s23(:,1),1,size(s23,2)-1)-s23(:,2:end))./s33(:,2:end),2);
        lambda23 = repmat(c23,1,size(s11,2));
        c22 = sum(vk.*s22,2)+sum((s23(:,2:end)-lambda23(:,2:end)).*vk(:,2:end).*...
     (repmat(s23(:,1),1,size(s23,2)-1)-s23(:,2:end))./s33(:,2:end),2);
        c16 = sum(vk.*s16,2)+sum((s13(:,2:end)-lambda13(:,2:end)).*vk(:,2:end).*...
     (repmat(s36(:,1),1,size(s36,2)-1)-s36(:,2:end))./s33(:,2:end),2);
        c26 = sum(vk.*s26,2)+sum((s23(:,2:end)-lambda23(:,2:end)).*vk(:,2:end).*...
    (repmat(s36(:,1),1,size(s36,2)-1)-s36(:,2:end))./s33(:,2:end),2);
        c36 = sum(vk.*s36,2)+sum((s33(:,2:end)-lambda33(:,2:end)).*vk(:,2:end).*...
    (repmat(s36(:,1),1,size(s36,2)-1)-s36(:,2:end))./s33(:,2:end),2);
        lambda36 = repmat(c26,1,size(s11,2));
        c66 = sum(vk.*s66,2)+sum((s36(:,2:end)-lambda36(:,2:end)).*vk(:,2:end).*...
    (repmat(s36(:,1),1,size(s36,2)-1)-s36(:,2:end))./s33(:,2:end),2);
        c14 = sum(vk.*s14,2)+sum((s13(:,2:end)-lambda13(:,2:end)).*vk(:,2:end).*...
    (repmat(s34(:,1),1,size(s34,2)-1)-s34(:,2:end))./s33(:,2:end),2);
        c24 = sum(vk.*s24,2)+sum((s23(:,2:end)-lambda23(:,2:end)).*vk(:,2:end).*...
    (repmat(s34(:,1),1,size(s34,2)-1)-s34(:,2:end))./s33(:,2:end),2);
        c34 = sum(vk.*s34,2)+sum((s33(:,2:end)-lambda33(:,2:end)).*vk(:,2:end).*...
    (repmat(s34(:,1),1,size(s34,2)-1)-s34(:,2:end))./s33(:,2:end),2);
        c15 = sum(vk.*s15,2)+sum((s13(:,2:end)-lambda13(:,2:end)).*vk(:,2:end).*...
    (repmat(s35(:,1),1,size(s35,2)-1)-s35(:,2:end))./s33(:,2:end),2);
        c25 = sum(vk.*s25,2)+sum((s23(:,2:end)-lambda23(:,2:end)).*vk(:,2:end).*...
    (repmat(s35(:,1),1,size(s35,2)-1)-s35(:,2:end))./s33(:,2:end),2);
        c35 = sum(vk.*s35,2)+sum((s33(:,2:end)-lambda33(:,2:end)).*vk(:,2:end).*...
    (repmat(s35(:,1),1,size(s35,2)-1)-s35(:,2:end))./s33(:,2:end),2);
        deltak = s44.*s55-s45.^2;
        delta = sum(vk.*s44./deltak,2).*sum(vk.*s55./deltak,2)-...
    (sum(vk.*s45./deltak,2)).^2;
        c44 = (sum(vk.*s44./deltak,2))./delta; c45 = (sum(vk.*s45./deltak,2))./delta;
        c55 = (sum(vk.*s55./deltak,2))./delta; c46 = mean(s46);c56 = mean(s56);
    else
        c11 = s11;c22 = s22;c12 = s12;c13 = s13;c23 = s23;c33 = s33;c44 = s44;c55 = s55;
        c66 = s66;c14 = s14;c15 = s15;c16 = s16;c24 = s24;c25 = s25;c26 = s26;c34 = s34;
        c35 = s35;c36 = s36;c45 = s45;c46 = s46;c56 = s56;
    end
    c21 = c12;c31 = c13;c32 = c23;c41 = c14;c42 = c24;c43 = c34;c51 = c15;c52 = c25;
    c53 = c35;c54 = c45;c61 = c16;c62 = c26;c63 = c36;c64 = c46;c65 = c56;
else
    no_lay = length(lh)/length(unique(thicknessElementNo));
    s11tt = zeros(size(s11,1),no_lay);s12tt = zeros(size(s11,1),no_lay);
    s13tt = zeros(size(s11,1),no_lay);s14tt = zeros(size(s11,1),no_lay);
    s15tt = zeros(size(s11,1),no_lay);s16tt = zeros(size(s11,1),no_lay);
    s22tt = zeros(size(s11,1),no_lay);s23tt = zeros(size(s11,1),no_lay);
    s24tt = zeros(size(s11,1),no_lay);s25tt = zeros(size(s11,1),no_lay);
    s26tt = zeros(size(s11,1),no_lay);s33tt = zeros(size(s11,1),no_lay);
    s34tt = zeros(size(s11,1),no_lay);s35tt = zeros(size(s11,1),no_lay);
    s36tt = zeros(size(s11,1),no_lay);s44tt = zeros(size(s11,1),no_lay);
    s45tt = zeros(size(s11,1),no_lay);s55tt = zeros(size(s11,1),no_lay);
    s66tt = zeros(size(s11,1),no_lay);

    for  i = 1:length(unique(thicknessElementNo))
        rang = (1+no_lay*(i-1):no_lay*i);rang1 = rang(1);rang2 = rang(2:end);
        vk = lh(rang)/sum(lh(rang));vk = repmat(vk,size(s11,1),1);

        s33tt(i) = 1./sum(vk./s33(rang));lambda33 = s33tt(i);
        s13tt(i) = sum(vk.*s13(:,rang),2)+sum((s33(:,rang2)-lambda33).*vk(:,2:end).*...
    (s13(:,rang1)-s13(:,rang2))./s33(:,rang2),2);lambda13 = s13tt(i);
        s11tt(i) = sum(vk.*s11(:,rang),2)+sum((s13(:,rang2)-lambda13).*vk(:,2:end).*...
    (s13(:,rang1)-s13(:,rang2))./s33(:,rang2),2);
        s12tt(i) = sum(vk.*s12(:,rang),2)+sum((s13(:,rang2)-lambda13).*vk(:,2:end).*...
    (s23(:,rang1)-s23(:,rang2))./s33(:,rang2),2);
        s23tt(i) = sum(vk.*s23(:,rang),2)+sum((s33(:,rang2)-lambda33).*vk(:,2:end).*...
    (s23(:,rang1)-s23(:,rang2))./s33(:,rang2),2); lambda23 = s23tt(i);
        s22tt(i) = sum(vk.*s22(:,rang),2)+sum((s23(:,rang2)-lambda23).*vk(:,2:end).*...
    (s23(:,rang1)-s23(:,rang2))./s33(:,rang2),2);
        s16tt(i) = sum(vk.*s16(:,rang),2)+sum((s13(:,rang2)-lambda13).*vk(:,2:end).*...
    (s36(:,rang1)-s36(:,rang2))./s33(:,rang2),2);
        s26tt(i) = sum(vk.*s26(:,rang),2)+sum((s23(:,rang2)-lambda23).*vk(:,2:end).*...
    (s36(:,rang1)-s36(:,rang2))./s33(:,rang2),2);
        s36tt(i) = sum(vk.*s36(:,rang),2)+sum((s33(:,rang2)-lambda33).*vk(:,2:end).*...
    (s36(:,rang1)-s36(:,rang2))./s33(:,rang2),2); lambda36 = s36tt(i);
        s66tt(i) = sum(vk.*s66(:,rang),2)+sum((s36(:,rang2)-lambda36).*vk(:,2:end).*...
    (s36(:,rang1)-s36(:,rang2))./s33(:,rang2),2);
        s14tt(i) = sum(vk.*s14(:,rang),2)+sum((s13(:,rang2)-lambda13).*vk(:,2:end).*...
    (s34(:,rang1)-s34(:,rang2))./s33(:,rang2),2);
        s24tt(i) = sum(vk.*s24(:,rang),2)+sum((s23(:,rang2)-lambda23).*vk(:,2:end).*...
    (s34(:,rang1)-s34(:,rang2))./s33(:,rang2),2);
        s34tt(i) = sum(vk.*s34(:,rang),2)+sum((s33(:,rang2)-lambda33).*vk(:,2:end).*...
    (s34(:,rang1)-s34(:,rang2))./s33(:,rang2),2);
        s15tt(i) = sum(vk.*s15(:,rang),2)+sum((s13(:,rang2)-lambda13).*vk(:,2:end).*...
    (s35(:,rang1)-s35(:,rang2))./s33(:,rang2),2);
        s25tt(i) = sum(vk.*s25(:,rang),2)+sum((s23(:,rang2)-lambda23).*vk(:,2:end).*...
    (s35(:,rang1)-s35(:,rang2))./s33(:,rang2),2);
        s35tt(i) = sum(vk.*s35(:,rang),2)+sum((s33(:,rang2)-lambda33).*vk(:,2:end).*...
    (s35(:,rang1)-s35(:,rang2))./s33(:,rang2),2);
        deltak = s44(:,rang).*s55(:,rang)-s45(:,rang).^2;
        delta = sum(vk.*s44(:,rang)./deltak,2)*sum(vk.*s55(:,rang)./deltak,2)-...
    (sum(vk.*s45(:,rang)./deltak,2)).^2;
        s44tt(i) = (sum(vk.*s44(:,rang)./deltak,2))./delta;
        s45tt(i) = (sum(vk.*s45(:,rang)./deltak,2))./delta;
        s55tt(i) = (sum(vk.*s55(:,rang)./deltak,2))./delta;
    end  
    numberElements = structure_i.numberElements;  
    c11 = cell(numberElements,1);c12 = cell(numberElements,1);c13 = cell(numberElements,1);
    c14 = cell(numberElements,1);c15 = cell(numberElements,1);c16 = cell(numberElements,1);
    c22 = cell(numberElements,1);c23 = cell(numberElements,1);
    c24 = cell(numberElements,1);c25 = cell(numberElements,1);c26 = cell(numberElements,1);
    c33 = cell(numberElements,1);c34 = cell(numberElements,1);c35 = cell(numberElements,1);
    c36 = cell(numberElements,1);
    c44 = cell(numberElements,1);c45 = cell(numberElements,1);
    c55 = cell(numberElements,1);c66 = cell(numberElements,1);
    c46 = cell(numberElements,1);c56 = cell(numberElements,1);
    for i = 1:length(unique(thicknessElementNo))
        c11tt = s11tt(i)*ones(n^2*n_zeta,1);[c11{thicknessElementNo==i}] = deal(c11tt);
        c12tt = s12tt(i)*ones(n^2*n_zeta,1);[c12{thicknessElementNo==i}] = deal(c12tt);
        c13tt = s13tt(i)*ones(n^2*n_zeta,1);[c13{thicknessElementNo==i}] = deal(c13tt);
        c14tt = s14tt(i)*ones(n^2*n_zeta,1);[c14{thicknessElementNo==i}] = deal(c14tt);
        c15tt = s15tt(i)*ones(n^2*n_zeta,1);[c15{thicknessElementNo==i}] = deal(c15tt);
        c16tt = s16tt(i)*ones(n^2*n_zeta,1);[c16{thicknessElementNo==i}] = deal(c16tt);
        c22tt = s22tt(i)*ones(n^2*n_zeta,1);[c22{thicknessElementNo==i}] = deal(c22tt);
        c23tt = s23tt(i)*ones(n^2*n_zeta,1);[c23{thicknessElementNo==i}] = deal(c23tt);
        c24tt = s24tt(i)*ones(n^2*n_zeta,1);[c24{thicknessElementNo==i}] = deal(c24tt);
        c25tt = s25tt(i)*ones(n^2*n_zeta,1);[c25{thicknessElementNo==i}] = deal(c25tt);
        c26tt = s26tt(i)*ones(n^2*n_zeta,1);[c26{thicknessElementNo==i}] = deal(c26tt);
        c33tt = s33tt(i)*ones(n^2*n_zeta,1);[c33{thicknessElementNo==i}] = deal(c33tt);
        c34tt = s34tt(i)*ones(n^2*n_zeta,1);[c34{thicknessElementNo==i}] = deal(c34tt);
        c35tt = s35tt(i)*ones(n^2*n_zeta,1);[c35{thicknessElementNo==i}] = deal(c35tt);
        c36tt = s36tt(i)*ones(n^2*n_zeta,1);[c36{thicknessElementNo==i}] = deal(c36tt);
        c44tt = s44tt(i)*ones(n^2*n_zeta,1);[c44{thicknessElementNo==i}] = deal(c44tt);
        c45tt = s45tt(i)*ones(n^2*n_zeta,1);[c45{thicknessElementNo==i}] = deal(c45tt);
        c55tt = s55tt(i)*ones(n^2*n_zeta,1);[c55{thicknessElementNo==i}] = deal(c55tt);
        c66tt = s66tt(i)*ones(n^2*n_zeta,1);[c66{thicknessElementNo==i}] = deal(c66tt);
        c46tt = zeros(n^2*n_zeta,1);        [c46{thicknessElementNo==i}] = deal(c46tt);
        c56tt = zeros(n^2*n_zeta,1);        [c56{thicknessElementNo==i}] = deal(c56tt);
    end
c11 = cell2mat(c11);c12 = cell2mat(c12);c13 = cell2mat(c13);c14 = cell2mat(c14);
c15 = cell2mat(c15);c16 = cell2mat(c16);c22 = cell2mat(c22);c23 = cell2mat(c23);
c24 = cell2mat(c24);c25 = cell2mat(c25);c26 = cell2mat(c26);c33 = cell2mat(c33);
c34 = cell2mat(c34);c35 = cell2mat(c35);c36 = cell2mat(c36);c44 = cell2mat(c44);
c45 = cell2mat(c45);c55 = cell2mat(c55);c66 = cell2mat(c66);c46 = cell2mat(c46);
c56 = cell2mat(c56);
c21 = c12;c31 = c13;c41 = c14;c51 = c15;c61 = c16;c32 = c23;c42 = c24;c52 = c25;c62 = c26;
c43 = c34;c53 = c35;c63 = c36;c54 = c45;c64 = c46;c65 = c56;
end
rho  =  m11./h;
switch DOF
    case {5,6}
c11 = [];c12 = [];c13 = [];c14 = [];c15 = [];c16 = [];c21 = [];c22 = [];c23 = [];...
c24 = [];c25 = [];c26 = [];c31 = [];c32 = [];c33 = [];c34 = [];c35 = [];c36 = [];c41 = [];...
c42 = [];c43 = [];c44 = [];c45 = [];c46 = [];c51 = [];c52 = [];c53 = [];c54 = [];c55 = [];...
c56 = [];c61 = [];c62 = [];c63 = [];c64 = [];c65 = [];c66 = [];  
    case 3
a11 = [];a12 = [];a16 = [];a22 = [];a26 = [];a66 = [];a44_2d = [];a45_2d = [];a55_2d = [];...
b11 = [];b12 = [];b16 = [];b22 = [];b26 = [];b66 = [];d11 = [];d12 = [];d16 = [];d22 = [];...
d26 = [];d66 = []; 
end





