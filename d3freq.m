% Define frequency parameters
startFreq = 20e6; % 20 MHz
endFreq = 6e9; % 6 GHz
stepFreq = 25e3; % 25 kHz
frequencies = startFreq:stepFreq:endFreq;

% Define the subset of frequencies you want to plot
chosenPiece = 1; % For example, the 1st piece
numFrequencies = length(frequencies);
frequenciesPerPiece = numFrequencies / 100; % Divide into 100 pieces
startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
endIndex = round(chosenPiece * frequenciesPerPiece);
frequenciesSubset = frequencies(startIndex:endIndex);

% Define your JSON files folder and get the list of files
folder = '/Users/mt/Desktop/PROGRAM/mathmodelingcontest/data_json';
files = dir(fullfile(folder, '*.json'));

% Determine the number of files to process
numFiles = 50; % Process only the first 50 files for example

% Preallocate the matrix for the subset of data
allDataSubset = zeros(numFiles, length(frequenciesSubset)); % Ensure this matches the size of frequenciesSubset

% Loop through the first 50 files and extract the data subset
for k = 1:numFiles
    filename = fullfile(folder, files(k).name);
    jsonData = jsondecode(fileread(filename));
    dataSubset = jsonData.data(startIndex:endIndex); % Get the data for the chosen frequency range
    allDataSubset(k, :) = dataSubset;
    fprintf('Processed file %d of %d: %s\n', k, numFiles, files(k).name);
end

% Generate time indices for the files
timeIndices = 1:numFiles;

% Generate a meshgrid for the subset of frequencies and times for plotting
[F, T] = meshgrid(frequenciesSubset, timeIndices);

% Now plot the data in 3D using the 'surf' function
figure;
surf(F, T, allDataSubset);
shading interp; % Optional, to smooth the appearance of the surface
xlabel('Frequency (Hz)');
ylabel('Time Index');
zlabel('Intensity');
title('3D Plot of Intensity over Frequency and Time (Subset)');
