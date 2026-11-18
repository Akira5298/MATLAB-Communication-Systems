% Generate an 8-PSK modulated signal and analyse its amplitude spectrum

clear;
clc;
close all;

% Parameters
fs = 10000;         % Sampling frequency (Hz)
fc = 100;           % Carrier frequency (Hz)
Rs = 20;            % Symbol rate (symbols/s)
Ts = 1/Rs;          % Symbol duration (s)
M = 8;              % 8-PSK
Nsym = 50;          % Number of symbols

% Generate random symbols from 0 to 7
data = randi([0 M-1], 1, Nsym);
phases = 2*pi*data/M;

% Generate PSK-modulated signal
t = (0:round(Nsym*Ts*fs)-1)/fs;
signal = zeros(1, length(t));

for i = 1:Nsym
    idx = round((i-1)*Ts*fs) + 1 : round(i*Ts*fs);
    signal(idx) = cos(2*pi*fc*t(idx) + phases(i));
end

% Calculate amplitude spectrum using FFT
nfft = 2^nextpow2(length(signal));
f = (-nfft/2:nfft/2-1) * fs/nfft;
S = abs(fftshift(fft(signal, nfft)));

% Plot normalized amplitude spectrum
figure;
plot(f, S/max(S));
xlim([0 200]);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Amplitude Spectrum of 8-PSK Signal');
grid on;

