% High-pass filter an input signal, in order to obtain the output signal
% input    - a vector of L real values
% t        - a vector of L regularly spaced time instants
% f_cutoff - cutoff frequency in Hertz
% output   - filtered vector of L real values

function output = high_pass_filter(input, t, f_cutoff)

    % Calculate the sampling frequency of the input signal
    f_s = (length(t)-1)/(t(end)-t(1));

    % Design the high-pass FIR filter
    B = fir1(10*ceil(f_s/f_cutoff), 2*f_cutoff/f_s, 'high');

    % Apply the high-pass filter to the input signal
    output = filter2(B,input);

end

