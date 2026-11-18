% Compare the frequency responses of four digital FIR filters

clear;
clc;
close all;

% Locate project directory and add filter functions
project_dir = fileparts(fileparts(mfilename('fullpath')));
addpath(fullfile(project_dir, 'filters'));

% Create output directory
output_dir = fullfile(project_dir, 'images', 'generated');

if ~exist(output_dir, 'dir')
    mkdir(output_dir);
end

%% Parameters

fs = 100;           % Sampling frequency (Hz)
N = 8192;           % Number of samples
t = (0:N-1)/fs;

f_cutoff = 5;       % Low-pass and high-pass cutoff (Hz)
f_low = 5;          % Lower band-pass cutoff (Hz)
f_high = 15;        % Upper band-pass cutoff (Hz)

%% Generate an impulse signal

x = zeros(size(t));
x(N/2 + 1) = 1;

%% Apply the four filters

y_low = low_pass_filter(x, t, f_cutoff);
y_high = high_pass_filter(x, t, f_cutoff);
y_band = band_pass_filter(x, t, f_low, f_high);
y_sharp = sharp_low_pass_filter(x, t, f_cutoff);

%% Calculate frequency responses using FFT

f = (0:N/2)*fs/N;

H_low = abs(fft(y_low));
H_high = abs(fft(y_high));
H_band = abs(fft(y_band));
H_sharp = abs(fft(y_sharp));

% Retain positive frequencies
H_low = H_low(1:N/2+1);
H_high = H_high(1:N/2+1);
H_band = H_band(1:N/2+1);
H_sharp = H_sharp(1:N/2+1);

%% Plot filter frequency responses

figure('Color', 'w', 'Position', [100 100 1100 750]);

% Linear magnitude response
subplot(2, 1, 1);

plot(f, H_low, 'b', 'LineWidth', 1.5);
hold on;
plot(f, H_high, 'r', 'LineWidth', 1.5);
plot(f, H_band, 'g', 'LineWidth', 1.5);
plot(f, H_sharp, 'm--', 'LineWidth', 1.5);

xline(f_low, 'k:');
xline(f_high, 'k:');

xlim([0 25]);
ylim([0 1.2]);

xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Linear Magnitude Response');

legend('Low-Pass', 'High-Pass', ...
       'Band-Pass', 'High-Order Low-Pass', ...
       'Location', 'best');

grid on;

%% Logarithmic magnitude response

subplot(2, 1, 2);

% Prevent log10(0)
epsilon = 1e-8;

plot(f, 20*log10(max(H_low, epsilon)), ...
    'b', 'LineWidth', 1.5);
hold on;

plot(f, 20*log10(max(H_high, epsilon)), ...
    'r', 'LineWidth', 1.5);

plot(f, 20*log10(max(H_band, epsilon)), ...
    'g', 'LineWidth', 1.5);

plot(f, 20*log10(max(H_sharp, epsilon)), ...
    'm--', 'LineWidth', 1.5);

xline(f_low, 'k:');
xline(f_high, 'k:');

xlim([0 25]);
ylim([-100 10]);

xlabel('Frequency (Hz)');
ylabel('Magnitude (dB)');
title('Logarithmic Magnitude Response');

legend('Low-Pass', 'High-Pass', ...
       'Band-Pass', 'High-Order Low-Pass', ...
       'Location', 'best');

grid on;

sgtitle('Digital FIR Filter Frequency Response Comparison');

%% Export high-resolution figure

exportgraphics(gcf, ...
    fullfile(output_dir, 'filter-comparison.png'), ...
    'Resolution', 300);

fprintf('Filter comparison completed.\n');
fprintf('Figure saved to images/generated/filter-comparison.png\n');

