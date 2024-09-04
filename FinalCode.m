clc
clear

fs=360; % sampling freq
X = readmatrix("E:\Matlab\Necg.csv"); % ecg singal

X = normalize(X); % normalization

% Define the filter parameters
fclower = 11; % lower cutoff frequency in Hz
fchigher = 0.5; % higher cutoff frequency in Hz
orderlower = 6; % lower filter order
orderhigher = 5; % higher filter order

% Design a Butterworth low-pass filter
[b, a] = butter(orderlower, fclower/(fs/2), 'low');

% Apply the filter to the ECG signal
ecg_lower = filter(b, a, X);

% Design a Butterworth high-pass filter
[c, d] = butter(orderhigher, fchigher/(fs/2), 'high');

% Apply the filter to the ECG signal
ecg_higher = filter(c, d, ecg_lower);

% Plot the original and filtered ECG signals
t = (1:length(X))/fs; % time vector
figure;
subplot(4,1,1);
plot(t, X);
xlabel('Time (s)');
ylabel('Amplitude');
title('Original ECG Signal');

subplot(4,1,2);
plot(t, ecg_lower);
xlabel('Time (s)');
ylabel('Amplitude');
title('Low-pass Filtered ECG Signal');

subplot(4,1,3);
plot(t, ecg_higher);
xlabel('Time (s)');
ylabel('Amplitude');
title('High-Pass Filtered ECG Signal');

% R peak detection
% This will find all peaks with amplitude greater than 0.5 and a minimum distance of 100 samples between adjacent peaks. 
% The peaks variable will contain the amplitudes of the detected peaks, and the locs variable will contain their corresponding sample indices.
[peaks,locs] = findpeaks(ecg_higher, 'MinPeakHeight', 0.5, 'MinPeakDistance', 100);
subplot(4,1,4);
plot(ecg_higher);
xlabel('Time (s)');
ylabel('Amplitude');
title('Peak Detection');
hold on;
plot(locs, peaks, 'ro');


rr_intervals = diff(locs) / fs;
% Compute the mean R-R interval
mean_rr = mean(rr_intervals);
% Compute the SD of R-R intervals
sd_rr = std(rr_intervals);
% Compute the successive differences between adjacent R-R intervals
prv = diff(rr_intervals);
% Compute the RMS of R-R intervals
rms_rr = rms(rr_intervals);
% Display the RMS of R-R intervals
disp(rms_rr);
% Display the PRV feature
disp(prv);
% Display the SD of R-R intervals
disp(sd_rr);
% Display the mean R-R interval
disp(mean_rr);

