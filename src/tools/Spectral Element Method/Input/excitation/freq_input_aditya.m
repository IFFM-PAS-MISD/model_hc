% freq_input_Aditya

switch freq_range
    case 'chirp_100'
        V = 5;
        N = 2^18;           % total number of samples
        T = 4e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 100e3;        % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'chirp_300'
        V = 5;
        N = 2^17;           % total number of samples
        T = 1e-3;           % total calculation time [s]
        w1 = 0.2*1e-005;    % width of triangular excitation
        f_0 = 1e3;          % frequency at time 0 [Hz]
        f_1 = 300e3;        % frequency at time T [Hz]
        N_c = []; N_f = N;
    case 'chirp_500'
        V = 5;
        N = 2^19;           % total number of samples
        T = 2e-3;           % total calculation time [s]
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
    case 'pulse_15kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];    
    case 'pulse_30kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 30e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_40kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 40e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_50kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_60kHz'
        V = 5;
        N = 2^16;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 60e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_70kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 70e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_80kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 80e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_90kHz'
        V = 5;
        N = 1.5*2^15;       % total number of samples
        T = 800.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 90e3;         % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_100'
        V = 5;
        N = 2^16;           % total number of samples
        T = 800.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 100e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_110kHz_b'
        V = 5;
        N = 2^15;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 110e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_120kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 500.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 120e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_130kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 130e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_140kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 140e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
    case 'pulse_150kHz'
        V = 5;
        N = 2^15;           % total number of samples
        T = 200.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 10;           % number of counts in the wave packet []
        f_0 = 150e3;        % frequency of the carrier signal[Hz]
        N_f = 256;
        w1 = []; f_1 = [];
end