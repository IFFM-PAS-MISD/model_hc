% freq_input_Test

switch freq_range
    case 'pulse_25kHz'
        V = 5;
        N = 50e3;           % total number of samples
        T = 400.0e-006;     % total calculation time [s]
        Fs = N/T;           % frequency range
        N_c = 5;           % number of counts in the wave packet []
        f_0 = 25e3;         % frequency of the carrier signal[Hz]
        N_f = N;
        w1 = []; f_1 = [];    
end