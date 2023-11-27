clear all;
%% 载入原始数据
load('spectrumData.mat'); % 确保 spectrumData 变量现在在工作区中
% 数据参数
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
frequencies = startFreq:stepFreq:endFreq;

numTimeSamples = 1500; % 时间点数
numFrequencyBands = 239201; % 频率点数
frequenciesPerPiece = length(frequencies) / 100;


% 设置异常比例
ratioanomalies = 0.2;
anomalyData = spectrumData;

for j = 1:numTimeSamples
%     % 引入加性异常
    numAdditiveAnomalies = round(ratioanomalies * numFrequencyBands/4); % 加性异常的数量
    additiveFrequencies = randi([1, numFrequencyBands], numAdditiveAnomalies, 1);
    additiveAnomalyMagnitude = 180*rand();
    % 200; % 加性异常的幅度
    weirdadditiveAnomalyMagnitude = 180 + 400*rand();

    % 生成新息异常
    numInnovativeAnomalies = round(ratioanomalies * numFrequencyBands / 6); % 新息异常的数量
    innovativeFrequencies = randi([1, numFrequencyBands], numInnovativeAnomalies, 1);
    innovativeAnomalyMagnitude = 180*rand(50); % 新息异常的幅度
    weirdinnovativeAnomalyMagnitude=180 + 400*rand(50);

    % 应用加性异常
    for i = 1:numAdditiveAnomalies
        if mod(rand(),2)
            anomalyData(j, additiveFrequencies(i)) = anomalyData(j, additiveFrequencies(i)) + additiveAnomalyMagnitude;
        else
            anomalyData(j, additiveFrequencies(i)) = anomalyData(j, additiveFrequencies(i)) + weirdadditiveAnomalyMagnitude;
        end
    end
    decidedd=round(2*rand());
    % 应用新息异常
    if mod(j,50)==1
        for i = 1:numInnovativeAnomalies
            for k=1:50
                if j+k<numTimeSamples
                    if mod(decidedd,2)==1
                        anomalyData(j+k, innovativeFrequencies(i)) = anomalyData(j+k, innovativeFrequencies(i))+innovativeAnomalyMagnitude(k);
                    else
                        anomalyData(j+k, innovativeFrequencies(i)) = anomalyData(j+k, innovativeFrequencies(i))+weirdinnovativeAnomalyMagnitude(k);
                    end
                end
            end
        end
    end
end

fprintf("Noisiation over");
save("anomalyData.mat","anomalyData","-v7.3")
% Choose a specific time point to plot
% timePointToPlot = 436;
% 
% % Create the figure and plot the original data
% figure;
% subplot(1,2,1);
% plot(frequencies, spectrumData(timePointToPlot, :)); % Convert to decibels if required
% title('Original Data');
% xlabel('Frequency (Hz)');
% ylabel('Intensity (dB)');
% 
% % Plot the anomaly data
% subplot(1,2,2);
% plot(frequencies, anomalyData(timePointToPlot, :)); % Convert to decibels if required
% hold on;
% % Highlight differences where anomalyData exceeds the threshold
% % Note: You may need to adjust this if 'threbynormal' isn't already in dB
% exceededThreshold = anomalyData(timePointToPlot, :) >spectrumData(timePointToPlot, :) ;
% highlightFrequencies = frequencies(exceededThreshold);
% highlightIntensities = anomalyData(timePointToPlot, exceededThreshold);
% plot(highlightFrequencies, highlightIntensities, 'r*', 'MarkerSize', 2);
% 
% title('Anomaly Data with Differences Highlighted');
% xlabel('Frequency (Hz)');
% ylabel('Intensity (dB)');
% legend('Anomaly Data', 'Adding noise');
% hold off;

% Define the sizes
% nRows = 1000;
% nCols = 239201;

% Initialize the matrices
% mixedData = zeros(nRows, nCols);
% originMatrix = zeros(nRows, 1); % 1 for spectrumData, 0 for anomalyData

% Randomly select rows from either anomalyData or spectrumData
% for i = 1:nRows
%     if rand() < 0.5
%         % Select a row from spectrumData
%         % rowIndex = randi(size(spectrumData, 1));
%         mixedData(i, :) = spectrumData(i, :);
%         originMatrix(i) = 1; % Mark as from spectrumData
%     else
%         % Select a row from anomalyData
%         % rowIndex = randi(size(anomalyData, 1));
%         mixedData(i, :) = anomalyData(i, :);
%         % originMatrix(i) is already 0, so no need to set it again
%     end
%     fprintf("%d\n",i);
% end

% anomalyData=mixedData;
% save("anomalyData.mat","anomalyData", "originMatrix","-v7.3");


