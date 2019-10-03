% freq_input_Honeycomb

switch freq_range

 case 'chirp'
    V=1;
    N=2^18;         % total number of samples
    T=2e-3;         % total calculation time [s]
    w1=0.2*1e-005;  % width of triangular excitation
    f_0=1e3;        % frequency at time 0 [Hz]
    f_1=200e3;     % frequency at time T [Hz]
    N_c=[];N_f=N;
 case 'pulse_10kHz'
    V=5;
    N=2^16;         % total number of samples
    T=400.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=10e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_15kHz'
    V=5;
    N=2^16;         % total number of samples
    T=400.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=10e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_25kHz'
    V=5;
    N=2^16;         % total number of samples
    T=400.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=15e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_50kHz'
    V=5;
    N=2^16;         % total number of samples
    T=400.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=20e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_75kHz'
    V=5;
    N=2^16;         % total number of samples
    T=400.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=25e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_100kHz'
    V=5;
    N=2^15;         % total number of samples
    T=200.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=25e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_125kHz'
    V=5;
    N=2^15;         % total number of samples
    T=200.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=15e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_150kHz'
    V=5;
    N=2^15;         % total number of samples
    T=200.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=20e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_175kHz'
    V=5;
    N=2^15;         % total number of samples
    T=200.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=25e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
case 'pulse_200kHz'
    V=5;
    N=2^15;         % total number of samples
    T=200.0e-006;       % total calculation time [s]
    Fs=N/T;         % frequency range
    N_c=5;          % number of counts in the wave packet []
    f_1=25e3/N_c;   % frequency of the modulation signal [Hz]
    N_f=1*N;
    w1=[];f_0=[];
end