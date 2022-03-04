% freq_input_convergance

switch freq_range
    case 'chirp_250kHz'
        V = 4;
        ts = 5e-9;             % total number of samples [s]   
        T = 1600e-6;           % total calculation time [s]
        t_0 = 0;
        f_0 = 0e3;             % frequency at time t_0 [Hz]
        f_1 = 251.85*10^3;     % frequency at time t_1 [Hz]
        t_1 = 115.14*10^-6;
        N_c = [];
    case 'pulse_16kHz'
        V = 1;
        ts = 1.2e-8;          % time increment [s]
        T = 0.002;  % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 16.5e3;         % frequency of the carrier signal[Hz]
    case 'pulse_16kHz_2'
        V = 1;
        ts = 1.5e-8;          % time increment [s]
        T = 0.002;  % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 16.5e3;         % frequency of the carrier signal[Hz]
    case 'pulse_50kHz'
        V = 1;
        ts = 1e-9;          % time increment [s]
        T = 320.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
     case 'pulse_100kHz'
        V = 16;
        ts = 10e-9;          % time increment [s]
        T = 320.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 100e3;         % frequency of the carrier signal[Hz]
     case 'pulse_150kHz'
        V = 16;
        ts = 5e-9;          % time increment [s]
        T = 210.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 150e3;         % frequency of the carrier signal[Hz]
    case 'pulse_200kHz'
        V = 16;
        ts = 5e-9;          % time increment [s]
        T = 210.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 200e3;         % frequency of the carrier signal[Hz]
end