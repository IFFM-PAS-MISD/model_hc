function [Fku]=KU_NbN(Dof,Jacob_P11inv,Jacob_P12inv,Jacob_P21inv,...
    Jacob_P22inv,Jacob_P13inv,Jacob_P23inv,Jacob_P31inv,Jacob_P32inv,...
    Jacob_P33inv,shapeFunction_P,naturalDerivativesX_P,naturalDerivativesY_P,...
    naturalDerivativesZ_P,Ut_XP,Ut_YP,Ut_ZP,Ut_FXP,Ut_FYP,Ut_FZP,I_G,I_L,...
    numberNodes,w_P,c_xpx,c_xpy,c_xpz,c_ypx,c_ypy,c_ypz,c_zpx,c_zpy,c_zpz,...
    a11,a12,a16,a22,a26,a66,b11,b12,b16,b22,b26,b66,d11,d12,d16,d22,d26,...
    d66,a44_2d,a45_2d,a55_2d,c11,c12,c13,c14,c15,c16,c21,c22,c23,c24,c25,...
    c26,c31,c32,c33,c34,c35,c36,c41,c42,c43,c44,c45,c46,c51,c52,c53,c54,...
    c55,c56,c61,c62,c63,c64,c65,c66,rotation_angle)

switch Dof
    case 6
        if any(any(rotation_angle))  
            Ut_XP = c_xpx.*Ut_XP+c_xpy.*Ut_YP+c_xpz.*Ut_ZP;
            Ut_YP = c_ypx.*Ut_XP+c_ypy.*Ut_YP+c_ypz.*Ut_ZP;
            Ut_ZP = c_zpx.*Ut_XP+c_zpy.*Ut_YP+c_zpz.*Ut_ZP;
            Ut_FXP = c_xpx.*Ut_FXP+c_xpy.*Ut_FYP+c_xpz.*Ut_FZP;
            Ut_FYP = c_ypx.*Ut_FXP+c_ypy.*Ut_FYP+c_ypz.*Ut_FZP;
        end
        C11 = a11; C12 = a12; C13 = a16; C21 = a12; C22 = a22; C23 = a26;
        C31 = a16; C32 = a26; C33 = a66; C14 = b11; C15 = b12; C16 = b16;
        C24 = b12; C25 = b22; C26 = b26; C34 = b16; C35 = b26; C36 = b66;
        C41 = b11; C42 = b12; C43 = b16; C51 = b12; C52 = b22; C53 = b26;
        C61 = b16; C62 = b26; C63 = b66; C44 = d11; C45 = d12; C46 = d16;
        C54 = d12; C55 = d22; C56 = d26; C64 = d16; C65 = d26; C66 = d66;
        C_s11 = a44_2d; C_s12 = a45_2d;  C_s21 = a45_2d; C_s22 = a55_2d;

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

        C11 = a11; C12 = a12; C13 = a16; C21 = a12; C22 = a22; C23 = a26;
        C31 = a16; C32 = a26; C33 = a66; C14 = b11; C15 = b12; C16 = b16;
        C24 = b12; C25 = b22; C26 = b26; C34 = b16; C35 = b26; C36 = b66;
        C41 = b11; C42 = b12; C43 = b16; C51 = b12; C52 = b22; C53 = b26;
        C61 = b16; C62 = b26; C63 = b66; C44 = d11; C45 = d12; C46 = d16;
        C54 = d12; C55 = d22; C56 = d26; C64 = d16; C65 = d26; C66 = d66;
        C_s11 = a44_2d; C_s12 = a45_2d;  C_s21 = a45_2d; C_s22 = a55_2d;

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

        Fku_b1=naturalDerivativesX_P'*((sigma_b1.*Jacob_P11inv+sigma_b3.*Jacob_P21inv).*w_P)...
            +naturalDerivativesY_P'*((sigma_b1.*Jacob_P12inv+sigma_b3.*Jacob_P22inv).*w_P);
        Fku_b2=naturalDerivativesX_P'*((sigma_b2.*Jacob_P21inv+sigma_b3.*Jacob_P11inv).*w_P)...
            +naturalDerivativesY_P'*((sigma_b2.*Jacob_P22inv+sigma_b3.*Jacob_P12inv).*w_P);
        Fku_b3=0*sigma_b3.*w_P;
        Fku_b4=-naturalDerivativesX_P'*((sigma_b4.*Jacob_P11inv+sigma_b6.*Jacob_P21inv).*w_P)-...
            naturalDerivativesY_P'*((sigma_b4.*Jacob_P12inv+sigma_b6.*Jacob_P22inv).*w_P);
        Fku_b5=-naturalDerivativesX_P'*((sigma_b5.*Jacob_P21inv+sigma_b6.*Jacob_P11inv).*w_P)-...
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
        C11=c11;C12=c12;C13=c13;C14=c14;
        C15=c15;C16=c16;C21=c21;C22=c22;
        C23=c23;C24=c24;C25=c25;C26=c26;
        C31=c31;C32=c32;C33=c33;C34=c34;
        C35=c35;C36=c36;C41=c41;C42=c42;
        C43=c43;C44=c44;C45=c45;C46=c46;
        C51=c51;C52=c52;C53=c53;C54=c54;
        C55=c55;C56=c56;C61=c61;C62=c62;
        C63=c63;C64=c64;C65=c65;C66=c66;

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





