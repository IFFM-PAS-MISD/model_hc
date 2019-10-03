% freq_input_Honeycomb

switch freq_range
    case 'chirp_250'
        V = 5;
        N = 2^16;           % total number of samples
        T = 8e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 250e3;        % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'chirp_250_2'
        V = 5;
        N = 2^16;           % total number of samples
        T = 1e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 250e3;        % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'chirp_250_3'
        V = 5;
        N = 2^17;           % total number of samples
        T = 1e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 250e3;        % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'chirp_500'
        V = 5;
        N = 2^18;           % total number of samples
        T = 1e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 500e3;        % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'chirp_1000'
        V = 5;
        N = 2^19;           % total number of samples
        T = 2e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 1000e3;       % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'chirp_500_1'
        V = 5;
        N = 2^19;           % total number of samples
        T = 2e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 500e3;        % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'pulse_10kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 10e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_15kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_25kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_50kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_75kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 75e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_100kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 100e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_125kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 125e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_150kHz'
        V = 5;
        N = 1.5*2^15;       % total number of samples
        T = 800.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 150e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_150kHz_a'
        V = 5;
        N = 1.5*2^15;       % total number of samples
        T = 800.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 150e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_150kHz_b'
        V = 5;
        N = 2^15;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 150e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_175kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 500.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 175e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_200kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 200e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
end