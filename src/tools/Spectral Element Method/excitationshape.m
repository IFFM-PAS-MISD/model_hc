function [excit_shape,N,nr_exsh] = ...
    excitationshape(freq_range,f_0,T,ts,N_c,V,plot_ex,f_1,w_1)
% EXCITATIONSHAPE   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: [output1,output2] = excitationshape(input1,input2,input3) 
% 
% Inputs: 
%    input1 - Description, string, dimensions [m, n], Units: ms 
%    input2 - Description, logical, dimensions [m, n], Units: m 
%    input3 - Description, double, dimensions [m, n], Units: N 
% 
% Outputs: 
%    output1 - Description, integer, dimensions [m, n], Units: - 
%    output2 - Description, double, dimensions [m, n], Units: m/s^2 
% 
% Example: 
%    [output1,output2] = excitationshape(input1,input2,input3) 
%    [output1,output2] = excitationshape(input1,input2) 
%    [output1] = excitationshape(input1,input2,input3) 
% 
% Other m-files required: none 
% Subfunctions: none 
% MAT-files required: none 
% See also: OTHER_FUNCTION_NAME1,  OTHER_FUNCTION_NAME2 
% 

% Author: Piotr Fiborek, D.Sc., Eng. 
% Institute of Fluid Flow Machinery Polish Academy of Sciences 
% Mechanics of Intelligent Structures Department 
% email address: pfiborek@imp.gda.pl 
% Website: https://www.imp.gda.pl/en/research-centres/o4/o4z1/people/ 

%---------------------- BEGIN CODE---------------------- 

N = T/ts;           % total steps number []
Fs = N/T;           % frequency range
t_e = 0:ts:T-ts;    % time vector
if ~isempty(strfind(freq_range,'_'))
    signal_type = freq_range(1:strfind(freq_range,'_')-1);
else
    signal_type = freq_range;
end
switch signal_type
    case 'pulse'
        f_1 = f_0/N_c;  % frequency of the modulation signal  [Hz]
        excit_shape = pulseHann(N,T,N_c,f_0,V);
        nr_exsh = ceil(N/(f_1*T))+2;
    case 'chirp'
        excit_shape = chirp(t_e,f_0,t_e(end),f_1,'linear',90)*V;
        excit_shape(1) = 0;
        nr_exsh = N;
    otherwise
        t0 = w_1/2;
        excit_shape = tripuls(t_e-t0,w_1)*V;
        nr_exsh = ceil(w_1/ts)+2;
end

NFFT = 2^nextpow2(N);
f = Fs/2*linspace(0,1,NFFT/2+1);
Xf = fft(excit_shape,NFFT)*2/N;
disp(f(1:3))
if strcmpi(plot_ex,'yes')
% Plot single-sided amplitude spectrum.
    fh1 = figure('Units', 'centimeters','OuterPosition', [10,10, 8 6]);
    h1 = plot(t_e*1e6,excit_shape/...
        max(excit_shape));
    set(h1,'LineStyle','-','LineWidth',2.0,'Color','Blue')
    set(gca, 'Box', 'off' ); % here gca means get current axis
    axis([0 100 -1.1 1.1])
    set(gca, 'TickDir', 'out', 'XTick', 0:25:100, 'YTick', -1:1);
    set(fh1, 'color', 'white'); % sets the color to white
    set(gca,'fontsize',12)
    set(gca,'linewidth',2)
    xlabel('t $[\mu s]$','FontName','Times','FontSize', 12,...
        'interpreter','latex');
    ylabel('V(t) [-]', 'FontName','Times', 'FontSize', 12,...
        'interpreter','latex');
    title('time domain', 'FontName','Times', 'FontSize', 12,...
        'interpreter','latex');
    set(gca,'OuterPosition',[0 0+0.1 1 1-0.2])
    %print -depsc2 ex_shape_t.eps

    fh1 = figure('Units', 'centimeters','OuterPosition', [5,5, 8 6]);
    h2 = plot(f(1:NFFT/2+1)*1e-3,2*abs(Xf(1:NFFT/2+1))) ;
    set(h2,'LineStyle','-','LineWidth',2.0,'Color','Red')
    set(gca, 'Box', 'off' ); % here gca means get current axis
    axis([0 100 0 3])
    set(gca, 'TickDir', 'out', 'XTick', 0:50:100, 'YTick', 0:1.5:3);
    set(fh1, 'color', 'white'); % sets the color to white
    set(gca,'fontsize',12)
    set(gca,'linewidth',2)
    xlabel('f [kHz]','FontName','Times','FontSize', 12,...
        'interpreter','latex');
    ylabel('$|$FFT(V(t))$|$ [-]', 'FontName','Times', 'FontSize', 12,...
        'interpreter','latex');
    title('frequency domain', 'FontName','Times', 'FontSize', 12,...
        'interpreter','latex');
    set(gca,'OuterPosition',[0-0.05 0+0.1 1 1-0.2])
    %print -depsc2 ex_shape_f.eps

end

%---------------------- END OF CODE---------------------- 

% ================ [excitationshape.m] ================  
