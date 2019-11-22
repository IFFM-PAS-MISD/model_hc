function [Fku]=KU_NbN(structure_i,Ut_XP,Ut_YP,Ut_ZP,Ut_FXP,Ut_FYP,Ut_FZP)
%structure_i=structure(i);
Dof = structure_i.DOF(1);
Jacob_P11inv = structure_i.Jacob_P11inv;Jacob_P12inv = structure_i.Jacob_P12inv;
Jacob_P21inv = structure_i.Jacob_P21inv;Jacob_P22inv = structure_i.Jacob_P22inv;
Jacob_P13inv = structure_i.Jacob_P13inv;Jacob_P23inv = structure_i.Jacob_P23inv;
Jacob_P31inv = structure_i.Jacob_P31inv;Jacob_P32inv = structure_i.Jacob_P32inv;
Jacob_P33inv = structure_i.Jacob_P33inv;
shapeFunction_P = structure_i.shapeFunction_P;
naturalDerivativesX_P = structure_i.naturalDerivativesX_P;
naturalDerivativesY_P = structure_i.naturalDerivativesY_P;
naturalDerivativesZ_P = structure_i.naturalDerivativesZ_P;
I_G = structure_i.I_G;I_L = structure_i.I_L;
numberNodes = size(structure_i.nodeCoordinates,1);
w_P = structure_i.w_P;
rotation_angle = structure_i.rotation_angle;

