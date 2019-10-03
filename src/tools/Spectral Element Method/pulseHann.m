function existationshape = pulseHann(N,T,N_c,f_1,const)
% PULSEHANN   One line description of what the function or script performs (H1 line) 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
%    optional: more details about the function than in the H1 line 
% 
% Syntax: [output1,output2] = pulseHann(input1,input2,input3) 
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
%    [output1,output2] = pulseHann(input1,input2,input3) 
%    [output1,output2] = pulseHann(input1,input2) 
%    [output1] = pulseHann(input1,input2,input3) 
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%N_c=10;       % number of counts in the wave packet []
%f_1=18e3/N_c;  % frequency of the modulation signal  [Hz]
f_2=N_c*f_1;   % frequency of the carrier signal[Hz]
t_t=1/f_1;   % total duration time of the excitation [s]
t_1=0e-4;    % excitation initiation time [s]
t_2=t_1+t_t; % excitation termiation time [s]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
st=zeros(N,1);
win=zeros(N,1);
om=zeros(N,1);
t=zeros(N,1);
for n=1:N;
  st(n)=0.0; t(n)=(n-1)*T/N;
  if (t(n) >= t_1) && (t(n) <= t_2);
    win(n)=0.5*(1-cos(2*pi*f_1*(t(n)-t_2)));
    st(n)=win(n)*sin(2*pi*f_2*(t(n)-t_1));
    
  end;
  om(n)=(n-1)/T; % frequency [Hz]
end;
%const=1;
existationshape=const*st';

%---------------------- END OF CODE---------------------- 

% ================ [pulseHann.m] ================  
