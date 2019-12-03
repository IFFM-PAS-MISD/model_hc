% freq_input_model_hc

switch freq_range
    case 'pulse_15kHz'
        N = 88e3;           % total number of samples
        T = 800.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_17kHz'
        N = 2^16;           % total number of samples
        T = 500.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 16.5e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_25kHz'
        N = 400e3;           % total number of samples
        T = 600.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_25kHz_1'
        N = 400e3;           % total number of samples
        T = 600.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_50kHz'
        N = 100e3;          % total number of samples
        T = 600.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_75kHz'
        N = 100e3;          % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 75e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_100'
        N = 100e3;          % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 100e3;        % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_125kHz'
        N = 200e3;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;           % number of counts in the wave packet []
        f_0 = 125e3;        % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_150kHz'
        N = 200e3;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;           % number of counts in the wave packet []
        f_0 = 150e3;        % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
end