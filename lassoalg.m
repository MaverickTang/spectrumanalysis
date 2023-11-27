%% 相关性验证
% Assuming 'occupancyData' is a matrix where each column is an occupancy curve over time for a different frequency piece
clear all;
% load('subspectrumData1.mat');
load('bandtime.mat');
% Define response variable (Y)
% For example, we can take one frequency piece as the response variable and try to predict its values
% based on the values of all other pieces. Here, the first column is taken as the response.
Y = bandtime(9, :)';
% Define predictor variables (X)
% All other columns are used as predictors. We remove the first column that we used as the response variable.
X = [bandtime(1,:);bandtime(2,:);bandtime(3,:);bandtime(4,:);bandtime(5,:);bandtime(6,:);bandtime(7,:);bandtime(8,:);bandtime(10,:);bandtime(11,:);bandtime(12,:);bandtime(13,:);bandtime(14,:);bandtime(15,:);bandtime(16,:);bandtime(17,:)]';

% 5,10,12

% Run lasso regression
% The function will return a matrix B of coefficient values, where each column corresponds to a particular value of Lambda
[B, FitInfo] = lasso(X, Y, 'CV', 10);

% B contains the coefficients of the predictors for each lambda value tried during the lasso regression.
% FitInfo is a structure that contains the lambda values used and the mean squared errors for each lambda during cross-validation.

% Find the index of the lambda value that gives the minimum mean squared error (MSE)
minMSEIndex = FitInfo.IndexMinMSE;
optimalLambda = FitInfo.Lambda(minMSEIndex);

% Extract the coefficient values for the optimal lambda
optimalCoefficients = B(:, minMSEIndex);

% Display the optimal lambda and its corresponding coefficients
fprintf('Optimal Lambda: %f\n', optimalLambda);
disp('Optimal Coefficients for Predictors:');
disp(optimalCoefficients);

% If needed, plot the coefficient progression for a visual inspection
lassoPlot(B, FitInfo, 'PlotType', 'Lambda', 'XScale', 'log');


% Assuming 'B' and 'FitInfo' are obtained from the lasso function
[B, FitInfo] = lasso(X, Y, 'CV', 10); % Replace X and Y with your data

% Create a new figure
figure;

% Plot the LASSO coefficients against log-scaled Lambda values
% Each row of B corresponds to a variable, and each column corresponds to a lambda value
for i = 1:size(B, 1)
    logLambda = log(FitInfo.Lambda);
    plot(logLambda, B(i, :), 'LineWidth', 2);
    hold on; % Hold on to plot all coefficients on the same graph
end
hold off;

% Customize the plot
set(gca, 'XDir'); % Reverse the x-axis direction for log scale
xlabel('Log(\lambda)');
ylabel('Coefficients');
title('Trace Plot of Coefficients Fit by Lasso');

% Manually set the x-axis to log scale
ax = gca;
ax.XScale = 'log';
xlim([min(logLambda) max(logLambda)]); % Set x-axis limits to cover all lambda values

% Remove 'df' from the top by not adding it, since we are creating a custom plot

% Optionally, add a vertical line at the value of Lambda that gives minimum MSE
[minMSE, minIndex] = min(FitInfo.MSE);
minLambda = FitInfo.Lambda(minIndex);
line(log([minLambda minLambda]), ylim, 'Color', 'k', 'LineStyle', '--', 'LineWidth', 1.5);

% Add legend if needed
legend(arrayfun(@(x) sprintf('Var %d', x), 1:size(B, 1), 'UniformOutput', false));

% 找到与 optimalLambda 相对应的系数
lambdaIndex = find(FitInfo.Lambda == optimalLambda);
selectedCoefficients = B(:, lambdaIndex)

% 确定非零系数的特征
selectedFeatures = find(selectedCoefficients);

% 显示选中的特征索引
disp('chosen charateriestic index:');
disp(selectedFeatures);

% 如果您有特征的名称列表，也可以显示选中的特征名称
% 假设 featureNames 是一个包含特征名称的字符串数组
% featureNames = ["特征1", "特征2", ..., "特征N"];  % 替换为您的特征名称
% disp('选中的特征名称:');
% disp(featureNames(selectedFeatures));


