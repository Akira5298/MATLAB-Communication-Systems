function [x_hat, x_hat_title] = receiver(y_hat, t)

    x_hat_title = 'Multi-Carrier Receiver (LPF 1.0 Hz cutoff)';

    % Step 1: Demodulate each carrier
    z1 = y_hat .* cos(2 * pi * 6 * t);
    z2 = y_hat .* cos(2 * pi * 8 * t);
    z3 = y_hat .* cos(2 * pi * 10 * t);
    z4 = y_hat .* cos(2 * pi * 12 * t);
    z5 = y_hat .* cos(2 * pi * 14 * t);

    % Step 2: Low-pass filter each demodulated signal
    x1_hat = low_pass_filter(z1, t, 1.0);
    x2_hat = low_pass_filter(z2, t, 1.0);
    x3_hat = low_pass_filter(z3, t, 1.0);
    x4_hat = low_pass_filter(z4, t, 1.0);
    x5_hat = low_pass_filter(z5, t, 1.0);

    % Step 3: Combine the recovered signals using weighted coefficients
    x_hat = 0.3*x1_hat + 0.7*x2_hat + x3_hat + 0.7*x4_hat + 0.3*x5_hat;

    % Step 4: Remove DC offset and normalize
    x_hat = x_hat - mean(x_hat);
    x_hat = x_hat / sqrt(mean(x_hat.^2));

end

