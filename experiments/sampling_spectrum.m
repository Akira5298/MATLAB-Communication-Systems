% Visualise the Fourier spectrum of a sampled signal

clear;
clc;
close all;

% Parameters
omega_s = 4000;  % Sampling angular frequency (rad/s)
omega_range = [-7000*pi, 7000*pi];  % Frequency axis in rad/s

% Define original frequencies (rad/s) and amplitudes
original_freqs = [2000*pi, 5000*pi, 7000*pi];
amplitudes = [1, 0.05, 0.05];

% Create arrays for the sampled signal spectrum (replications)
omega = [];
X_sampled = [];

% Generate replicas at multiples of the sampling frequency
replication_range = -2:2;

for k = replication_range
    shift = k * omega_s;

    for i = 1:length(original_freqs)

        % Calculate positive and negative spectral components
        positive_freq = original_freqs(i) + shift;
        negative_freq = -original_freqs(i) + shift;

        % Store spectral locations and amplitudes
        omega = [omega, positive_freq, negative_freq];
        X_sampled = [X_sampled, amplitudes(i), amplitudes(i)];

    end
end

% Combine any overlapping spectral components
[omega, ~, indices] = unique(omega);
X_sampled = accumarray(indices(:), X_sampled(:)).';

% Plot the sampled signal spectrum
figure;
stem(omega, X_sampled, 'filled');
xlabel('\omega (rad/s)');
ylabel('Relative Amplitude');
title('Fourier Transform of Sampled Signal g(t)');
xlim(omega_range);
grid on;

