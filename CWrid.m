pkg load signal  % Ensure the Signal package is loaded

% Define the Choi-Williams RID function
function [time, freq, rid] = choi_williams_rid(signal, fs, sigma)
    N = length(signal);
    time = (0:N-1) / fs;
    freq = linspace(-fs/2, fs/2, N);

    % Initialize RID matrix
    rid = zeros(N, N);

    % Generate Choi-Williams kernel
    for n = 1:N
        for tau = 1:N
            kernel = exp(-sigma * (tau^2));
            shift_signal = circshift(signal, tau);
            rid(n, tau) = signal(n) * conj(shift_signal(n)) * kernel;
        end
    end

    % Apply FFT across the time axis
    rid = fftshift(fft(rid, [], 2), 2);
    rid = abs(rid) .^ 2;  % Compute the power
end

% Load or generate test signal
fs = 1000;  % Sampling frequency in Hz
t = 0:1/fs:1-1/fs;  % Time vector
signal = sin(2 * pi * 50 * t) + sin(2 * pi * 120 * t);  % Example signal

% Parameters
sigma = 0.1;  % Kernel parameter for smoothing

% Compute Choi-Williams RID
[time, freq, rid] = choi_williams_rid(signal, fs, sigma);

% Plot the RID
figure;
imagesc(time, freq, rid);
axis xy;  % Ensure the frequency axis is in the correct orientation
xlabel('Time (s)');
ylabel('Frequency (Hz)');
title('Choi-Williams RID');
colorbar;

