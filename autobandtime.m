%% Initialize
clear all;
folder = '/Users/mt/Desktop/PROGRAM/mathmodelingcontest/data_json'; % Change this to your folder path
% Get a list of all JSON files in the folder
files = dir(fullfile(folder, '*.json'));
% Check the total number of files
numFiles = 6300;
% Define frequency range
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
% Generate frequency vector
frequencies = startFreq:stepFreq:endFreq;
% 
% numFrequencies = length(frequencies);
frequenciesPerPiece = length(frequencies) / 100;
% load('subspectrumData.mat');
load('spectrumData.mat');
load('bandtime.mat');
load('spectrumAndThreshold.mat', 'thresholdCurve');
if isfile('subspectrumData.mat')
    load('subspectrumData.mat', 'subspectrumData','index', 'lastProcessed');
else
    % Read the first file to determine the number of frequency points
    firstFile = jsondecode(fileread(fullfile(folder, files(1).name)));
    numFrequencies = round(frequenciesPerPiece);
    % Initialize the matrix to hold the spectrum data
    subspectrumData = zeros(numFiles, numFrequencies);
    index=71;
    lastProcessed = 0;
end
for j=index:100
    %% Save subspectrum
    % Choose which piece to analyze (1 through 100)
    chosenPiece = j;  % for example, the 50th piece
    startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
    endIndex = round(chosenPiece * frequenciesPerPiece);
  
    for k = (lastProcessed + 1):numFiles
        fprintf('%d Processed file: %s\n',j,  files(k).name);
        filename = fullfile(folder, files(k).name);
        jsonData = jsondecode(fileread(filename));
        % Assuming jsonData.data contains the frequency data for this time sample
        subspectrumData(k, :) = jsonData.data(startIndex:endIndex);
        % Save data every 60 files
        if mod(k, 300) == 0
            lastProcessed = k;
            subspectrumData=subspectrumData(1:k,:);
            index=j;
            save('subspectrumData.mat', 'subspectrumData', 'lastProcessed','index', '-v7.3');
            fprintf('Data saved at iteration %d\n', k);
            if k==6300
                lastProcessed=0;
                subspectrumData=subspectrumData(1:k,:);
                index=j;
                save('subspectrumData.mat', 'subspectrumData', 'lastProcessed','index' ,'-v7.3');
                break
            end
        end

    end
    %% Calculate bandtime
    load('subspectrumData.mat', 'subspectrumData');
    selectedTimePoint = 1:6300;
    pieceData = subspectrumData;
    [a,b]=size(subspectrumData);
    pieceThreshold = thresholdCurve(startIndex:endIndex);
    pieceFrequencies = frequencies(startIndex:endIndex);
    while b>length(pieceThreshold)
        subspectrumData=subspectrumData(:,1:b-1);
        b=b-1;
    end
    if b<length(pieceThreshold)
        pieceThreshold=pieceThreshold(:,1:b);
    end
    %% Comparation
    % Compare the data with the threshold curve
    % Above the threshold is 1, and less than the threshold is 0
    binaryClassification = pieceData > pieceThreshold;
    % 
    % Convert logical array to double for further processing if needed
    binaryClassification = double(binaryClassification);

    % Initialize a vector to store the percentage of '1's for each time point
    percentageOnes = zeros(size(spectrumData, 1), 1);

    [time, freq]=size(binaryClassification);
    for i=1:time
        percentageOnes(i)=100*sum(binaryClassification(i,:))/freq;
    end
    bandtime(chosenPiece,:)=percentageOnes;
    %% Ploting for one piece of frequency over time
    % Plot the percentage change over time
    save("bandtime.mat","bandtime");
    fprintf("Iterate number: %d",j);
end