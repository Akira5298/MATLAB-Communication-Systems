% Multi-Carrier Communication System
% Simulate transmission, AWGN and signal reconstruction

clear;
clc;
close all;

% Locate project directory and add filter functions
project_dir = fileparts(mfilename('fullpath'));
addpath(fullfile(project_dir, 'filters'));

% Create output directory for new simulation results
output_dir = fullfile(project_dir, 'images', 'generated');

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

% Reproducible random signal and noise
rng(42);

%% Step 1: Generate the original message signal

fs = 100;           % Sampling frequency (Hz)
duration = 100;     % Signal duration (s)
N = fs * duration;
t = (0:N-1)/fs;

% Generate a random signal
x = randn(size(t));

% Restrict the message bandwidth to 1 Hz
X = fft(x);
f = (0:N-1)*fs/N;
f_abs = min(f, fs-f);

X(f_abs > 1) = 0;
x = real(ifft(X));

% Remove DC offset and normalize
x = x - mean(x);
x = x / sqrt(mean(x.^2));

%% Step 2: Transmit the message

[y, y_title] = transmitter(x, t);

%% Step 3: Additive White Gaussian Noise (AWGN)

noise_std = 10;
n = noise_std * randn(size(y));

y_hat = y + n;

%% Step 4: Receive and reconstruct the signal

[x_hat, x_hat_title] = receiver(y_hat, t);

%% Step 5: Calculate reconstruction SNR

signal_power = mean(x.^2);
error_power = mean((x - x_hat).^2);

SNR = 10 * log10(signal_power / error_power);

fprintf('Reconstruction SNR: %.4f dB\n', SNR);

%% Step 6: Check spectral constraints

[f_spectrum, Y] = amplitude_spectrum(y, fs);

inband = (f_spectrum >= 5) & (f_spectrum <= 15);
outband = ~inband;

max_inband = max(Y(inband));
max_outband = max(Y(outband));

fprintf('Maximum in-band amplitude: %.4f\n', max_inband);
fprintf('Maximum out-of-band amplitude: %.4f\n', max_outband);

if max_inband <= 5 && max_outband <= 0.3
    fprintf('Spectral constraints: PASSED\n');
else
    fprintf('Spectral constraints: FAILED\n');
end

%% Step 7: Plot the original message signal

plot_signal(t, x, fs, ...
    'Original Message Signal', ...
    'x(t)', 'X(f)', ...
    false, output_dir, 'original-signal.png');

%% Step 8: Plot the transmitted signal

plot_signal(t, y, fs, ...
    y_title, ...
    'y(t)', 'Y(f)', ...
    true, output_dir, 'transmitted-signal.png');

%% Step 9: Plot the noisy received signal

plot_signal(t, y_hat, fs, ...
    'Received Signal with AWGN', ...
    'y hat(t)', 'Y hat(f)', ...
    false, output_dir, 'noisy-signal.png');

%% Step 10: Plot the reconstructed signal

plot_signal(t, x_hat, fs, ...
    sprintf('%s | SNR = %.4f dB', x_hat_title, SNR), ...
    'x hat(t)', 'X hat(f)', ...
    false, output_dir, 'reconstructed-signal.png');

%% Step 11: Compare original and reconstructed signals

figure('Color', 'w');

plot(t, x, 'b', 'LineWidth', 1.5);
hold on;
plot(t, x_hat, 'r--', 'LineWidth', 1.5);

xlim([0 10]);
xlabel('Time (s)');
ylabel('Amplitude');

title(sprintf('Signal Reconstruction (SNR = %.4f dB)', SNR));

legend('Original Signal', 'Reconstructed Signal');
grid on;

exportgraphics(gcf, ...
    fullfile(output_dir, 'signal-comparison.png'), ...
    'Resolution', 300);

%% Local function: Calculate single-sided amplitude spectrum

function [f, A] = amplitude_spectrum(signal, fs)

    N = length(signal);

    A = abs(fft(signal))/N;
    A = A(1:floor(N/2)+1);

    if mod(N, 2) == 0
        A(2:end-1) = 2*A(2:end-1);
    else
        A(2:end) = 2*A(2:end);
    end

    f = (0:length(A)-1)*fs/N;

end

%% Local function: Plot waveform and amplitude spectrum

function plot_signal(t, signal, fs, figure_title, ...
    time_label, frequency_label, show_constraints, ...
    output_dir, filename)

    [f, A] = amplitude_spectrum(signal, fs);

    figure('Color', 'w', 'Position', [100 100 1000 650]);

    % Time-domain waveform
    subplot(2, 1, 1);

    plot(t, signal, 'b');
    xlim([0 10]);
    xlabel('Time (s)');
    ylabel(time_label);
    grid on;

    % Frequency-domain amplitude spectrum
    subplot(2, 1, 2);

    plot(f, A, 'b');
    hold on;

    % Display spectral amplitude constraints
    if show_constraints
        plot([0 5 5 15 15 20], ...
             [0.3 0.3 5 5 0.3 0.3], ...
             'r', 'LineWidth', 1.5);

        legend('Amplitude Spectrum', 'Spectral Constraints');
    end

    xlim([0 20]);
    xlabel('Frequency (Hz)');
    ylabel(frequency_label);
    grid on;

    sgtitle(figure_title, 'Interpreter', 'none');

    % Export high-resolution figure
    exportgraphics(gcf, ...
        fullfile(output_dir, filename), ...
        'Resolution', 300);

end
