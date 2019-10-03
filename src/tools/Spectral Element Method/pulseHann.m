function existationshape = pulseHann(N,T,N_c,f_0,const)
% PULSEHANN   
% 
% Syntax: [output1,output2] = pulseHann(input1,input2,input3) 
% 
% Inputs: 
%    N - total number of samples, int[-]
%    N_c - number of counts in the wave packet, int [-]
%    const - amplitude, int [-] 
%    T - total calculation time, int [s]
%    f_0 - frequency of the carrier signal, int [Hz] 
% 
% Outputs: 
%    existationshape - Description, integer, dimensions [m, n], Units: - 
%
% Example: 
%    existationshape = pulseHann(2^15,400e-6,10,50e3/N_c,const) 
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
f_1=f_0/N_c;  % frequency of the modulation signal  [Hz]
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
    st(n)=win(n)*sin(2*pi*f_0*(t(n)-t_1));
    
  end;
  om(n)=(n-1)/T; % frequency [Hz]
end;
%const=1;
existationshape=const*st';

%---------------------- END OF CODE---------------------- 

% ================ [pulseHann.m] ================  
