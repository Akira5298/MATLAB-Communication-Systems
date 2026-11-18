function y = sharp_low_pass_filter(x, t, f_cutoff)

    f_s = 1 / (t(2) - t(1)); % Sampling frequency
    Wn = f_cutoff / (f_s/2); % Normalized cutoff
    N = 1000;                 % Filter order (sharp!)
    b = fir1(N, Wn);         % FIR filter
    y = filter(b, 1, x);     % Apply filter

end



