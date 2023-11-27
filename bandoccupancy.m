%% initialization
clear all;
load('spectrumData.mat');
load("thresholdCurve.mat");
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
frequencies = startFreq:stepFreq:endFreq;


%% Cut into pieces
% [time, freq] = size(spectrumData)
numFrequencies = length(frequencies);
frequenciesPerPiece = numFrequencies / 100;


% Choose which piece to analyze (1 through 100)
% chosenPiece = 1;  % for example, the 50th piece
% 
% % Calculate the index range for the chosen piece
% startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
% endIndex = round(chosenPiece * frequenciesPerPiece);
% 
% % Extract the chosen piece of data and threshold curve
% selectedTimePoint = 1:900;
% pieceData = spectrumData(selectedTimePoint, startIndex:endIndex);
% pieceThreshold = ThresholdCurv(startIndex:endIndex);
% pieceFrequencies = frequencies(startIndex:endIndex);


%% Comparation
% Compare the data with the threshold curve
% Above the threshold is 1, and less than the threshold is 0
% binaryClassification = pieceData > pieceThreshold;
% 
% % Convert logical array to double for further processing if needed
% binaryClassification = double(binaryClassification);
% 
% % Initialize a vector to store the percentage of '1's for each time point
% percentageOnes = zeros(size(spectrumData, 1), 1);
% 
% % Compute the percentage of '1's for each row in binaryClassification
% % for i = 1:size(binaryClassification, 1)
% %     percentageOnes(i) = 100 * sum(binaryClassification(i, :)) / numel(binaryClassification(i, :));
% % end
% 
% [time, freq]=size(binaryClassification);
% for i=1:time
%     percentageOnes(i)=100*sum(binaryClassification(i,:))/freq;
% end

%% Ploting for one piece of frequency over time
% Plot the percentage change over time
% figure;
% plot(1:size(spectrumData, 1), percentageOnes, 'LineWidth', 2);
% xlabel('Time Point Index(10s interval)');
% ylabel('Percentage of Frequencies Above Threshold(%)');
% title('Percentage of Frequencies Above Threshold Over Time');
% grid on;
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


%% Calculate occupancy rate change over pieces
percentageOnes = zeros(100, 1);
for j=1:100
    % Choose which piece to analyze (1 through 100)
    chosenPiece = j;  % for example, the 50th piece

    % Calculate the index range for the chosen piece
    startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
    endIndex = round(chosenPiece * frequenciesPerPiece);

    % Extract the chosen piece of data and threshold curve
    selectedTimePoint = 1:900;
    pieceData = spectrumData(selectedTimePoint, startIndex:endIndex);
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

    fprintf("Iterate time: %d \n",j);
end

figure;
plot(1:100, percentageOnes);
xlabel('Frequency band Index');
ylabel('Percentage of Frequencies Above Threshold(%)');
title('Average Percentage of Frequencies Above Threshold Over Frequency');
grid on;

