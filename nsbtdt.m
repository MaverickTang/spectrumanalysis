%% Step 1: Load the normal data
load('bandtime.mat'); % 'spectrumData' should contain the normal data

startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
frequencies = startFreq:stepFreq:endFreq;
numFrequencies = length(frequencies);
frequenciesPerPiece = numFrequencies / 100;
load("anomalyData.mat","anomalyData");
load("subspectrumData2.mat")
load("thresholdCurve.mat");
chosenPiece = 2;  % for example, the 50th piece
selectedTimePoint=1:50;
startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
endIndex = round(chosenPiece * frequenciesPerPiece);
pieceData = spectrumData(selectedTimePoint, startIndex:endIndex);
pieceThreshold = thresholdCurve(startIndex:endIndex);
pieceFrequencies = frequencies(startIndex:endIndex);

%% New bandtime for anomalyData
afterband=zeros(100,50);
%% Calculate occupancy rate change over pieces
for i=selectedTimePoint
    percentageOnes = zeros(100, 1);
    for j=1:100
    % Choose which piece to analyze (1 through 100)
        chosenPiece = j;  % for example, the 50th piece
        % Calculate the index range for the chosen piece
        startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
        endIndex = round(chosenPiece * frequenciesPerPiece);
        % Extract the chosen piece of data and threshold curve
        pieceData = anomalyData(i, startIndex:endIndex);
        pieceThreshold = thresholdCurve(startIndex:endIndex);
        pieceFrequencies = frequencies(startIndex:endIndex);
        % Compare the data with the threshold curve
        % Above the threshold is 1, and less than the threshold is 0
        binaryClassification = pieceData > pieceThreshold;
        % Convert logical array to double for further processing if needed
        binaryClassification = double(binaryClassification);
        [time, freq]=size(binaryClassification);
        % Compute the total number of '1's in the binaryClassification matrix
        totalOnes = sum(binaryClassification(:));  % This sums all elements in the matrix
        percentageOnes(j)=100*totalOnes/(freq*time);
        % fprintf("Iterate time: %d \n",j);
    end
    afterband(:,i)=percentageOnes;
    fprintf("Iterate time: %d \n",i);
end

