clear all;
folder = '/Users/mt/Desktop/PROGRAM/mathmodelingcontest/data_json'; % Change this to your folder path
% Get a list of all JSON files in the folder
files = dir(fullfile(folder, '*.json'));
% Check the total number of files
numFiles = length(files);
% Define frequency range
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
% Generate frequency vector
frequencies = startFreq:stepFreq:endFreq;

% Attempt to load existing data
if isfile('spectrumData.mat')
    load('spectrumData.mat', 'spectrumData', 'lastProcessed');
else
    % Read the first file to determine the number of frequency points
    firstFile = jsondecode(fileread(fullfile(folder, files(1).name)));
    numFrequencies = length(firstFile.data);

    % Initialize the matrix to hold the spectrum data
    spectrumData = zeros(numFiles, numFrequencies);
    lastProcessed = 0;
end

% Loop through the files and populate the matrix
for k = (lastProcessed + 1):numFiles
    fprintf('Processed file: %s\n', files(k).name);
    filename = fullfile(folder, files(k).name);
    jsonData = jsondecode(fileread(filename));
    % Assuming jsonData.data contains the frequency data for this time sample
    spectrumData(k, :) = jsonData.data;

    % Save data every 60 files
    if mod(k, 300) == 0
        lastProcessed = k;
        spectrumData=spectrumData(1:k,:);
        save('spectrumData.mat', 'spectrumData', 'lastProcessed', '-v7.3');
        fprintf('Data saved at iteration %d\n', k);
        break
    end
end

% Final save after completing the loop
% lastProcessed = numFiles;
% save('spectrumData.mat', 'spectrumData', 'lastProcessed', '-v7.3');
