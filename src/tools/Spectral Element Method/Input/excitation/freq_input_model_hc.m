% freq_input_model_hc

switch freq_range
    case 'pulse_15kHz'
        V = 5;
        N = 72e3;           % total number of samples
        T = 612.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_15kHz_1'
        V = 5;
        N = 4*72e3;           % total number of samples
        T = 612.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_15kHz_2'
        V = 5;
        N = 8*75e3;           % total number of samples
        T = 600.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_17kHz'
        V = 20;
        N = 2^16;           % total number of samples
        T = 500.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 16.5e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_25kHz'
        V = 5;
        N = 400e3;           % total number of samples
        T = 600.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_25kHz_1'
        V = 5;
        N = 400e3;           % total number of samples
        T = 600.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_50kHz'
        V = 5;
        N = 100e3;          % total number of samples
        T = 600.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_75kHz'
        V = 5;
        N = 100e3;          % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 75e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_100'
        V = 5;
        N = 100e3;          % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 100e3;        % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_125kHz'
        V = 5;
        N = 200e3;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;           % number of counts in the wave packet []
        f_0 = 125e3;        % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
    case 'pulse_150kHz'
        V = 5;
        N = 200e3;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;           % number of counts in the wave packet []
        f_0 = 150e3;        % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];
end