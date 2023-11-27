clear all;
folder = '/Users/mt/Desktop/PROGRAM/mathmodelingcontest/data_json'; % Change this to your folder path
% Get a list of all JSON files in the folder
load("spectrumData.mat");
files = dir(fullfile(folder, '*.json'));
% Check the total number of files
numFiles = length(files);
% Define frequency range
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz

% Generate frequency vector
frequencies = startFreq:stepFreq:endFreq;
% Loop through the files, skipping every 12 files
for k = 1:12:numFiles
    % % Construct the full file path
    % filename = fullfile(folder, files(k).name);
    % jsonData = jsondecode(fileread(filename));
    % fprintf('Processed file: %s\n',  files(k).name);
    % % Assuming 'allData' contains the data arrays from the JSON files
    % % and you want to plot the data from the first file
    % dataToPlot = jsonData.data;
    % % Check if the length of the data matches the frequency vector length
    % plot(frequencies, dataToPlot);
    % xlabel('Frequency (Hz)');
    % ylabel('Intensity');
    % title('Intensity of different frequency at ', jsonData.date);

    figure;
    plot(frequencies, spectrumData(k, :));
    hold on;

    % Overlay the trend line on top of the original spectrum
    plot(frequencies, ThresholdCurv);
    % Label the plot
    xlabel('Frequency (Hz)');
    ylabel('Intensity (dB)');
    title('Original Spectrum Data with Trend Line');
    legend('Original Spectrum', 'Threshold Trend Line');

    % Adjust the y-axis limits to include the threshold and the spectrum data
    ylim([min(spectrumData(1, :)) - 10, max(spectrumData(1, :)) + 10]);

    grid on;
    hold off;
    pause(1);
end