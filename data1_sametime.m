% Define the folder where your JSON files are located
folder = '/Users/mt/Desktop/PROGRAM/mathmodelingcontest/data_json'; % Change this to your folder path

% Get a list of all JSON files in the folder
files = dir(fullfile(folder, '*.json'));

% % Preallocate cell arrays to store the data and dates from each file
% allData = cell(length(files), 1);
% allDates = cell(length(files), 1);
% 
% % Loop through each file
% for k = 1:2
%     % Construct the full file path
%     filename = fullfile(folder, files(k).name);
%     % Read the JSON file
%     jsonData = jsondecode(fileread(filename));
%     % Extract "data" and "date" from the JSON object
%     allData{k} = jsonData.data; % Assuming 'data' is an array
%     allDates{k} = jsonData.date; % Assuming 'date' is a string
%     % Display progress
%     fprintf('Processed file %d of %d: %s\n', k, 100, files(k).name);
% end

filename = fullfile(folder, files(1).name);
jsonData = jsondecode(fileread(filename));
fprintf('Processed file: %s\n',  files(1).name);
% Assuming 'allData' contains the data arrays from the JSON files
% and you want to plot the data from the first file
dataToPlot = jsonData.data;

% Define frequency range
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz

% Generate frequency vector
frequencies = startFreq:stepFreq:endFreq;
% Check if the length of the data matches the frequency vector length
if length(dataToPlot) == length(frequencies)
    % Plot the data
    plot(frequencies, dataToPlot);
    xlabel('Frequency (Hz)');
    ylabel('Intensity');
    title('Intensity of different frequency at 2020-6-14 00:00:04 ');
else
    error('Data length does not match frequency range length.');
end

% 'allData' and 'allDates' now contain the data and dates from each JSON file
