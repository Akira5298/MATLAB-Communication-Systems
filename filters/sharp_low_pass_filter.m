% Apply a high-order FIR low-pass filter to an input signal
% x        - input signal
% t        - vector of regularly spaced time instants
% f_cutoff - cutoff frequency in Hertz
% y        - filtered output signal

function y = sharp_low_pass_filter(x, t, f_cutoff)

    % Calculate the sampling frequency
    f_s = 1 / (t(2) - t(1));

    % Calculate the normalized cutoff frequency
    Wn = f_cutoff / (f_s/2);

    % Define the FIR filter order
    N = 1000;

    % Design the low-pass FIR filter
    b = fir1(N, Wn);

    % Apply the filter to the input signal
    y = filter(b, 1, x);

end

