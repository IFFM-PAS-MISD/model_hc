%% impedance
addpath(genpath(pwd))
clear all; 

%%
clc
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
case_no = 8; k = case_no-7;
norm_in = 0;  % 0 not-normalized; 1 normalized
sensorNo = 4;
name_project = 'aditya';
parentFolder = 'E:\SEM_files';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fileName = [name_project,'_',num2str(case_no),'.mat'];
filePath = fullfile(parentFolder,'src','models',name_project,...
           'input','stiffness',fileName);
disp('Load structure from file....')
load(filePath, 'structure','excit_sh','ts','nr_exsh','N_f','f_0','f_1','parentFolder',...
    'name_project','case_name','output_result');
disp('Load structure from file....done')

%fr = [1e3,700e3,3000e3;250e3,750e3,1e6];
%f_min = fr(1,1);%f_2-5e3;%
%f_max = fr(2,2);%f_1;%f_2+5e3;%;f_1;%
f_min = f_0;
f_max = f_1;

c_n = 2; col_lin = ['g';'b';'c';'k';'b';'r'];

filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
          'output',num2str(case_no),'charge','q');
load(filePath, 'q')
NFFT = 2^nextpow2(N_f);
T = ts*N_f;         % calculation period [s]
Fs = 1/ts;           % sampling frequency
t_e = (0:N_f-1)*ts;      % time vector
f = (0:NFFT/2)*Fs/NFFT;

Vf = fft(excit_sh,NFFT);
Qf = fft(q{sensorNo},NFFT);

If = 1j*2.*pi.*f.*Qf(1:NFFT/2+1);
% impedance Z=R+jX; R-resistance, X-reactance
Z = Vf(1:NFFT/2+1)./If(1:NFFT/2+1);
% admittance Y=G+jB; ,G-conductance, B-susceptance
Y = If(1:NFFT/2+1)./Vf(1:NFFT/2+1);
%
f_range = f(f>=f_min&f<=f_max);
Z_range = Z((f>=f_min&f<=f_max));
Y_range = Y((f>=f_min&f<=f_max));

maxZ = [1 max(real(Z_range))];
maxY = [1 max(real(Y_range))];
maxZ_A = [1 max(real(Z_A))];
maxY_A = [1 max(real(Y_A))];

figure(1)
%plot(f_A*1e-3,real(Z_A)/maxZ_A(norm_in+1),'r')
hold on
plot(f_range*1e-3,real(Z_range)/maxZ(norm_in+1),col_lin(k))
xlabel('frequency [kHz]')
ylabel('impedance [-]')

figure(2)
%plot(f_A*1e-3,real(Y_A)/maxY_A(norm_in+1),'r')
hold on
plot(f_range*1e-3,real(Y_range)/maxY(norm_in+1),col_lin(k))
xlabel('frequency [kHz]')
ylabel('admittance [-]')
%%
figure(1)
legend('Ref','RFC11','RFC12','RFC13','Ref_1')
figure(2)
legend('Ref','RFC11','RFC12','RFC13','Ref_1')
% Rs_alu=smoothRs;
% save('Rs_alu.mat','Rs_alu','f_range')

