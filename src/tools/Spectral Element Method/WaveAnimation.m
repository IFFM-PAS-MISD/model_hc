%WaveAnimation
fh = figure(strNo);
set(fh, 'color', 'white'); % sets the color to white
axis([min(min(xx)) max(max(xx)) min(min(yy)) max(max((yy)))]);

nFrames = length(1:2:C1-1);
M1(1:noFrames) = struct('cdata',[], 'colormap',[]);
for i = aa;
   clc;   disp([num2str(i), ' from ', num2str(C1+1)])
   set(gca,'nextplot','replacechildren'); set(gcf,'Renderer','zbuffer');
   %subplot(8,1,[1 4])
   surf(xx,yy,data.Vt{i})
   shading interp;view(2);axis square;axis equal;
   axis off
   caxis([-cc cc]);
   tt = num2str(data.time(i)*1e6);
   %subplot(6,3,17)
   %cla(subplot(6,3,17)); 
   %text(.5,.5,{'Time (ms)'; czas; 'Vmax [m/s]'; max_qz(C1)*1e0},...
   %'FontSize',14,'HorizontalAlignment','center') 
   M1(i) = getframe(gcf);
   %pause
end

%Vt{1}(xx(10,1),x(10,1))