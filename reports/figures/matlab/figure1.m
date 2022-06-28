close all
username = 'pfiborek'; name_project = 'model_hc';
parentFolder = fullfile(filesep,'home',username,'Documents');
fh1 = figure('Name','MADIF ENG','Units', 'centimeters',...
'OuterPosition', [2,10, 20 16]);
set(fh1, 'color', 'white'); % sets the color to white
hold on

n = 6;
ksi_p = linspace(-1,1);
[ksi_i,wi_x] = gllnaw(n);
w_ksi = barycentricWeights(ksi_i);

Sxi = polynomialInterpolationMatrix(ksi_p,ksi_i,w_ksi);
plot(ksi_p,Sxi(:,1:2:end),'LineStyle','-','LineWidth',1.5,'Color','b')
hold on
plot(ksi_p,Sxi(:,2:2:end),'LineStyle','--','LineWidth',1.5,'Color','b')
plot(ksi_p,zeros(size(ksi_p)),'LineStyle','-','LineWidth',1.0,'Color','k')
plot(ksi_i,0,'o',...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','r')
xticks(ksi_i)
yticks([-0.2 0 0.5 1])
axis([-1 1 -0.5 1.5])
xlabel('$\xi$','interpreter','latex','FontName','Times','FontSize',12)
ylabel('N$(\xi)$', 'interpreter','latex','FontName','Times','FontSize',12)
box on

fileName = 'shape_function.png';
filePath = fullfile(parentFolder,'GITHub',name_project,'reports','figures',...
     'png',fileName);
print(filePath,'-dpng', '-r600')
%%
close all
username = 'pfiborek'; name_project = 'model_hc';
parentFolder = fullfile(filesep,'home',username,'Documents');
fh1 = figure('Name','MADIF ENG','Units', 'centimeters',...
'OuterPosition', [2,10, 20 16]);
set(fh1, 'color', 'white'); % sets the color to white
[x,y] = meshgrid(ksi_i);
plot(x,y,'o',...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','r')
xticks(ksi_i)
yticks(ksi_i)
box on
xlabel('$\xi$','interpreter','latex','FontName','Times','FontSize',12)
ylabel('$\eta$','interpreter','latex','FontName','Times','FontSize',12)

fileName = '2D_element.png';
filePath = fullfile(parentFolder,'GITHub',name_project,'reports','figures',...
     'png',fileName);
print(filePath,'-dpng', '-r600')
%%

close all
username = 'pfiborek'; name_project = 'model_hc';
parentFolder = fullfile(filesep,'home',username,'Documents');
fh1 = figure('Name','MADIF ENG','Units', 'centimeters',...
'OuterPosition', [2,10, 20 16]);
set(fh1, 'color', 'white'); % sets the color to white
[x,y,z] = meshgrid(ksi_i,ksi_i,[-1,0,1]);
plot3(x(:,:,1),y(:,:,1),z(:,:,1),'o',...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
hold on
plot3(x(:,:,2),y(:,:,2),z(:,:,2),'o',...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','r')
plot3(x(:,:,3),y(:,:,3),z(:,:,3),'o',...
    'MarkerSize',10,...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','r')
xticks(ksi_i)
yticks(ksi_i)
zticks([-1 0 1])
box on
xlabel('$\xi$','interpreter','latex','FontName','Times','FontSize',12)
ylabel('$\eta$','interpreter','latex','FontName','Times','FontSize',12)
zlabel('$\zeta$','interpreter','latex','FontName','Times','FontSize',12)

fileName = '3D_element.png';
filePath = fullfile(parentFolder,'GITHub',name_project,'reports','figures',...
     'png',fileName);
print(filePath,'-dpng', '-r600')
%%
close all
username = 'pfiborek'; name_project = 'model_hc';
parentFolder = fullfile(filesep,'home',username,'Documents');
fh1 = figure('Name','MADIF ENG','Units', 'centimeters',...
'OuterPosition', [2,10, 20 16]);
set(fh1, 'color', 'white'); % sets the color to white
plot(x(:,1),y(:,1),'o',...
    'MarkerSize',5,...
    'MarkerEdgeColor','k',...
    'MarkerFaceColor','k')
axis equal
axis off
fileName = 'pzt_mesh.png';
filePath = fullfile(parentFolder,'GITHub',name_project,'reports','figures',...
     'png',fileName);
print(filePath,'-dpng', '-r600')
%%
close all
ii = 1;
username = 'pfiborek'; name_project = 'model_hc';
parentFolder = fullfile(filesep,'home',username,'Documents');
fh1 = figure('Name','MADIF ENG','Units', 'centimeters',...
'OuterPosition', [2,10, 20 16]);
set(fh1, 'color', 'white'); % sets the color to white
x=structure(ii).nodeCoordinates(:,1);
y=structure(ii).nodeCoordinates(:,2);
plot(x,y,'.')
axis equal
axis off
fileName = 'damage_0.png';
filePath = fullfile(parentFolder,'GITHub',name_project,'reports','figures',...
     'png',fileName);
print(filePath,'-depsc2', '-r600')