% folder_name=['E:\SEM_files\',name_project,'\Experimental_data\'];
% file_name=[folder_name 'exp_CFRP_1.mat'];
% load(file_name,'G','Rs','f_exp')
if  no_pl==1
    maxRe=[1 max(Rs((f_exp>=min(f_range)&f_exp<=f_max)))];
plot((f_exp(f_exp>=min(f_range)&f_exp<=f_max))*1e-3,Rs((f_exp>=...
    min(f_range)&f_exp<=f_max))/maxRe(norm_in+1),'b')
title('Amplitude Spectrum of piezoelectric resistance(w)')
elseif no_pl==2
    maxRe=[1;max(Rs2((f_exp2>=min(f_range)&f_exp2<=f_max)))];
plot(f_exp2(f_exp2>=min(f_range)&f_exp2<=f_max)*1e-3,Rs2((f_exp2>=...
    min(f_range)&f_exp2<=f_max))/maxRe(norm_in+1),'c')
elseif no_pl==3
Y_expP=XRRE1p+1j*YRRE1p;
Z_expP=1./Y_expP;
norm_valE=[1;max(real(Z_expP((f_expP>=min(f_range)&f_expP<=f_max))))];
plot(f_expP(f_expP>=min(f_range)&f_expP<=f_max)*1e-3,real(Z_expP((f_expP>=...
    min(f_range)&f_expP<=f_max)))/norm_valE(norm_in+1),'m')
end
xlabel('Frequency (kHz)')
ylabel('|Rs(w))| [ohm]') 
%legend('Numerical','Experimental')
%legend('Numerical(2xCFRP)','Experimental(2xCFRP)','Numerical(2xCFRP with weak bonds)')
%axis([0 1000 0 1000])


% G_alu=smoothG;
% save('G_alu.mat','G_alu','f_range')
if  no_pl==1
    norm_val=[1;max(G((f_exp>=min(f_range)&f_exp<=f_max)))];
plot(f_exp(f_exp>=min(f_range)&f_exp<=f_max)*1e-3,G((f_exp>=...
    min(f_range)&f_exp<=f_max))/norm_val(norm_in+1),'b')
elseif no_pl==2
    norm_val=[1;max(G2((f_exp2>=min(f_range)&f_exp2<=f_max)))];
plot(f_exp2(f_exp2>=min(f_range)&f_exp2<=f_max)*1e-3,G2((f_exp2>=...
    min(f_range)&f_exp2<=f_max))/norm_val(norm_in+1),'b')
elseif no_pl==3
    norm_val=[1;max(XRRE1p((f_expP>=min(f_range)&f_expP<=f_max)))];
plot(f_expP(f_expP>=min(f_range)&f_expP<=f_max)*1e-3,XRRE1p((f_expP>=...
    min(f_range)&f_expP<=f_max))/norm_val(norm_in+1),'b')
end
title('Amplitude Spectrum of piezoelectric conductance(w)')
xlabel('Frequency (kHz)')
ylabel('(G(w)) [S]')
%legend('Numerical','Experimental')
%RMS=sqrt(sum(smoothG.^2)/size(smoothG,2));

%B_sem=((-(imag(Y_range))));
%smoothB=smooth(B_sem,5);
%figure(3)
%hold on
%semilogy(f_range*1e-3,smoothB/1,col_lin(C1))
%title('Amplitude Spectrum of piezoelectric susceptance(w)')
%xlabel('Frequency (kHz)')
%ylabel('(B(w)) [S]')


%   disp(no_pl)
%   if inputNumber==710
%       Rs_0=smoothRs;
%       G_0=smoothG;
% sigma_0Rs=sqrt(sum((Rs_0-sum(Rs_0)/length(Rs_0)).^2)./(length(Rs_0)-1));
%   end
%  
%      RMS_Rs=sqrt(sum(smoothRs).^2/length(smoothRs));
%      RMS_G=sqrt(sum(smoothG).^2/length(smoothG));
%      sigma_Rs=sqrt(sum((smoothRs-sum(smoothRs)/length(smoothRs)).^2)./...
%          (length(smoothRs)-1));
%      CC=sum(((smoothRs-sum(smoothRs)/length(smoothRs))-...
%          (Rs_0-sum(Rs_0)/length(Rs_0)))/sigma_Rs/sigma_0Rs)/length(smoothRs);
%      CCD=1-CC;
%      MAPD_R=sum(abs((smoothRs-Rs_0)./Rs_0));
%      MAPD_G=sum(abs((smoothG-G_0)./G_0));
%      
% 
%     RMSD_R=sqrt(sum((smoothRs-Rs_0).^2)./sum(Rs_0.^2));
%     RMSD_G=sqrt(sum((smoothG-G_0).^2)./sum(G_0.^2));    
%    disp(' ')
%    disp(['Input number ', num2str(inputNumber)])
%    disp(['Frequency range ',num2str(f_min/1000),'-',num2str(f_max/1000),' kHz'])
%     disp('         RMSD')
%     disp('      Rs         G')
%     disp([RMSD_R RMSD_G])
%    disp('         MAPD')
%    disp('      Rs         G')
%    disp([MAPD_R MAPD_G])
% end
%%

if  no_pl==1
    Rs1_cal=smoothRs;
    G1_cal=smoothG;
    Rs1_exp= interp1(f_exp,Rs,f_range,'spline');
    G1_exp = interp1(f_exp,G,f_range,'spline');
    
    RMS_Rs1=sqrt(sum(smoothRs.^2)/length(smoothRs));
    RMS_G1=sqrt(sum(smoothG.^2)/length(smoothG));
    RMS_Rs1_exp=sqrt(sum(Rs(f_exp>=min(f_range)&f_exp<=f_max).^2)/...
        length(Rs(f_exp>=min(f_range)&f_exp<=f_max)));
    RMS_G1_exp=sqrt(sum(G(f_exp>=min(f_range)&f_exp<=f_max).^2)/...
        length(G(f_exp>=min(f_range)&f_exp<=f_max)));
    disp([RMS_Rs1 RMS_G1; RMS_Rs1_exp RMS_G1_exp])
elseif no_pl==2
    
   
   
    
    Rs2_cal=smoothRs;
    G2_cal=smoothG;
    Rs2_exp= interp1(f_exp2,Rs2,f_range,'spline');
    G2_exp = interp1(f_exp2,G2,f_range,'spline');
    
    RMS_Rs2=sqrt(sum(smoothRs.^2)/length(smoothRs));
    RMS_G2=sqrt(sum(smoothG.^2)/length(smoothG));
    RMS_Rs2_exp=sqrt(sum(Rs2(f_exp2>=min(f_range)&f_exp2<=f_max).^2)/...
        length(Rs2(f_exp2>=min(f_range)&f_exp2<=f_max)));
    RMS_G2_exp=sqrt(sum(G2(f_exp2>=min(f_range)&f_exp2<=f_max).^2)/...
        length(G2(f_exp2>=min(f_range)&f_exp2<=f_max)));
    disp([RMS_Rs2 RMS_G2; RMS_Rs2_exp RMS_G2_exp])
elseif no_pl==3
    Rs3_cal=smoothRs;
    G3_cal=smoothG;
    Rs3_exp= interp1(f_expP,real(Z_expP),f_range,'spline');
    G3_exp = interp1(f_expP,XRRE1p,f_range,'spline');
    
    RMS_Rs2=sqrt(sum(smoothRs.^2)/length(smoothRs));
    RMS_G2=sqrt(sum(smoothG.^2)/length(smoothG));
    RMS_Rs2_exp=sqrt(sum(Rs2(f_exp2>=min(f_range)&f_exp2<=f_max).^2)/...
        length(Rs2(f_exp2>=min(f_range)&f_exp2<=f_max)));
    RMS_G2_exp=sqrt(sum(G2(f_exp2>=min(f_range)&f_exp2<=f_max).^2)/...
        length(G2(f_exp2>=min(f_range)&f_exp2<=f_max)));
    disp([RMS_Rs2 RMS_G2; RMS_Rs2_exp RMS_G2_exp])
end
%%

    RMSD_Rs_cal=sqrt(sum((Rs1_cal-Rs2_cal).^2)./sum(Rs2_cal.^2));
    RMSD_G_cal=sqrt(sum((G1_cal-G2_cal).^2)./sum(G2_cal.^2));
    
    RMSD_Rs_exp=sqrt(sum((Rs1_exp-Rs2_exp).^2)./sum(Rs2_exp.^2));
    RMSD_G_exp=sqrt(sum((G1_exp-G2_exp).^2)./sum(G2_exp.^2));
    MAPD_Rs=sum((Rs1_cal-Rs2_cal))./sum(Rs2_cal);
    MAPD_G=sum(sum((G1_cal-G2_cal).^2)./sum(G2_cal.^2));
    clc
   disp('       RMSD_Rs_cal       RMSD_Rs_exp')
   disp([RMSD_Rs_cal RMSD_Rs_exp])
   disp('       RMSD_G_cal       RMSD_G_exp')
   disp([RMSD_G_cal RMSD_G_exp])

%%
hold off
figure(3)
hold on
plot(q,'b')

figure(7)
hold on
plot(f_range*1e-3,real(Vf(f>=f_min&f<=f_max)).*real(If(f>=f_min&f<=f_max))+...
    imag(Vf(f>=f_min&f<=f_max)).*imag(If(f>=f_min&f<=f_max)))
plot(f_range*1e-3,real(If(f>=f_min&f<=f_max)),'r')
figure(2)
hold on
plot(f(f>=0&f<=1e6),abs(If(f>=0&f<=1e6)),'r')
plot(f_range*1e-3,real(Vf(f_range)),'r')
figure(3)
hold on
plot(f_range*1e-3,(real(If(f>=f_min&f<=f_max))).^2+...
    (imag(If(f>=f_min&f<=f_max))).^2)
plot(((q)),'b')
hold on
plot((0:t_step)*ts,excit_sh(1:t_step+1)./max(excit_sh(1:t_step+1)),'r')