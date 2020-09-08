% freq_input_model_hc

switch freq_range
    case 'chirp_20kHz'
        T = 2e-3;           % total calculation time [s]
        ts = 10e-9;        % total number of samples [s]        
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 20e3;        % frequency at time T [Hz]
        N_c = [];
    case 'chirp_50kHz'
        T = 2e-3;           % total calculation time [s]
        ts = 8e-9;        % total number of samples [s]        
        f_0 = 20e3;          % frequency at time 0 [Hz]
        f_1 = 60e3;        % frequency at time T [Hz]
        N_c = [];    
    case 'pulse_5kHz'
        ts = 10e-9;          % time increment [s]
        T = 1600.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 5e3;         % frequency of the carrier signal[Hz]
    case 'pulse_10kHz'
        ts = 10e-9;          % time increment [s]
        T = 1600.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 10e3;         % frequency of the carrier signal[Hz]
    case 'pulse_15kHz'
        ts = 10e-9;          % time increment [s]
        T = 1600.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
    case 'pulse_15kHz_1'
        ts = 8e-9;          % time increment [s]
        T = 800.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
    case 'pulse_16.5kHz'
        ts = 10e-9;          % time increment [s]
        T = 2.0e-003;     % total calculation time [s]
        N_c = 10;            % number of counts in the wave packet []
        f_0 = 16.5e3;         % frequency of the carrier signal[Hz]
    case 'pulse_20kHz'
        ts = 10e-9;          % time increment [s]
        T = 2.0e-003;     % total calculation time [s]
        N_c = 10;            % number of counts in the wave packet []
        f_0 = 20e3;         % frequency of the carrier signal[Hz]  
    case 'pulse_20(5)kHz'
        ts = 10e-9;          % time increment [s]
        T = 2.0e-003;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 20e3;         % frequency of the carrier signal[Hz]  
    case 'pulse_20(5)_1kHz'
        ts = 10e-9;          % time increment [s]
        T = 750.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 20e3;         % frequency of the carrier signal[Hz]  
    
    case 'pulse_25kHz'
        ts = 8e-9;          % time increment [s]
        T = 700.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
    case 'pulse_50kHz'
        ts = 8e-9;          % time increment [s]
        T = 600.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
    case 'pulse_75kHz'
        ts = 9e-9;          % time increment [s]
        T = 200.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 75e3;         % frequency of the carrier signal[Hz]
    case 'pulse_100'
        ts = 9e-9;          % time increment [s]
        T = 200.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 100e3;        % frequency of the carrier signal[Hz]
    case 'pulse_125kHz'
        ts = 9e-9;          % time increment [s]
        T = 200.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 125e3;        % frequency of the carrier signal[Hz]
    case 'pulse_150kHz'
        ts = 9e-9;          % time increment [s]
        T = 200.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 150e3;        % frequency of the carrier signal[Hz]
end