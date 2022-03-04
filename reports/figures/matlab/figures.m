clc
close all
print_out = false;
LW = 1.5;
MS = 8;
tt = 4; ff=tt-1;
frequency = 50:25:150;
frequency = frequency(tt); f1 = 0; 
case_no = 0:7;
t_n1 = [90 69 60 54 50];
t_n2 = [0 11 10 7 7];
t_e1 = [90 72 64 59 55];
t_e2 = [0 13 10 7 7];
trsh_n = [8e-4 4e-3 4e-3 4e-3 4e-3];
trsh_e = [25e-3 37e-3 70e-3 70e-3 70e-3];
yLim_4 = {[];[0.5 2];[0.5 3];[0.25 5];[0.25 10]};
yTicks_4 = {[];[1 2];[1 2 3];[1 3 5];[1 5 10]};
yLim_5 = {[];[0.5 2];[0.5 2];[0.5 2];[0.5 4]};
yTicks_5 = {[];[1 2];[1 2];[1 2];[1 2 4]};

N_c = 5; t_n1 = t_n1(tt); t_e1 = t_e1(tt);t_n2 = t_n2(tt); t_e2 = t_e2(tt);
wid = 0.5*N_c/frequency/1e3; n = 6;
madif_num_amp = zeros(length(case_no),length(frequency));
madif_num_eng = zeros(length(case_no),length(frequency));
madif_num_engA = zeros(length(case_no),length(frequency));
normFlag = false;
h1 = figure(1);
h1.Units = 'centimeters';
h1.Position = [0 10 36 15];
h1.Color = 'w';
for wavfreq = frequency
    f1 = f1 + 1;
    c1 = 0;
    for i =  case_no + frequency*100
        c1 = c1 + 1;
        username = 'pfiborek'; name_project = 'model_hc';
        gpuFlag = true; KFlag = false;
        parentFolder = fullfile(filesep,'home',username,'Documents','IO_SEM');
        filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
            'output',num2str(i),'data.mat');
        load(filePath,'data','output')
        t = data.time_vector;
        outputFile = fullfile(parentFolder,'data','raw','num',name_project,'output',num2str(i),...
            'voltage','phi.mat');
        load(outputFile,'phi')
        phi = ((phi(:,end)));
        [max_peak,pos_peak] = findpeaks(phi,'MinPeakHeight',trsh_n(tt));
        [~,peak_no] = min(abs(t(pos_peak)*1e6-t_n1));
        if c1 == 1
            max_num = max_peak(peak_no);
            pos = t(pos_peak(peak_no))-t_n2*1e-6;
        end
        switch normFlag
            case true
                plot(t*1e6,phi./max_num)
            case false
                plot(t*1e6,phi)
        end
        hold on
        g = exp(-((t-pos)./(0.6005612.*wid)) .^(2*n))';
        madif_num_amp(c1,f1) = max_peak(peak_no);
        madif_num_eng(c1,f1) = sum((g.*phi).^2);
        madif_num_engA(c1,f1) = sum((phi).^2);
        
    end