switch Dof
    case 6

        if any(any(rotation_angle))  
            c_xpx = structure_i.c_xpx;c_xpy = structure_i.c_xpy;c_xpz = structure_i.c_xpz;
            c_ypx = structure_i.c_ypx;c_ypy = structure_i.c_ypy;c_ypz = structure_i.c_ypz;
            c_zpx = structure_i.c_zpx;c_zpy = structure_i.c_zpy;c_zpz = structure_i.c_zpz;
            
            Ut_XP_l = c_xpx.*Ut_XP + c_xpy.*Ut_YP + c_xpz.*Ut_ZP;
            Ut_YP_l = c_ypx.*Ut_XP + c_ypy.*Ut_YP + c_ypz.*Ut_ZP;
            Ut_ZP_l = c_zpx.*Ut_XP + c_zpy.*Ut_YP + c_zpz.*Ut_ZP;
            
            Ut_FXP_l = c_xpx.*Ut_FXP + c_xpy.*Ut_FYP + c_xpz.*Ut_FZP;
            Ut_FYP_l = c_ypx.*Ut_FXP + c_ypy.*Ut_FYP + c_ypz.*Ut_FZP;
        end

        C11 = structure_i.a11; C12 = structure_i.a12; C13 = structure_i.a16;
        C21 = structure_i.a12; C22 = structure_i.a22; C23 = structure_i.a26;
        C31 = structure_i.a16; C32 = structure_i.a26; C33 = structure_i.a66;
        C14 = structure_i.b11; C15 = structure_i.b12; C16 = structure_i.b16;
        C24 = structure_i.b12; C25 = structure_i.b22; C26 = structure_i.b26;
        C34 = structure_i.b16; C35 = structure_i.b26; C36 = structure_i.b66;
        C41 = structure_i.b11; C42 = structure_i.b12; C43 = structure_i.b16;
        C51 = structure_i.b12; C52 = structure_i.b22; C53 = structure_i.b26;
        C61 = structure_i.b16; C62 = structure_i.b26; C63 = structure_i.b66;
        C44 = structure_i.d11; C45 = structure_i.d12; C46 = structure_i.d16;
        C54 = structure_i.d12; C55 = structure_i.d22; C56 = structure_i.d26;
        C64 = structure_i.d16; C65 = structure_i.d26; C66 = structure_i.d66;
        C_s11 = structure_i.a44_2d; C_s12 = structure_i.a45_2d;
        C_s21 = structure_i.a45_2d; C_s22 = structure_i.a55_2d;

        eps_b1=(naturalDerivativesX_P*Ut_XP_l).*Jacob_P11inv+...
            (naturalDerivativesY_P*Ut_XP_l).*Jacob_P12inv;
        eps_b2=(naturalDerivativesX_P*Ut_YP_l).*Jacob_P21inv+...
            (naturalDerivativesY_P*Ut_YP_l).*Jacob_P22inv;
        eps_b3=(naturalDerivativesX_P*Ut_XP_l).*Jacob_P21inv+...
            (naturalDerivativesY_P*Ut_XP_l).*Jacob_P22inv+...
            (naturalDerivativesX_P*Ut_YP_l).*Jacob_P11inv+...
            (naturalDerivativesY_P*Ut_YP_l).*Jacob_P12inv;
        eps_b4=-(naturalDerivativesX_P*Ut_FXP_l).*Jacob_P11inv-...
            (naturalDerivativesY_P*Ut_FXP_l).*Jacob_P12inv;
        eps_b5=-(naturalDerivativesX_P*Ut_FYP_l).*Jacob_P21inv-...
            (naturalDerivativesY_P*Ut_FYP_l).*Jacob_P22inv;
        eps_b6=-(naturalDerivativesX_P*Ut_FXP_l).*Jacob_P21inv-...
            (naturalDerivativesY_P*Ut_FXP_l).*Jacob_P22inv-...
            (naturalDerivativesX_P*Ut_FYP_l).*Jacob_P11inv-...
            (naturalDerivativesY_P*Ut_FYP_l).*Jacob_P12inv;
            
        sigma_b1=C11.*eps_b1+C12.*eps_b2+C13.*eps_b3+C14.*eps_b4+C15.*eps_b5+C16.*eps_b6;
        sigma_b2=C21.*eps_b1+C22.*eps_b2+C23.*eps_b3+C24.*eps_b4+C25.*eps_b5+C26.*eps_b6;
        sigma_b3=C31.*eps_b1+C32.*eps_b2+C33.*eps_b3+C34.*eps_b4+C35.*eps_b5+C36.*eps_b6;
        sigma_b4=C41.*eps_b1+C42.*eps_b2+C43.*eps_b3+C44.*eps_b4+C45.*eps_b5+C46.*eps_b6;
        sigma_b5=C51.*eps_b1+C52.*eps_b2+C53.*eps_b3+C54.*eps_b4+C55.*eps_b5+C56.*eps_b6;
        sigma_b6=C61.*eps_b1+C62.*eps_b2+C63.*eps_b3+C64.*eps_b4+C65.*eps_b5+C66.*eps_b6;


        eps_s1=(naturalDerivativesX_P*Ut_ZP_l).*Jacob_P11inv+...
            (naturalDerivativesY_P*Ut_ZP_l).*Jacob_P12inv-...
            shapeFunction_P*Ut_FXP_l;
        eps_s2=(naturalDerivativesX_P*Ut_ZP_l).*Jacob_P21inv+...
            (naturalDerivativesY_P*Ut_ZP_l).*Jacob_P22inv-...
            shapeFunction_P*Ut_FYP_l;
        sigma_s1=C_s11.*eps_s1+C_s12.*eps_s2;
        sigma_s2=C_s21.*eps_s1+C_s22.*eps_s2;

        Fku_b1=naturalDerivativesX_P'*((sigma_b1.*Jacob_P11inv+sigma_b3.*Jacob_P21inv).*w_P)...
            +naturalDerivativesY_P'*((sigma_b1.*Jacob_P12inv+sigma_b3.*Jacob_P22inv).*w_P);
        Fku_b2=naturalDerivativesX_P'*((sigma_b2.*Jacob_P21inv+sigma_b3.*Jacob_P11inv).*w_P)...
            +naturalDerivativesY_P'*((sigma_b2.*Jacob_P22inv+sigma_b3.*Jacob_P12inv).*w_P);
        Fku_b3=0*sigma_b3.*w_P;
        Fku_b4=-naturalDerivativesX_P'*((sigma_b4.*Jacob_P11inv+sigma_b6.*Jacob_P21inv).*w_P)-...
            naturalDerivativesY_P'*((sigma_b4.*Jacob_P12inv+sigma_b6.*Jacob_P22inv).*w_P);
        Fku_b5=-naturalDerivativesX_P'*((sigma_b5.*Jacob_P21inv+sigma_b6.*Jacob_P11inv).*w_P)-...
            naturalDerivativesY_P'*((sigma_b5.*Jacob_P22inv+sigma_b6.*Jacob_P12inv).*w_P);

        Fku_s1=0*sigma_s1.*w_P; Fku_s2=0*sigma_s2.*w_P;
        Fku_s3=naturalDerivativesX_P'*((sigma_s1.*Jacob_P11inv+sigma_s2.*Jacob_P21inv).*w_P)...
            +naturalDerivativesY_P'*((sigma_s1.*Jacob_P12inv+sigma_s2.*Jacob_P22inv).*w_P);
        Fku_s4=-shapeFunction_P'*sigma_s1.*w_P; Fku_s5=-shapeFunction_P'*sigma_s2.*w_P;
        
        Fku_P1=Fku_b1+Fku_s1; Fku_P2=Fku_b2+Fku_s2; Fku_P3=Fku_b3+Fku_s3;
        Fku_P4=Fku_b4+Fku_s4; Fku_P5=Fku_b5+Fku_s5; Fku_P6=0*Fku_P5;
        if any(any(rotation_angle))
            Fku_P1_g=c_xpx.*Fku_P1+c_ypx.*Fku_P2+c_zpx.*Fku_P3;
            Fku_P2_g=c_xpy.*Fku_P1+c_ypy.*Fku_P2+c_zpy.*Fku_P3;
            Fku_P3_g=c_xpz.*Fku_P1+c_ypz.*Fku_P2+c_zpz.*Fku_P3;

            Fku_P4_g=c_xpx.*Fku_P4+c_ypx.*Fku_P5+c_zpx.*Fku_P6;
            Fku_P5_g=c_xpy.*Fku_P4+c_ypy.*Fku_P5+c_zpy.*Fku_P6;
            Fku_P6_g=c_xpz.*Fku_P4+c_ypz.*Fku_P5+c_zpz.*Fku_P6;
        else
            Fku_P1_g=Fku_P1; Fku_P2_g=Fku_P2; Fku_P3_g=Fku_P3;
    
            Fku_P4_g=Fku_P4; Fku_P5_g=Fku_P5; Fku_P6_g=Fku_P6;    
        end

        Fku_1=zeros(numberNodes,1); Fku_2=zeros(numberNodes,1);
        Fku_3=zeros(numberNodes,1); Fku_4=zeros(numberNodes,1);
        Fku_5=zeros(numberNodes,1); Fku_6=zeros(numberNodes,1);

        for i=1:12
            Fku_1(I_G(:,i))=Fku_1(I_G(:,i))+Fku_P1_g(I_L(:,i),1);
            Fku_2(I_G(:,i))=Fku_2(I_G(:,i))+Fku_P2_g(I_L(:,i),1);
            Fku_3(I_G(:,i))=Fku_3(I_G(:,i))+Fku_P3_g(I_L(:,i),1);
            Fku_4(I_G(:,i))=Fku_4(I_G(:,i))+Fku_P4_g(I_L(:,i),1);
            Fku_5(I_G(:,i))=Fku_5(I_G(:,i))+Fku_P5_g(I_L(:,i),1);
            Fku_6(I_G(:,i))=Fku_6(I_G(:,i))+Fku_P6_g(I_L(:,i),1);
        end

        Fku=[Fku_1;Fku_2;Fku_3;Fku_4;Fku_5;Fku_6];
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 5

        C11=structure_i.a11;C12=structure_i.a12;C13=structure_i.a16;
        C21=structure_i.a12;C22=structure_i.a22;C23=structure_i.a26;
        C31=structure_i.a16;C32=structure_i.a26;C33=structure_i.a66;
    
        C14=structure_i.b11;C15=structure_i.b12;C16=structure_i.b16;
        C24=structure_i.b12;C25=structure_i.b22;C26=structure_i.b26;
        C34=structure_i.b16;C35=structure_i.b26;C36=structure_i.b66;

        C41=structure_i.b11;C42=structure_i.b12;C43=structure_i.b16;
        C51=structure_i.b12;C52=structure_i.b22;C53=structure_i.b26;
        C61=structure_i.b16;C62=structure_i.b26;C63=structure_i.b66;

        C44=structure_i.d11;C45=structure_i.d12;C46=structure_i.d16;
        C54=structure_i.d12;C55=structure_i.d22;C56=structure_i.d26;
        C64=structure_i.d16;C65=structure_i.d26;C66=structure_i.d66;

        C_s11=structure_i.a44_2d;C_s12=structure_i.a45_2d;
        C_s21=structure_i.a45_2d;C_s22=structure_i.a55_2d;

        eps_b1=(naturalDerivativesX_P*Ut_XP).*Jacob_P11inv+...
            (naturalDerivativesY_P*Ut_XP).*Jacob_P12inv;
        eps_b2=(naturalDerivativesX_P*Ut_YP).*Jacob_P21inv+...
            (naturalDerivativesY_P*Ut_YP).*Jacob_P22inv;
        eps_b3=(naturalDerivativesX_P*Ut_XP).*Jacob_P21inv+...
            (naturalDerivativesY_P*Ut_XP).*Jacob_P22inv+...
            (naturalDerivativesX_P*Ut_YP).*Jacob_P11inv+...
            (naturalDerivativesY_P*Ut_YP).*Jacob_P12inv;
        eps_b4=-(naturalDerivativesX_P*Ut_FXP).*Jacob_P11inv-...
            (naturalDerivativesY_P*Ut_FXP).*Jacob_P12inv;
        eps_b5=-(naturalDerivativesX_P*Ut_FYP).*Jacob_P21inv-...
            (naturalDerivativesY_P*Ut_FYP).*Jacob_P22inv;
        eps_b6=-(naturalDerivativesX_P*Ut_FXP).*Jacob_P21inv-...
            (naturalDerivativesY_P*Ut_FXP).*Jacob_P22inv-...
            (naturalDerivativesX_P*Ut_FYP).*Jacob_P11inv-...
            (naturalDerivativesY_P*Ut_FYP).*Jacob_P12inv;

        sigma_b1=C11.*eps_b1+C12.*eps_b2+C13.*eps_b3+C14.*eps_b4+C15.*eps_b5+C16.*eps_b6;
        sigma_b2=C21.*eps_b1+C22.*eps_b2+C23.*eps_b3+C24.*eps_b4+C25.*eps_b5+C26.*eps_b6;
        sigma_b3=C31.*eps_b1+C32.*eps_b2+C33.*eps_b3+C34.*eps_b4+C35.*eps_b5+C36.*eps_b6;
        sigma_b4=C41.*eps_b1+C42.*eps_b2+C43.*eps_b3+C44.*eps_b4+C45.*eps_b5+C46.*eps_b6;
        sigma_b5=C51.*eps_b1+C52.*eps_b2+C53.*eps_b3+C54.*eps_b4+C55.*eps_b5+C56.*eps_b6;
        sigma_b6=C61.*eps_b1+C62.*eps_b2+C63.*eps_b3+C64.*eps_b4+C65.*eps_b5+C66.*eps_b6;


        eps_s1=(naturalDerivativesX_P*Ut_ZP).*Jacob_P11inv+...
            (naturalDerivativesY_P*Ut_ZP).*Jacob_P12inv-...
            shapeFunction_P*Ut_FXP;
        eps_s2=(naturalDerivativesX_P*Ut_ZP).*Jacob_P21inv+...
            (naturalDerivativesY_P*Ut_ZP).*Jacob_P22inv-...
            shapeFunction_P*Ut_FYP;
        sigma_s1=C_s11.*eps_s1+C_s12.*eps_s2;
        sigma_s2=C_s21.*eps_s1+C_s22.*eps_s2;
        clear C11 C12 C13 C21 C22 C23 C31 C32 C33 C14 C15 C16 C24 C25 C26 C34
        clear C35 C36 C41 C42 C43 C51 C52 C53 C61 C62 C63 C44 C45 C46 C54 C55
        clear C56 C64 C65 C66 C_s11 C_s12 C_s21 C_s22
        clear eps_b1 eps_b2 eps_b3 eps_b4 eps_b5 eps_b6 eps_s1 eps_s2

        Fku_b1 = naturalDerivativesX_P'*((sigma_b1.*Jacob_P11inv+sigma_b3.*Jacob_P21inv).*w_P)+...
            naturalDerivativesY_P'*((sigma_b1.*Jacob_P12inv+sigma_b3.*Jacob_P22inv).*w_P);
        Fku_b2 = naturalDerivativesX_P'*((sigma_b2.*Jacob_P21inv+sigma_b3.*Jacob_P11inv).*w_P)+...
            naturalDerivativesY_P'*((sigma_b2.*Jacob_P22inv+sigma_b3.*Jacob_P12inv).*w_P);
        Fku_b3 = 0*sigma_b3.*w_P;
        Fku_b4 = -naturalDerivativesX_P'*((sigma_b4.*Jacob_P11inv+sigma_b6.*Jacob_P21inv).*w_P)-...
            naturalDerivativesY_P'*((sigma_b4.*Jacob_P12inv+sigma_b6.*Jacob_P22inv).*w_P);
        Fku_b5 = -naturalDerivativesX_P'*((sigma_b5.*Jacob_P21inv+sigma_b6.*Jacob_P11inv).*w_P)-...
            naturalDerivativesY_P'*((sigma_b5.*Jacob_P22inv+sigma_b6.*Jacob_P12inv).*w_P);

        Fku_s3=naturalDerivativesX_P'*((sigma_s1.*Jacob_P11inv+sigma_s2.*Jacob_P21inv).*w_P)...
            +naturalDerivativesY_P'*((sigma_s1.*Jacob_P12inv+sigma_s2.*Jacob_P22inv).*w_P);
        Fku_s4=-shapeFunction_P'*sigma_s1.*w_P;
        Fku_s5=-shapeFunction_P'*sigma_s2.*w_P;

        Fku_P1=Fku_b1; Fku_P2=Fku_b2; Fku_P3=Fku_b3+Fku_s3;
        Fku_P4=Fku_b4+Fku_s4; Fku_P5=Fku_b5+Fku_s5;

        Fku_1=zeros(numberNodes,1);Fku_2=zeros(numberNodes,1);
        Fku_3=zeros(numberNodes,1);Fku_4=zeros(numberNodes,1);
        Fku_5=zeros(numberNodes,1);


        for i=1:12
            Fku_1(I_G(:,i))=Fku_1(I_G(:,i))+Fku_P1(I_L(:,i),1);
            Fku_2(I_G(:,i))=Fku_2(I_G(:,i))+Fku_P2(I_L(:,i),1);
            Fku_3(I_G(:,i))=Fku_3(I_G(:,i))+Fku_P3(I_L(:,i),1);
            Fku_4(I_G(:,i))=Fku_4(I_G(:,i))+Fku_P4(I_L(:,i),1);
            Fku_5(I_G(:,i))=Fku_5(I_G(:,i))+Fku_P5(I_L(:,i),1);
        end
        Fku=[Fku_1;Fku_2;Fku_3;Fku_4;Fku_5];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    case 3
        C11=structure_i.c11;C12=structure_i.c12;C13=structure_i.c13;C14=structure_i.c14;
        C15=structure_i.c15;C16=structure_i.c16;C21=structure_i.c21;C22=structure_i.c22;
        C23=structure_i.c23;C24=structure_i.c24;C25=structure_i.c25;C26=structure_i.c26;
        C31=structure_i.c31;C32=structure_i.c32;C33=structure_i.c33;C34=structure_i.c34;
        C35=structure_i.c35;C36=structure_i.c36;C41=structure_i.c41;C42=structure_i.c42;
        C43=structure_i.c43;C44=structure_i.c44;C45=structure_i.c45;C46=structure_i.c46;
        C51=structure_i.c51;C52=structure_i.c52;C53=structure_i.c53;C54=structure_i.c54;
        C55=structure_i.c55;C56=structure_i.c56;C61=structure_i.c61;C62=structure_i.c62;
        C63=structure_i.c63;C64=structure_i.c64;C65=structure_i.c65;C66=structure_i.c66;

        ndX_P_uXP=naturalDerivativesX_P*Ut_XP;ndX_P_uYP=naturalDerivativesX_P*Ut_YP;
        ndX_P_uZP=naturalDerivativesX_P*Ut_ZP;ndY_P_uXP=naturalDerivativesY_P*Ut_XP;
        ndY_P_uYP=naturalDerivativesY_P*Ut_YP;ndY_P_uZP=naturalDerivativesY_P*Ut_ZP;

        ndZ_P_uXP=naturalDerivativesZ_P*Ut_XP;ndZ_P_uYP=naturalDerivativesZ_P*Ut_YP;
        ndZ_P_uZP=naturalDerivativesZ_P*Ut_ZP;
        eps_1=ndX_P_uXP.*Jacob_P11inv+ndY_P_uXP.*Jacob_P12inv+ndZ_P_uXP.*Jacob_P13inv;
        eps_2=ndX_P_uYP.*Jacob_P21inv+ndY_P_uYP.*Jacob_P22inv+ndZ_P_uYP.*Jacob_P23inv;
        eps_3=ndX_P_uZP.*Jacob_P31inv+ndY_P_uZP.*Jacob_P32inv+ndZ_P_uZP.*Jacob_P33inv;
        eps_4=ndX_P_uYP.*Jacob_P31inv+ndY_P_uYP.*Jacob_P32inv+ndZ_P_uYP.*Jacob_P33inv+...
            ndX_P_uZP.*Jacob_P21inv+ndY_P_uZP.*Jacob_P22inv+ndZ_P_uZP.*Jacob_P23inv;
        eps_5=ndX_P_uXP.*Jacob_P31inv+ndY_P_uXP.*Jacob_P32inv+ndZ_P_uXP.*Jacob_P33inv+...
            ndX_P_uZP.*Jacob_P11inv+ndY_P_uZP.*Jacob_P12inv+ndZ_P_uZP.*Jacob_P13inv;
        eps_6=ndX_P_uXP.*Jacob_P21inv+ndY_P_uXP.*Jacob_P22inv+ndZ_P_uXP.*Jacob_P23inv+...
            ndX_P_uYP.*Jacob_P11inv+ndY_P_uYP.*Jacob_P12inv+ndZ_P_uYP.*Jacob_P13inv;

        sigma_1=C11.*eps_1+C12.*eps_2+C13.*eps_3+C14.*eps_4+C15.*eps_5+C16.*eps_6;
        sigma_2=C21.*eps_1+C22.*eps_2+C23.*eps_3+C24.*eps_4+C25.*eps_5+C26.*eps_6;
        sigma_3=C31.*eps_1+C32.*eps_2+C33.*eps_3+C34.*eps_4+C35.*eps_5+C36.*eps_6;
        sigma_4=C41.*eps_1+C42.*eps_2+C43.*eps_3+C44.*eps_4+C45.*eps_5+C46.*eps_6;
        sigma_5=C51.*eps_1+C52.*eps_2+C53.*eps_3+C54.*eps_4+C55.*eps_5+C56.*eps_6;
        sigma_6=C61.*eps_1+C62.*eps_2+C63.*eps_3+C64.*eps_4+C65.*eps_5+C66.*eps_6; 

        Fku_P1=naturalDerivativesX_P'*((sigma_1.*Jacob_P11inv+sigma_5.*Jacob_P31inv+sigma_6.*Jacob_P21inv).*w_P)+...
            naturalDerivativesY_P'*((sigma_1.*Jacob_P12inv+sigma_5.*Jacob_P32inv+sigma_6.*Jacob_P22inv).*w_P)+...
            naturalDerivativesZ_P'*((sigma_1.*Jacob_P13inv+sigma_5.*Jacob_P33inv+sigma_6.*Jacob_P23inv).*w_P);
        Fku_P2=naturalDerivativesX_P'*((sigma_2.*Jacob_P21inv+sigma_4.*Jacob_P31inv+sigma_6.*Jacob_P11inv).*w_P)+...
            naturalDerivativesY_P'*((sigma_2.*Jacob_P22inv+sigma_4.*Jacob_P32inv+sigma_6.*Jacob_P12inv).*w_P)+...
            naturalDerivativesZ_P'*((sigma_2.*Jacob_P23inv+sigma_4.*Jacob_P33inv+sigma_6.*Jacob_P13inv).*w_P);
        Fku_P3=naturalDerivativesX_P'*((sigma_3.*Jacob_P31inv+sigma_4.*Jacob_P21inv+sigma_5.*Jacob_P11inv).*w_P)+...
            naturalDerivativesY_P'*((sigma_3.*Jacob_P32inv+sigma_4.*Jacob_P22inv+sigma_5.*Jacob_P12inv).*w_P)+...
            naturalDerivativesZ_P'*((sigma_3.*Jacob_P33inv+sigma_4.*Jacob_P23inv+sigma_5.*Jacob_P13inv).*w_P);

        Fku_1=zeros(numberNodes,1);Fku_2=zeros(numberNodes,1);Fku_3=zeros(numberNodes,1);
        for i=1:12
            Fku_1(I_G(:,i))=Fku_1(I_G(:,i))+Fku_P1(I_L(:,i),1);
            Fku_2(I_G(:,i))=Fku_2(I_G(:,i))+Fku_P2(I_L(:,i),1);
            Fku_3(I_G(:,i))=Fku_3(I_G(:,i))+Fku_P3(I_L(:,i),1);
        end 
        Fku=[Fku_1;Fku_2;Fku_3]; 
end





