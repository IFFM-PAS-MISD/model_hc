s = [0 50 100 150 200 250];
s_e = [17.35 6.707 5.169 4.94 1.4 1.16];%[3.255 2.949 2.744 1.389 1.185 1.124];

t = [0 20 40 60 80];
t_eu = [14.23 14.37 14.54 14.76 15.05];

t_er = [5.019 5.277 5.651 7.209];

fh = figure(1);

h1 = plot(s,s_e/s_e(1),'o');
hold on
s1 = linspace(0,250);
p = polyfit(s,s_e/s_e(1),2);
f1 = polyval(p,s1);
h2 = plot(s1,f1,'-r');
set(gca, 'TickDir', 'out', 'XTick', 0:50:250, 'YTick', 0:0.25:1);
set(fh, 'color', 'white'); % sets the color to white
set(h2,'LineStyle','-','LineWidth',2.0,'Color','r')
set(h1,'LineStyle','o','Markersize',8.0,'Color','b')

set(gca,'fontsize',18)
%%

clc
case_no = 115;
col_lin = '-b';  
name_project = 'smart2019';
parentFolder = 'E:\SEM_files';

fileName = [name_project,'_',num2str(case_no),'.mat'];
    filePath = fullfile(parentFolder,'src','models',name_project,...
              'input','stiffness',fileName);
    disp('Load structure from file....')
load(filePath, 'structure','d0','G','d1','M','invMpC','MmC','intLay',...
     'excit_sh','ts','nr_exsh','N_f','parentFolder','name_project',...
     'case_name','output_result');
disp('Load structure from file....done')
filename ='Phi_electrode.mat';
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output', num2str(case_no), 'voltage',filename);
load(filePath,'Phi_electrode')

%%
delta_t = 1*(0.0001116-4.5e-6);

act = 8; sns = 4;
t_e = data(act).wektor_czasu+delta_t;
t_s = (0:N_f-1)*ts;
y_e = data(act).pomiar(sns,(t_e<=300e-6));
dt=t_e(2)-t_e(1);

y_e = [data(act).pomiar(sns,(end-size((0:dt:t_e(1))+1,2):end)) y_e];
t_e = [(0:dt:t_e(1)) t_e];
d_max = max(y_e(t_e<=300e-6));

fh = figure(1);
hold on
h3 = plot(t_e(t_e<=300e-6),y_e(t_e<=300e-6)/d_max,'b');
h4 = plot(t_s(t_s<=300e-6),Phi_electrode{end}(t_s<300e-6)/max(Phi_electrode{end}),'r');
set(gca, 'TickDir', 'out', 'XTick', 0:100e-6:300e-6, 'YTick', -1:0.25:1);
set(fh, 'color', 'white'); % sets the color to white
set(h3,'LineStyle','-','LineWidth',2.0,'Color','r')
set(h4,'LineStyle','-','LineWidth',2.0,'Color','b')
legend('experiment','simulation')
set(gca,'fontsize',18)
set(gca,'linewidth',2)
xlim([0 310e-6])
ylim([-1.0 1.1])
%plot(t_s(t_s<300e-6),excit_sh(t_s<300e-6)/max(excit_sh),'g')
%%
clc
case_no = 114;
col_lin = '--b';  
name_project = 'smart2019';
parentFolder = 'E:\SEM_files';

fileName = [name_project,'_',num2str(case_no),'.mat'];
filePath = fullfile(parentFolder,'src','models',name_project,...
          'input','stiffness',fileName);
disp('Load structure from file....')
load(filePath, 'structure','d0','G','d1','M','invMpC','MmC','intLay',...
    'excit_sh','ts','nr_exsh','N_f','parentFolder','name_project',...
    'case_name','output_result');
disp('Load structure from file....done')
filename ='Phi_electrode.mat';
filePath = fullfile(parentFolder,'data','raw','num' ,name_project,...
              'output', num2str(case_no), 'voltage',filename);
load(filePath,'Phi_electrode')
%%
delta_t = 1*(0.0001117-2.5e-6);


act=1;sns=2;
t_e = data(act).wektor_czasu+delta_t;
t_s = (0:N_f-1)*ts;

y_e = data(act).pomiar(sns,(t_e<=300e-6));
dt=t_e(2)-t_e(1);

y_e = [data(act).pomiar(sns,(end-size((0:dt:t_e(1))+1,2):end)) y_e];
t_e = [(0:dt:t_e(1)) t_e];
d_max = max(y_e(t_e<=300e-6));

fh = figure(1);
hold on
h3 = plot(t_e(t_e<=300e-6),y_e(t_e<=300e-6)/d_max,'b');
h4 = plot(t_s(t_s<=300e-6),Phi_electrode{end}(t_s<300e-6)/max(Phi_electrode{end}(t_s<300e-6)),'r');
set(gca, 'TickDir', 'out', 'XTick', 0:100e-6:300e-6, 'YTick', -1:0.25:1);
set(fh, 'color', 'white'); % sets the color to white
set(h3,'LineStyle','-','LineWidth',2.0,'Color','r')
set(h4,'LineStyle','-','LineWidth',2.0,'Color','b')
legend('experiment','simulation')
set(gca,'fontsize',18)
set(gca,'linewidth',2)
xlim([0 310e-6])
ylim([-1.0 1.1])