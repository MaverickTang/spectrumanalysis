clear all;
folder = '/Users/mt/Desktop/PROGRAM/mathmodelingcontest/data_json'; % Change this to your folder path
% Get a list of all JSON files in the folder
files = dir(fullfile(folder, '*.json'))
% Check the total number of files
numFiles = length(files);

% Initialize an array to store the first data point from every 12th file
selectedData = [];

% Loop through the files, skipping every 12 files
for k = 1:300
    % Construct the full file path
    filename = fullfile(folder, files(k).name);

    % Read the JSON file
    jsonData = jsondecode(fileread(filename));

    % Extract the first data point from the "data" array
    firstDataPoint = jsonData.data(73560); % Assuming 'data' is an array

    % Add the first data point to the array
    selectedData(end+1) = firstDataPoint;

    % Display progress
    fprintf('Processed file %d of %d: %s\n', k, numFiles, files(k).name);
end
% Create a time vector starting at 0:00, with each step representing 24 minutes
timeVector = datetime(0,0,0,0,0,0) + minutes(2*(0:(length(selectedData)-1)));

% Now, plot the selected data points against time
plot(timeVector, selectedData);
% Now, plot the selected data points
plot(selectedData);
xlabel('Time (HH:MM)');
ylabel('Intensity of 500M Hz spectrum(dBm)');
title('Intensity of 500M Hz spectrum over a day');