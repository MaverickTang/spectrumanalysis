% Assuming you have a binary vector 'signalPresent' of the same length as your
% intensity data where 1 represents a signal present and 0 represents noise
clear all;
load('spectrumData.mat', 'spectrumData');
% Assuming 'spectrumData' is loaded and you've selected a specific frequency
intensity = spectrumData(:, 1); % Replace frequencyIndex with the index of the frequency you are analyzing

% Define a range of possible threshold values based on your intensity data
thresholdRange = linspace(min(intensity), max(intensity), 100);

% Initialize vectors to store TPR and FPR
TPR = zeros(length(thresholdRange), 1);
FPR = zeros(length(thresholdRange), 1);

% Calculate TPR and FPR for each threshold
for i = 1:length(thresholdRange)
    threshold = thresholdRange(i);
    % Classify each intensity reading based on the current threshold
    predictedSignal = intensity > threshold;
    
    % True positives: Signal is present and intensity is above the threshold
    TP = sum((signalPresent == 1) & (predictedSignal == 1));
    
    % False positives: Signal is absent but intensity is above the threshold
    FP = sum((signalPresent == 0) & (predictedSignal == 1));
    
    % True negatives: Signal is absent and intensity is below the threshold
    TN = sum((signalPresent == 0) & (predictedSignal == 0));
    
    % False negatives: Signal is present but intensity is below the threshold
    FN = sum((signalPresent == 1) & (predictedSignal == 0));
    
    % Compute True Positive Rate (TPR) and False Positive Rate (FPR)
    TPR(i) = TP / (TP + FN);
    FPR(i) = FP / (FP + TN);
end

% Plot the ROC Curve
figure;
plot(FPR, TPR, 'b-', 'LineWidth', 2);
xlabel('False Positive Rate');
ylabel('True Positive Rate');
title('ROC Curve for Frequency Intensity Threshold');

% Find the optimal threshold (You can use different criteria like Youden's index)
[~, optimalIdx] = max(TPR - FPR);
optimalThreshold = thresholdRange(optimalIdx);

% Highlight the optimal point on the ROC curve
hold on;
plot(FPR(optimalIdx), TPR(optimalIdx), 'ro');