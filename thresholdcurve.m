clear all;
load('spectrumData.mat', 'spectrumData');
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
frequencies = startFreq:stepFreq:endFreq;

% Use only the first n rows of spectrumData
% subsetSpectrumData = spectrumData(1:900, :);
% 
% % Estimate the noise floor by taking the median across the subset data points for each frequency
% noiseFloorPerFrequency = median(subsetSpectrumData, 1);
% 
% % To create a more consistent noise floor, take the median of the noiseFloorPerFrequency
% consistentNoiseFloor = median(noiseFloorPerFrequency);
% 
% % Set a threshold a certain number of dB above the consistent noise floor
% dB_above_noise = 75;  % Lower the value to bring the threshold closer to the noise floor
% thresholdCurve = consistentNoiseFloor + dB_above_noise;
% 
% % Smoothing the noise floor before calculating the threshold
% % This step is now done on a consistent noise floor instead of per frequency
% smoothedNoiseFloor = smooth(noiseFloorPerFrequency, 'loess');
% 
% % Now calculate the threshold based on the smoothed noise floor
% smoothedThresholdCurve = smoothedNoiseFloor + dB_above_noise;
% 
% % Plot the intensity data for the first row of the subset
% figure;
% plot(frequencies, subsetSpectrumData(1, :), 'b');
% hold on;
% % % Overlay the smoothed threshold curve
% plot(frequencies, smoothedThresholdCurve, 'r-', 'LineWidth', 2);
% % 
% % % Set plot labels and title
% xlabel('Frequency (Hz)');
% ylabel('Intensity (dB)');
% title('Frequency Intensity and Threshold Curve');
% legend('Intensity Data', 'Threshold Curve');
% % 
% % % Adjust the y-axis limits to include the threshold
% ylim([min(smoothedThresholdCurve) - 10, max(subsetSpectrumData(1, :)) + 10]);
% % 
% grid on;
% hold off;
% 
% % The degree of the polynomial can be changed. Here, we're using a 2nd-degree polynomial as an example.
% [p, S, mu] = polyfit(frequencies, smoothedThresholdCurve, 30);
% 
% % Evaluate the polynomial fit to get the trend line
% trendLine = polyval(p, frequencies, S, mu);
% ThresholdCurv = trendLine;
% [lastProcessed,aaaa]=size(spectrumData);
% save("spectrumData.mat","ThresholdCurv","spectrumData",'lastProcessed', '-v7.3')
% 
% % Plot the original threshold curve
% figure;
% % plot(frequencies, smoothedThresholdCurve, 'b-', 'LineWidth', 1);
% plot(frequencies, subsetSpectrumData(1, :), 'b');
% hold on;
% 
% % Overlay the trend line
% plot(frequencies, trendLine, 'r-', 'LineWidth', 2);
% 
% % Label the plot
% xlabel('Frequency (Hz)');
% ylabel('Intensity (dB)');
% title('Spectrum and Trend Line');
% legend('Spectrum', 'Trend Line');
% 
% % Ensure the plot is visually comprehensible
% ylim([min(spectrumData(1, :)) - 10, max(spectrumData(1, :)) + 10]);
% 
% 
% grid on;
% hold off;

% Assuming subspectrumData is already loaded and contains the noise power data

% Step 1: Calculate the Average Noise Power Level for each frequency point
% If the data is not in dB, convert it to dB. Assuming it's already in dB here.
averageNoiseLevel = mean(spectrumData, 1); % Average across rows (samples)

% Step 2: Determine the Threshold Curve
thresholdCurve = averageNoiseLevel + 5; % Add 5 dB to the average noise level

% Plot the threshold curve for visualization
figure;
plot(frequencies, thresholdCurve);
xlabel('Frequency (Hz)');
ylabel('Threshold Level (dB)');
title('Threshold Curve');

% Optionally, save the results
save('thresholdCurve.mat', 'thresholdCurve');



