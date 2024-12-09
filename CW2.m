function [CWD, freqs, times] = choi_williams_distribution(x, fs, sigma)
  % Input:
  % x     : 1D signal (row or column vector)
  % fs    : Sampling frequency
  % sigma : Kernel parameter for interference suppression

  N = length(x); % Length of the signal
  t = (0:N-1) / fs; % Time vector

  % Frequency vector
  freqs = (-fs/2:fs/N:fs/2-fs/N);  % Frequencies from -fs/2 to fs/2
  times = t;  % Time vector

  % Initialize the Choi-Williams Distribution matrix
  CWD = zeros(N, length(freqs));

  % Kernel: Gaussian window
  kernel = @(tau) exp(-tau.^2 / (2 * sigma^2));

  % Compute the CWD
  for n = 1:N
    for k = 1:N
      % Time shift
      tau = t(k) - t(n);  % Time difference between the current and shifted points

      % Compute the integrand for CWD (product of shifted signal and kernel)
      shifted_signal_1 = x(mod(n+floor(tau/2), N) + 1);  % x(t + tau/2)
      shifted_signal_2 = x(mod(n-floor(tau/2), N) + 1);  % x(t - tau/2)
      
      % Apply the kernel for suppression of interference
      CWD(n, k) = shifted_signal_1 * conj(shifted_signal_2) * kernel(tau);
    end
  end

  % Normalize the distribution
  CWD = abs(CWD).^2;
  
  % Convert CWD to a 2D time-frequency plot
  figure;
  imagesc(times, freqs, 10*log10(CWD));
  axis xy;
  xlabel('Time (s)');
  ylabel('Frequency (Hz)');
  title('Choi-Williams Distribution');
  colorbar;
  colormap jet;
end
