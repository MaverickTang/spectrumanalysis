clear all;
load('spectrumData.mat', 'spectrumData');
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
frequencies = startFreq:stepFreq:endFreq;

% Calculate the Average Noise Power Level for each frequency point
averageNoiseLevel = mean(spectrumData, 1); % Average across rows (samples)

% Apply smoothing using the 'loess' method
span = 0.01; % Span for the 'loess' method, representing a percentage of the total number of data points
smoothedAverageNoiseLevel = smooth(averageNoiseLevel, span, 'loess');

% Determine the Threshold Curve
% Add 5 dB to the smoothed average noise level
thresholdCurve = smoothedAverageNoiseLevel + 8; 
thresholdCurve = thresholdCurve';
% Plot the original spectrum data and the threshold curve for visualization
figure;
hold on; % Hold on to plot multiple datasets in the same figure

% Plot the original spectrum data
% Assuming we're plotting a sample or the mean of all samples
plot(frequencies, mean(spectrumData, 1), 'b'); % Original spectrum in blue

% Plot the smoothed threshold curve
plot(frequencies, thresholdCurve, 'r', 'LineWidth', 1.5); % Threshold curve in red

% Label the plot
xlabel('Frequency (Hz)');
ylabel('Power Level (dB)');
title('Spectrum and Threshold Curve');
legend('Mean Spectrum', 'Threshold Curve');

% Optionally, save the results
% save('spectrumAndThreshold.mat', 'thresholdCurve', 'frequencies');
hold off; % Release the figure
