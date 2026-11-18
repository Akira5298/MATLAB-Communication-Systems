% Band-pass filter an input signal
% x      - input signal
% t      - vector of regularly spaced time instants
% f_low  - lower cutoff frequency in Hertz
% f_high - upper cutoff frequency in Hertz
% y      - filtered output signal

function y = band_pass_filter(x, t, f_low, f_high)

    % Apply a low-pass filter at the upper cutoff frequency
    y = low_pass_filter(x, t, f_high);  % Low pass at f_high

    % Apply a high-pass filter at the lower cutoff frequency
    y = high_pass_filter(y, t, f_low);  % High pass at f_low

end
