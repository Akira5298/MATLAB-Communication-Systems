% Parameters
omega_s = 4000; % Sampling frequency in rad/s
omega = -7000*pi : 10 : 7000*pi; % Frequency axis in rad/s

% Define original frequencies (in rad/s)
original_freqs = [2000*pi, 5000*pi, 7000*pi];
amplitudes = [1, 0.05, 0.05];

% Create spectrum of sampled signal (replications)
X_sampled = zeros(size(omega));

% Generate replicas at multiples of sampling freq (up to +/-2)
replication_range = -2:2; % add more if needed

for k = replication_range
    shift = k * omega_s;
    for i = 1:length(original_freqs)
        % Add delta spikes at shifted positions
        X_sampled(abs(omega - (original_freqs(i) + shift)) < 10) = amplitudes(i);
        X_sampled(abs(omega - (-original_freqs(i) + shift)) < 10) = amplitudes(i);
    end
end

% Plot
figure;
stem(omega, X_sampled, 'filled');
xlabel('\omega (rad/s)');
ylabel('Amplitude');
title('Fourier Transform of Sampled Signal g(t)');
xlim([-7000*pi, 7000*pi]);
grid on;