end
plot(t*1e6,g*max(max_peak))
plot(t(pos_peak)*1e6,max_peak,'*')
%
dam_num = [0 10:20:130];
dam = linspace(0,dam_num(length(case_no)));
leg = {num2str(dam_num(1:length(case_no))')};
legend(leg)
madif_num_amp = madif_num_amp./ madif_num_amp(1,:);
madif_num_eng = madif_num_eng./ madif_num_eng(1,:);
cl = {[0   0.447000000000000   0.741000000000000]
   [0.850000000000000   0.325000000000000   0.098000000000000]
   [0.929000000000000   0.694000000000000   0.125000000000000]
   [0.494000000000000   0.184000000000000   0.556000000000000]
   [0.466000000000000   0.674000000000000   0.188000000000000]
   [0.301000000000000   0.745000000000000   0.933000000000000]
   [0.635000000000000   0.078000000000000   0.184000000000000]};
%
pause(2)
fit_order = 3;
f5 = figure(5);
f5.Units = 'centimeters';
f5.Position = [70 10 10 8];
f5.Color = 'w';
y_fit_num_amp = zeros(length(dam),length(frequency));
for i = 1 : length(frequency)
    p = polyfit(dam_num(1:length(case_no)),madif_num_amp(:,i),fit_order);
    y_fit_num_amp(:,i) = polyval(p,dam);
    drawnow
    plot(dam,y_fit_num_amp(:,i),'LineStyle','--','Color',cl{1},'LineWidth',LW);
    hold on
end


for i = 1 : length(frequency)
   plot(dam_num(1:length(case_no)),madif_num_amp(:,i),'LineStyle','none','Marker','s','Color',cl{1},...
'MarkerSize',8)
end
pause(1)
f4 = figure(4);
f4.Units = 'centimeters';
f4.Position = [50 10 10 8];
f4.Color = 'w';
y_fit_num_eng = zeros(length(dam),length(frequency));
for i = 1 : length(frequency)
    p = polyfit(dam_num(1:length(case_no)),madif_num_eng(:,i),fit_order);
    y_fit_num_eng(:,i) = polyval(p,dam);
    drawnow
    plot(dam,y_fit_num_eng(:,i),'LineStyle','--','Color',cl{1},'LineWidth',LW);
    hold on
end

for i = 1 : length(frequency)
   plot(dam_num(1:length(case_no)),madif_num_eng(:,i),'LineStyle','none','Marker','s','Color',cl{1},...
'MarkerSize',8)
end

h1 = figure(2);
h1.Units = 'centimeters';
h1.Position = [0 10 36 15];
hold on
pause(1)
f1 = 0;
madif_exp_amp = zeros(length(case_no),length(frequency));
madif_exp_eng = zeros(length(case_no),length(frequency));
madif_exp_engA = zeros(length(case_no),length(frequency));
for wavfreq = frequency
    f1 = f1 +1;
    folder_Honeycomb = 'pzt2_CFR_Honeycomb_';
    cycl = [num2str(N_c),'_cycles_',num2str(wavfreq),'kHz'];
    c1 = 0;
    for i = case_no
        c1 = c1 + 1;
        expFile = fullfile(parentFolder,'data','processed','exp',name_project,...
            'Fiborek_Honeycomb_3',[folder_Honeycomb,num2str(i)],'averaged',cycl,...
            'niscope_avg_waveform.mat');
        load(expFile)
        Fs_exp = sampleRate;
        N_exp = length(niscope_avg_waveform);
        ts_exp = 1/Fs_exp;
        t_exp = (0:N_exp-1)*ts_exp; T_exp = t_exp(end);
        f_exp = 0:1/T_exp:Fs_exp/2;
        phi_exp = niscope_avg_waveform;
        phi_exp = bandpass(phi_exp,(0.5*[-wavfreq wavfreq]+wavfreq)*1e3,Fs_exp);
        phi_exp = ((phi_exp(t_exp>=0 & t_exp<=400e-6)));
        t_exp = t_exp(t_exp>=0 & t_exp<=400e-6);
        [max_peak,pos_peak] = findpeaks(phi_exp,'MinPeakHeight',trsh_e(tt));
        [~,peak_no] = min(abs(t_exp(pos_peak)*1e6-t_e1));
        if c1 == 1
            max_exp = max_peak(peak_no);
            pos = t_exp(pos_peak(peak_no))-t_e2*1e-6;
        end
        
        switch normFlag
            case true
                plot(t_exp*1e6,phi_exp./max_exp)
            case false
                plot(t_exp*1e6,phi_exp)
        end
        g_exp = exp(-((t_exp-pos)./(0.6005612.*wid)) .^(2*n))';
        hold on
        drawnow
        madif_exp_amp(c1,f1) = max_peak(peak_no);
        madif_exp_eng(c1,f1) = sum((g_exp.*phi_exp).^2);
        madif_exp_engA(c1,f1) = sum((phi_exp).^2);
    end
end
legend(leg)
plot(t_exp*1e6,g_exp*max(max_peak))
plot(t_exp(pos_peak)*1e6,max_peak,'*')

%
madif_exp_amp = madif_exp_amp./ madif_exp_amp(1,:);
madif_exp_eng = madif_exp_eng./ madif_exp_eng(1,:);
madif_exp_engA = madif_exp_engA./ madif_exp_engA(1,:);
disp([madif_num_eng madif_exp_eng])

figure(5)
dam_exp = [0 10:20:130];
y_fit_exp_amp = zeros(length(dam),length(frequency));
for i = 1 : length(frequency)
    p = polyfit(dam_exp(1:length(case_no)),madif_exp_amp(:,i),fit_order);
    y_fit_exp_amp(:,i) = polyval(p,dam);
    drawnow
    plot(dam,y_fit_exp_amp(:,i),'LineStyle','-','Color',cl{2},'LineWidth',LW)
    hold on
end
MAE_amp_h(ff) = sum(abs(y_fit_num_amp-y_fit_exp_amp))./length(y_fit_exp_amp);
for i = 1 : length(frequency)
   plot(dam_exp(1:length(case_no)),madif_exp_amp(:,i),'LineStyle','none','Marker','o','Color',cl{2},...
'MarkerSize',8)
end
pause(1)
figure(4)
y_fit_exp_eng = zeros(length(dam),length(frequency));
for i = 1 : length(frequency)
    p = polyfit(dam_exp(1:length(case_no)),madif_exp_eng(:,i),fit_order);
    y_fit_exp_eng(:,i) = polyval(p,dam);
    drawnow
    plot(dam,y_fit_exp_eng(:,i),'LineStyle','-','Color',cl{2},'LineWidth',LW)
    hold on
end
MAE_eng_h(ff) = sum(abs(y_fit_num_eng-y_fit_exp_eng))./length(y_fit_exp_eng);
for i = 1 : length(frequency)
   plot(dam_exp(1:length(case_no)),madif_exp_eng(:,i),'LineStyle','none','Marker','o','Color',cl{2},...
'MarkerSize',8)
end
f1 = 0;
case_sim = case_no+10;
N_c = 5;
madif_sim_amp = zeros(length(case_sim),length(frequency));
madif_sim_eng = zeros(length(case_sim),length(frequency));
madif_sim_engA = zeros(length(case_sim),length(frequency));
s_f = zeros(7,1);
h1 = figure(3);
h1.Units = 'centimeters';
h1.Position = [0 10 36 15];
h1.Color = 'w';
for wavfreq = frequency
    f1 = f1 + 1;
    c1 = 0;
    for i =  case_sim + frequency*100
        c1 = c1 + 1;
        username = 'pfiborek'; name_project = 'model_hc';
        gpuFlag = true; KFlag = false;
        parentFolder = fullfile(filesep,'home',username,'Documents','IO_SEM');
        filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
            'output',num2str(i),'data.mat');
        load(filePath,'data','output')
        t = data.time_vector;
        outputFile = fullfile(parentFolder,'data','raw','num',name_project,'output',num2str(i),...
            'voltage','phi.mat');
        load(outputFile,'phi')
        phi = ((phi(:,end)));
        [max_peak,pos_peak] = findpeaks(phi,'MinPeakHeight',trsh_n(tt));
        [~,peak_no] = min(abs(t(pos_peak)*1e6-t_n1));
        if c1 == 1
            max_num = max_peak(peak_no);
            pos = t(pos_peak(peak_no))-t_n2*1e-6;
        end
        switch normFlag
            case true
                plot(t*1e6,phi./max_num)
            case false
                plot(t*1e6,phi)
        end
        hold on;
       
        g = exp(-((t-pos)./(0.6005612.*wid)) .^(2*n))';
       
        madif_sim_amp(c1,f1) = max_peak(peak_no);
        madif_sim_eng(c1,f1) = sum((g.*phi).^2);
        madif_sim_engA(c1,f1) = sum((phi).^2);
    end
end
plot(t*1e6,g*max(max_peak))
plot(t(pos_peak)*1e6,max_peak,'g*')
plot(t(pos_peak(peak_no))*1e6,max_peak(peak_no),'ro')
dam_num = [0 10:20:130];
dam = linspace(0,dam_num(length(case_sim)));
leg = {num2str(dam_num(1:length(case_sim))')};
legend(leg)
%
madif_sim_amp = madif_sim_amp./ madif_sim_amp(1,:);
madif_sim_eng = madif_sim_eng./ madif_sim_eng(1,:);
madif_sim_engA = madif_sim_engA./ madif_sim_engA(1,:);
cl = {[0   0.447000000000000   0.741000000000000]
   [0.850000000000000   0.325000000000000   0.098000000000000]
   [0.929000000000000   0.694000000000000   0.125000000000000]
   [0.494000000000000   0.184000000000000   0.556000000000000]
   [0.466000000000000   0.674000000000000   0.188000000000000]
   [0.301000000000000   0.745000000000000   0.933000000000000]
   [0.635000000000000   0.078000000000000   0.184000000000000]};
%
pause(1)
figure(5)
y_fit_num_amp = zeros(length(dam),length(frequency));
for i = 1 : length(frequency)
    p = polyfit(dam_num(1:length(case_sim)),madif_sim_amp(:,i),fit_order);
    y_fit_num_amp(:,i) = polyval(p,dam);
    drawnow
    plot(dam,y_fit_num_amp(:,i),'LineStyle','-.','Color',cl{3},'LineWidth',LW);
    hold on
end
MAE_amp_s(ff) = sum(abs(y_fit_num_amp-y_fit_exp_amp))./length(y_fit_exp_amp);
for i = 1 : length(frequency)
   plot(dam_num(1:length(case_sim)),madif_sim_amp(:,i),'LineStyle','none','Marker','d','Color',cl{3},...
'MarkerSize',8)
end
pause(1)
figure(4)
y_fit_num_eng = zeros(length(dam),length(frequency));
for i = 1 : length(frequency)
    p = polyfit(dam_num(1:length(case_sim)),madif_sim_eng(:,i),fit_order);
    y_fit_num_eng(:,i) = polyval(p,dam);
    drawnow
    plot(dam,y_fit_num_eng(:,i),'LineStyle','-.','Color',cl{3},'LineWidth',1);
    hold on
end
MAE_eng_s(ff) = sum(abs(y_fit_num_eng-y_fit_exp_eng))./length(y_fit_exp_eng);
for i = 1 : length(frequency)
   plot(dam_num(1:length(case_sim)),madif_sim_eng(:,i),'LineStyle','none','Marker','d','Color',cl{3},...
'MarkerSize',8)
end

set(gca,...
'Units','normalized',...
'YLim',yLim_4{tt},...
'YTick',yTicks_4{tt},...
'XlIM',[0,130],...
'XTick',[0 10:20:130],...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',9,...
'FontName','Times')
legend({'fit honeycomb' 'honeycomb' ...
 'fit experimental' 'experimental'...    
 'fit homogenized' 'homogenized'},...
'interpreter','latex',...
'FontSize',9,...
'FontName','Times',...
'Location','NorthWest')

ylabel('$I_{eng}/I_{eng}^{ref}$ [$-$]','interpreter','latex','FontName','Times','FontSize',12)
xlabel('$\Phi_D$ [mm]', 'interpreter','latex','FontName','Times','FontSize',12)
tit = [num2str(frequency),' kHz'];
title(tit,'interpreter','latex','FontName','Times','FontSize',12)
fileName = ['Energy_',tit,'.png'];
filePath = fullfile(parentFolder,'data','processed','num',name_project,'figures','png',fileName);
pause(1)
if print_out; print(filePath,'-dpng', '-r600'); end
filePath = fullfile(filesep,'home','pfiborek','Documents','GITHub',name_project,'reports','figures',...
    'png',fileName);
pause(1)
if print_out; print(filePath,'-dpng', '-r600'); end
%%%%%%%%
figure(5)
set(gca,...
'Units','normalized',...
'YLim',yLim_5{tt},...
'YTick',yTicks_5{tt},...
'XlIM',[0,130],...
'XTick',[0 10:20:130],...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',9,...
'FontName','Times')
legend({'fit honeycomb' 'honeycomb' ...
 'fit experimental' 'experimental'...    
 'fit homogenized' 'homogenized'},...
'interpreter','latex',...
'FontSize',9,...
'FontName','Times',...
'Location','NorthWest')
ylabel('$I_{amp}/I_{amp}^{ref}$ [$-$]','interpreter','latex','FontName','Times','FontSize',12)
xlabel('$\Phi_D$ [mm]', 'interpreter','latex','FontName','Times','FontSize',12)
title(tit,'interpreter','latex','FontName','Times','FontSize',12)
fileName = ['Amplitude_',tit,'.png'];
filePath = fullfile(parentFolder,'data','processed','num',name_project,'figures','png',fileName);
pause(1)
if print_out; print(filePath,'-dpng', '-r600'); end
filePath = fullfile(filesep,'home','pfiborek','Documents','GITHub',name_project,'reports','figures',...
    'png',fileName);
pause(1)
if print_out; print(filePath,'-dpng', '-r600'); end
%%
clc
close all
print_out = false;
LW = 1.5;
MS = 8;
tt = 4; ff=tt-1;
frequency = 50:25:150;
frequency = frequency(tt); f1 = 0; 
case_no = 0;
t_n1 = [90 69 60 54 50];
t_n2 = [0 11 10 7 7];
t_e1 = [90 72 64 59 55];
t_e2 = [0 13 10 7 7];
trsh_n = [8e-4 4e-3 4e-3 4e-3 4e-3];
trsh_e = [25e-3 37e-3 70e-3 70e-3 70e-3];
yLim_4 = {0:0.25:2;0:0.25:2;0:0.25:3;0:0.5:5;0:1.0:10};
yLim_5 = {0:0.25:2;0:0.25:1.5;0:0.25:1.5;0:0.25:2;0:0.5:3.5};

N_c = 5; t_n1 = t_n1(tt); t_e1 = t_e1(tt);t_n2 = t_n2(tt); t_e2 = t_e2(tt);
wid = 0.5*N_c/frequency/1e3; n = 6;
madif_num_amp = zeros(length(case_no),length(frequency));
madif_num_eng = zeros(length(case_no),length(frequency));
madif_num_engA = zeros(length(case_no),length(frequency));
normFlag = false;

    f1 = f1 + 1;
    c1 = 0;
i =  case_no + frequency*100;
        c1 = c1 + 1;
        username = 'pfiborek'; name_project = 'model_hc';
        gpuFlag = true; KFlag = false;
        parentFolder = fullfile(filesep,'home',username,'Documents','IO_SEM');
        filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
            'output',num2str(i),'data.mat');
        load(filePath,'data','output')
        t = data.time_vector;
        outputFile = fullfile(parentFolder,'data','raw','num',name_project,'output',num2str(i),...
            'voltage','phi.mat');
        load(outputFile,'phi')
        
        %phi = bandpass(phi(:,2),(0.5*[-1 1]*wavfreq+wavfreq)*1e3,fs) ;
        
        phi = ((phi(:,end)));
        %t_1 = 0; t_2 = 79.935;
        %t_num = t(t>=t_1*1e-6 & t<t_2*1e-6);
        %fs_num = (length(t_num)-1)/t_num(end);
        %f_num = 
        [max_peak,pos_peak] = findpeaks(phi,'MinPeakHeight',trsh_n(tt));
        [~,peak_no] = min(abs(t(pos_peak)*1e6-t_n1));
        if c1 == 1
            max_num = max_peak(peak_no);
            pos = t(pos_peak(peak_no))-t_n2*1e-6;
        end
h1 = figure(1);
h1.Units = 'centimeters';
h1.Position = [10 10 10 7];
h1.Color = 'w';
plot(t*1e6,phi./max(phi)/2,'LineStyle',':','Color',cl{1},'LineWidth',LW)
hold on
g = exp(-((t-pos)./(0.6005612.*wid)) .^(2*n))';
plot(t*1e6,g,'LineStyle','-.','Color',cl{2},'LineWidth',LW)
plot(t*1e6,phi./max(phi)/2.*g,'LineStyle','-','Color',cl{3},'LineWidth',LW)
set(gca,...
'Units','normalized',...
'YLim',[-0.5 1.1],...
'YTick',linspace(-0.5,1,4),...
'XlIM',[0,200],...
'XTick',0:50:200,...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',9,...
'FontName','Times')
legend({'$\Psi(t)$','$g(t)$','$\Psi(t)g(t)$'},...
'interpreter','latex',...
'FontSize',9,...
'FontName','Times',...
'Location','NorthEast')
ylabel('$\Psi_{g}$ [V]','interpreter','latex','FontName','Times',...
    'FontSize',12)
xlabel('t [$\mu$s]', 'interpreter','latex','FontName','Times',...
    'FontSize',12)
title('(\textbf{a})','interpreter','latex','FontName','Times','FontSize',12)
tit = [num2str(frequency),' kHz'];
fileName = ['windowed',tit,'.png'];
filePath = fullfile(parentFolder,'data','processed','num',name_project,'figures','png',fileName);
pause(1)
if print_out; print(filePath,'-dpng', '-r600'); end
filePath = fullfile(filesep,'home','pfiborek','Documents','GITHub',name_project,'reports','figures',...
    'png',fileName);
pause(1)
if print_out; print(filePath,'-dpng', '-r600'); end
fileName = ['windowed',tit,'.eps'];
filePath = fullfile(filesep,'home','pfiborek','Documents','GITHub',name_project,'reports','figures',...
    'eps',fileName);
if print_out; print(filePath,'-deps'); end
%%
print_out = true;
I = linspace(1,1.14);
p = polyfit(madif_exp_amp,dam_num,fit_order);
y = polyval(p,I);
h1 = figure(2);
h1.Units = 'centimeters';
h1.Position = [10 10 10 7];
h1.Color = 'w';
plot(I,y-y(1),'LineStyle','-','Color',cl{1},'LineWidth',LW)
set(gca,...
'Units','normalized',...
'YLim',[0 140],...
'YTick',linspace(0,140,3),...
'XlIM',[1,1.14],...
'XTick',linspace(1,1.14,3),...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',9,...
'FontName','Times')
ylabel('$\Phi_{D}$ [mm]','interpreter','latex','FontName','Times','FontSize',12)
xlabel('$I/I^{ref}$ [$-$]', 'interpreter','latex','FontName','Times','FontSize',12)
title('(\textbf{b})','interpreter','latex','FontName','Times','FontSize',12)
tit = [num2str(frequency),' kHz'];
fileName = ['madif_teor',tit,'.png'];
filePath = fullfile(parentFolder,'data','processed','num',name_project,'figures','png',fileName);
if print_out; print(filePath,'-dpng', '-r600'); end
filePath = fullfile(filesep,'home','pfiborek','Documents','GITHub',name_project,'reports','figures',...
    'png',fileName);
if print_out; print(filePath,'-dpng', '-r600'); end
%%
print_out = true;
I = linspace(1,1.2);
p = polyfit(madif_num_amp,dam_num,fit_order);
y = polyval(p,I);
h1 = figure(1);
h1.Units = 'centimeters';
h1.Position = [10 10 20 12];
h1.Color = 'w';
plot(I,y-y(1),'LineStyle','-','Color',cl{1},'LineWidth',LW)
hold on
plot(madif_exp_amp,dam_num,'LineStyle','none','Marker','o','Color',cl{2},'MarkerSize',8)
set(gca,...
'Units','normalized',...
'YLim',[0 200],...
'YTick',0:50:200,...
'XlIM',[1,1.2],...
'XTick',linspace(1,1.2,5),...
'FontUnits','points',...
'FontWeight','normal',...
'FontSize',9,...
'FontName','Times')
ylabel('$\Phi_{D}$ [mm]','interpreter','latex','FontName','Times','FontSize',12)
xlabel('$I/I^{ref}$ [$-$]', 'interpreter','latex','FontName','Times','FontSize',12)
legend({'MADIF','experimental'},...
'interpreter','latex',...
'FontSize',9,...
'FontName','Times',...
'Location','NorthWest')
tit = [num2str(frequency),' kHz'];
fileName = ['MADIF','.png'];
filePath = fullfile(parentFolder,'data','processed','num',name_project,'figures','png',fileName);
if print_out; print(filePath,'-dpng', '-r600'); end
filePath = fullfile(filesep,'home','pfiborek','Documents','GITHub',name_project,'reports','figures',...
    'png',fileName);
if print_out; print(filePath,'-dpng', '-r600'); end
