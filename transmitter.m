function [y, y_title] = transmitter(x, t)

    y_title = 'Correct Multi-Carrier DSBSC (5 carriers, full x(t) modulated)';

    x = x*34.6;

    % Step 1: Modulate entire x(t) onto each carrier
    y1 = x .* cos(2 * pi * 6 * t);
    y2 = x .* cos(2 * pi * 8 * t);
    y3 = x .* cos(2 * pi * 10 * t);
    y4 = x .* cos(2 * pi * 12 * t);
    y5 = x .* cos(2 * pi * 14 * t);

    % Step 2: Sum the carriers using weighted coefficients
    y = 0.3*y1 + 0.9*y2 + y3 + 0.9*y4 + 0.3*y5;

    % Step 3: Normalize spectrum to stay within constraint
    Y_f = 2 * abs(fft(y)) / length(y);
    Y_f = Y_f(1:floor(length(Y_f)/2)+1);

    f_s = 1 / (t(2) - t(1));
    f = (0:length(Y_f)-1) * f_s / length(y);

    inband = (f >= 5) & (f <= 15);
    outband = ~inband;

    max_inband = max(Y_f(inband));
    max_outband = max(Y_f(outband));

    scale_inband = 4.9999 / max_inband;    % Push close to 5
    scale_outband = 0.2999 / max_outband; % Stay under 0.3 OOB

    scale = min(scale_inband, scale_outband);
    y = scale * y;

end

