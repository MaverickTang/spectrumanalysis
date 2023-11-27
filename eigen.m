clear;

%% 步骤1: 从bandtime.mat中加载正常数据集
load('bandtime.mat');

%% 步骤2: 计算协方差矩阵和特征向量
covMatrix = cov(bandtime');
[eigVectors, eigValues] = eig(covMatrix, 'vector');

%% 步骤3: 加载新的频率区间占用比数据

startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
frequencies = startFreq:stepFreq:endFreq;
load("anomalyData.mat","anomalyData");
load("thresholdCurve.mat");
spectrumData = anomalyData;
% Cut into pieces
% [time, freq] = size(spectrumData)
numFrequencies = length(frequencies);
frequenciesPerPiece = numFrequencies / 100;
percentageOnes = zeros(100, 1);
for j=1:100
    % Choose which piece to analyze (1 through 100)
    chosenPiece = j;  % for example, the 50th piece

    % Calculate the index range for the chosen piece
    startIndex = round((chosenPiece - 1) * frequenciesPerPiece + 1);
    endIndex = round(chosenPiece * frequenciesPerPiece);

    % Extract the chosen piece of data and threshold curve
    selectedTimePoint = 1;
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
% load('newBandTime.mat'); % newBandTime 是100x1的矩阵
newBandTime=percentageOnes;

% 将新数据投影到特征空间
projectedData = eigVectors' * (newBandTime - mean(bandtime, 2));

%% 步骤4: 计算新数据的Mahalanobis距离
% 计算协方差矩阵
covMatrix = cov(bandtime');

% 使用伪逆代替标准逆
invCovMatrix = pinv(covMatrix);

% 初始化Mahalanobis距离数组
mahalanobisDistances = zeros(1, size(bandtime, 2));

% 计算每个样本的Mahalanobis距离
for i = 1:size(bandtime, 2)
    delta = (bandtime(:, i) - mean(bandtime, 2))';
    distanceSquared = delta * invCovMatrix * delta';
    if distanceSquared < 0
        warning('Negative squared distance encountered at index %d', i);
        mahalanobisDistances(i) = NaN; % 标记为NaN以表明计算问题
    else
        mahalanobisDistances(i) = sqrt(distanceSquared);
    end
end

% 移除任何NaN值，以便能够计算阈值
mahalanobisDistances = mahalanobisDistances(~isnan(mahalanobisDistances));

% 计算阈值
threshold = prctile(mahalanobisDistances, 95);

if isnan(threshold)
    error('Threshold computation failed.');
end

% 步骤7: 检测是否存在异常
isAnomaly = mahalanobisDistances > threshold;

% 显示结果
if isAnomaly
    fprintf('新的频率区间占用比数据被检测为异常。\n');
else
    fprintf('新的频率区间占用比数据没有检测到异常。\n');
end

% 可视化结果（可选）
figure;
bar(projectedData);
hold on;
if isAnomaly
    title('Detected Anomaly in Projected Feature Space');
else
    title('No Anomaly Detected in Projected Feature Space');
end
xlabel('Feature Index');
ylabel('Projection Value');
hold off;
