clear;


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
startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
endIndex = round(chosenPiece * frequenciesPerPiece);
% pieceData = spectrumData(selectedTimePoint, startIndex:endIndex);
% pieceThreshold = thresholdCurve(startIndex:endIndex);
% pieceFrequencies = frequencies(startIndex:endIndex);

%% Calculate if it satisfy normal distribution








%% Reduction
spec=subspectrumData(:,5);
chance=anomalyData-spec>=150;
chance=double(chance);
% rateaa= sum(chance)/126


% Get the frequency indices
indices = 1:length(chance);

figure;

%% Plot the anomalyData. Assuming 'indices' matches the length of 'anomalyData'.
plot(indices, anomalyData, 'b'); % Plot with a blue line
title('Anomaly Detection');
xlabel('Time Index');
ylabel('Signal Strength');

hold on;

% Now, identify the indices where 'chance' equals 1 and highlight these on the plot
anomalyIndices = indices(chance == 1);
highlightedAnomalyData = anomalyData(anomalyIndices);

% Highlight anomalies with red circles
plot(anomalyIndices, highlightedAnomalyData, 'ro', 'MarkerSize', 10, 'LineWidth', 2);

hold off;

% Add a legend to clarify the plot
legend('Anomaly Data', 'Detected Anomalies');

% hold on;
% Highlight points where chance is equal to 1
% anomalyIndices = find(chance == 1);
% freqpieces=frequencies(startIndex:endIndex);
% highlightedFrequencies = freqpieces(anomalyIndices);
% highlightedAnomalyData = anomalyData(anomalyIndices);
% plot(highlightedFrequencies, highlightedAnomalyData, 'r*', 'MarkerSize', 10);
% 
% % Add legend and other plot details
% legend('Anomaly Data', 'Detected Anomalies');
% hold off;


















%% New bandtime for anomalyData
% binaryClassification = pieceData > pieceThreshold;
% binaryClassification = double(binaryClassification);
% percentageOnes = zeros(size(spectrumData, 1), 1);
% [time, freq]=size(binaryClassification);
% for i=1:time
%     percentageOnes(i)=100*sum(binaryClassification(i,:))/freq;
% end







