function y = band_pass_filter(x, t, f_low, f_high)
    y = low_pass_filter(x, t, f_high);   % Low pass at f_high
    y = high_pass_filter(y, t, f_low);  % High pass at f_low
end

