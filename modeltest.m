clear all;

%% 加载数据
% load('subspectrumData1.mat');
load('bandtime.mat');

% 选择时间序列数据
timeSeriesData = bandtime(10,:);
% Select the time series data from the spectrum data
y = bandtime(9,:)';
trendComponent = smoothdata(y, 'movmean', 12); % Smooth the data
y = trendComponent(1:6200); % Use smoothed data for fitting
exogenousData=[bandtime(5,:) ; bandtime(10,:);bandtime(12,:)];


%% 建立ARIMA模型（示例中没有使用外生变量，实际应用中需要添加外生变量X）
% Fit ARIMA model
Mdl = arima(13,1,13);
% Here we assume 'X' is your matrix of exogenous variables
X = exogenousData(:,1:6214)'; % Match the rows of your exogenous data to the time series data
% Include the exogenous variables in the model - this is what makes it an ARIMAX model
EstMdl = estimate(Mdl, y, 'X', X);

% Uncomment the above line and comment out the line below when you have your exogenous variables
% EstMdl = estimate(Mdl, y);
% Forecast the next 100 values
numForecastSteps = 100;
[yF, yMSE] = forecast(EstMdl, numForecastSteps, 'Y0', y, 'XF', X(end-numForecastSteps+1:end,:));


%% 评估值
% Uncomment the above line and comment out the line below when you have your exogenous variables
% [yF, yMSE] = forecast(EstMdl, numForecastSteps, 'Y0', y);

% Confidence bounds
UB = yF + 1.96*sqrt(yMSE);
LB = yF - 1.96*sqrt(yMSE);

% Assuming 'y_actual' contains the actual observed values
% and 'y_predicted' contains the values predicted by your model
y_actual = trendComponent(6201:6300,1); % Replace with your actual data
y_predicted = yF; % Replace with your model's predictions

% Calculate MAE
MAE = mean(abs(y_actual - y_predicted));
fprintf('Mean Absolute Error (MAE): %f\n', MAE);

% Calculate MSE
MSE = mean((y_actual - y_predicted).^2);
fprintf('Mean Squared Error (MSE): %f\n', MSE);

% Calculate RMSE
RMSE = sqrt(MSE);
fprintf('Root Mean Squared Error (RMSE): %f\n', RMSE);

% Calculate R^2
SS_res = sum((y_actual - y_predicted).^2);
SS_tot = sum((y_actual - mean(y_actual)).^2);
R_squared = 1 - (SS_res / SS_tot);
fprintf('Coefficient of Determination (R^2): %f\n', R_squared);


% % 参数显著性检验
disp('参数的t统计量和p值：');
for i = 1:length(EstMdl.ParameterNames)
    param = EstMdl.ParameterNames{i};
    coef = EstMdl.(param);
    stderr = sqrt(EstParamCov(i,i));
    tStat = coef / stderr;
    pValue = 2 * (1 - normcdf(abs(tStat), 0, 1));
    fprintf('%s: Coefficient = %f, tStat = %f, pValue = %f\n', param, coef, tStat, pValue);
end
% 
% % 残差诊断
% res = infer(EstMdl, y);
% figure;
% subplot(2,1,1);
% plot(res);
% title('残差');
% 
% subplot(2,1,2);
% autocorr(res);
% title('残差的自相关函数');
% 
% % 模型的整体显著性检验可以通过观察似然比检验和AIC、BIC指标来完成
% disp('模型的似然比检验：');
% [~,pValueLR,stat,cValue] = lratiotest(info.LogLikelihood, logL, info.NumEstimatedParameters);
% fprintf('p值：%f\n', pValueLR);
% disp('AIC和BIC值：');
% aic = aicbic(logL, info.NumEstimatedParameters, length(y));
% bic = aicbic(logL, info.NumEstimatedParameters, length(y), 'BIC');
% fprintf('AIC: %f\n', aic);
% fprintf('BIC: %f\n', bic);
