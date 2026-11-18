fs = 10000;         % Sampling frequency
fc = 100;           % Carrier frequency
Rs = 20;            % Symbol rate
Ts = 1/Rs;
M = 8;              % 8-PSK
Nsym = 50;          % Number of symbols

% Generate random symbols from 0 to 7
data = randi([0 M-1], 1, Nsym);
phases = 2*pi*data/M;

% Generate PSK-modulated signal
t = 0:1/fs:Nsym*Ts;
signal = zeros(1, length(t));
for i = 1:Nsym
    idx = round((i-1)*Ts*fs) + 1 : round(i*Ts*fs);
    signal(idx) = cos(2*pi*fc*t(idx) + phases(i));
end

% Plot spectrum
nfft = 2^nextpow2(length(signal));
f = fs/2 * linspace(-1, 1, nfft);
S = abs(fftshift(fft(signal, nfft)));

figure;
plot(f, S/max(S));
xlim([0 200]);
xlabel('Frequency (Hz)');
ylabel('Normalized Magnitude');
title('Amplitude Spectrum of 8-PSK Signal');
grid on;


