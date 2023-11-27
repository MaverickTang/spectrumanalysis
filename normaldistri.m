load("subspectrumData2.mat");
% 假设 subspectrumData 是已经存在的变量，且第5列是我们要检验的数据
dataColumn = subspectrumData(:, 2300);

% 绘制直方图
figure;
histogram(dataColumn);
title('Data Histogram');
xlabel('Intensity');
ylabel('Frequency');

% 计算描述统计量
meanValue = mean(dataColumn);
medianValue = median(dataColumn);
skewnessValue = skewness(dataColumn);
kurtosisValue = kurtosis(dataColumn);

% 显示描述统计量
disp(['Mean: ', num2str(meanValue)]);
disp(['Median: ', num2str(medianValue)]);
disp(['Skewness: ', num2str(skewnessValue)]);
disp(['Kurtosis: ', num2str(kurtosisValue)]);

% 进行Jarque-Bera检验
[h_jb, p_jb] = jbtest(dataColumn);

% 显示Jarque-Bera检验结果
disp(['JB Test H0 rejected: ', num2str(h_jb)]);
disp(['JB Test p-value: ', num2str(p_jb)]);

% 进行Lilliefors检验
[h_lil, p_lil] = lillietest(dataColumn);

% 显示Lilliefors检验结果
disp(['Lilliefors Test H0 rejected: ', num2str(h_lil)]);
disp(['Lilliefors Test p-value: ', num2str(p_lil)]);

% 计算均值（期望）
mu = mean(dataColumn);

% 计算标准差（sigma）
sigma = std(dataColumn);

% 显示计算结果
disp(['期望（mu）: ', num2str(mu)]);
disp(['标准偏差（sigma）: ', num2str(sigma)]);

load("spectrumData");
% Assuming spectrumData is a 1500x23901 matrix

% Initialize matrices to store expectation and sigma values
expectation = zeros(1, size(spectrumData, 2));
sigma = zeros(1, size(spectrumData, 2));

% Calculate expectation (mean) and sigma (standard deviation) for each column
for i = 1:size(spectrumData, 2)
    expectation(i) = mean(spectrumData(:, i));
    sigma(i) = std(spectrumData(:, i));
end
% expectation now contains the mean of each frequency point across all time samples
% sigma now contains the standard deviation of each frequency point across all time samples
startFreq = 20e6; % 20 MHz in Hz
endFreq = 6e9;    % 6 GHz in Hz
stepFreq = 25e3;  % 25 kHz in Hz
frequencies = startFreq:stepFreq:endFreq;
figure;
plot(frequencies, spectrumData(1,:));
hold on;
plot(frequencies,expectation+3*sigma);
hold off;





