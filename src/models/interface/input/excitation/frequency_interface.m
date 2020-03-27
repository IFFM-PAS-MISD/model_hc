% freq_input_interface

switch freq_range
    case 'pulse_15kHz'
        ts = 10e-9;          % time increment [s]
        T = 800.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
    case 'pulse_15kHz_1'
        ts = 1e-9;          % time increment [s]
        T = 600.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 15e3;         % frequency of the carrier signal[Hz]
    case 'pulse_25kHz'
        ts = 8.0e-009;          % time increment [s]
        T = 800.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
    case 'pulse_25kHz_1'
        ts = 6.0e-009;          % time increment [s]
        T = 800.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
    case 'pulse_25kHz_2'
        ts = 4.0e-009;          % time increment [s]
        T = 800.0e-006;     % total calculation time [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
    case 'pulse_50kHz'
        T = 360.0e-006;     % total calculation time [s]
        ts = T/2^16;          % time increment [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
    case 'pulse_50kHz_1'
        T = 360.0e-006;     % total calculation time [s]
        ts = T/2^16;          % time increment [s]
        N_c = 5;            % number of counts in the wave packet []
        f_0 = 50e3;         % frequency of the carrier signal[Hz]
        N_f = 1e3;
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
    case 'chirp_200'
        T = 1e-2;           % total calculation time [s]
        ts = T/2^18;        % total number of samples [s]        
        f_0 = 1e2;          % frequency at time 0 [Hz]
        f_1 = 200e3;        % frequency at time T [Hz]
        N_c = [];
    case 'chirp_300'
        T = 1e-2;           % total calculation time [s]
        ts = T/2^18;           % total number of samples
        f_0 = 1e2;          % frequency at time 0 [Hz]
        f_1 = 300e3;        % frequency at time T [Hz]
        N_c = [];
    case 'chirp_300_2'
        T = 1e-2;           % total calculation time [s]
        ts = T/2^17;           % total number of samples
        f_0 = 1e2;          % frequency at time 0 [Hz]
        f_1 = 300e3;        % frequency at time T [Hz]
        N_c = [];
    case 'chirp_300_3'
        T = 1e-2;           % total calculation time [s]
        ts = T/2^19;           % total number of samples
        f_0 = 1e2;          % frequency at time 0 [Hz]
        f_1 = 300e3;        % frequency at time T [Hz]
        N_c = [];
    case 'chirp_300_4'
        T = 1e-2;           % total calculation time [s]
        ts = T/2^20;           % total number of samples
        f_0 = 1e2;          % frequency at time 0 [Hz]
        f_1 = 300e3;        % frequency at time T [Hz]
        N_c = [];
end