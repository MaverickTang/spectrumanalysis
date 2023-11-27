%% initialization
clear all;
load('subspectrumData1.mat');
load('spectrumData.mat');
load('spectrumAndThreshold.mat', 'thresholdCurve', 'frequencies');
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
% frequencies = startFreq:stepFreq:endFreq;

%% Cut into pieces
% [time, freq] = size(spectrumData)
numFrequencies = length(frequencies);
frequenciesPerPiece = numFrequencies / 100;

% Choose which piece to analyze (1 through 100)
chosenPiece = 36; 

if isfile('bandtime.mat')
    load('bandtime.mat');
else
    % Initialize the matrix to hold the spectrum data
    bandtime = zeros(100, 6300);
end
% 
% % Calculate the index range for the chosen piece
startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
endIndex = round(chosenPiece * frequenciesPerPiece);
% 
% % Extract the chosen piece of data and threshold curve
selectedTimePoint = 1:6300;
pieceData = subspectrumData;
pieceThreshold = thresholdCurve(startIndex:endIndex);
pieceFrequencies = frequencies(startIndex:endIndex);

%% Comparation
% Compare the data with the threshold curve
% Above the threshold is 1, and less than the threshold is 0
binaryClassification = pieceData > pieceThreshold;
% 
% Convert logical array to double for further processing if needed
binaryClassification = double(binaryClassification);
% 
% Initialize a vector to store the percentage of '1's for each time point
percentageOnes = zeros(size(spectrumData, 1), 1);
% 
% % Compute the percentage of '1's for each row in binaryClassification
% % for i = 1:size(binaryClassification, 1)
% %     percentageOnes(i) = 100 * sum(binaryClassification(i, :)) / numel(binaryClassification(i, :));
% % end
% 
[time, freq]=size(binaryClassification);
for i=1:time
    percentageOnes(i)=100*sum(binaryClassification(i,:))/freq;
end

bandtime(chosenPiece,:)=percentageOnes;
%% Ploting for one piece of frequency over time
% Plot the percentage change over time
save("bandtime.mat","bandtime");
figure;
plot(1:size(subspectrumData, 1), percentageOnes, 'LineWidth', 2);
xlabel('Time Point Index(10s interval)');
ylabel('Percentage of Frequencies Above Threshold(%)');
title('Percentage of Frequencies Above Threshold Over Time');
grid on;
% 
% 
% % % Plot the chosen piece with the threshold
% figure;
% plot(pieceFrequencies, pieceData, 'b');
% hold on;
% plot(pieceFrequencies, pieceThreshold, 'r-', 'LineWidth', 2); 
% % % Label the plot
% xlabel('Frequency (Hz)');
% ylabel('Intensity (dB)');
% title(sprintf('Spectrum Piece %d with Threshold Curve', chosenPiece));
% legend('Spectrum Data', 'Threshold Curve');
% % 
% % % Adjust the y-axis limits to include the threshold and the spectrum data
% % % ylim([min(pieceData) - 10, max(pieceData) + 10]);
% % 
% grid on;
% hold off;
% % 
% % % Optionally display the binary classification result
% disp(binaryClassification);
