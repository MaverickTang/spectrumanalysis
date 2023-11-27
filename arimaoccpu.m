clear all;

% Load your actual data file
% load('subspectrumData2.mat');
load('bandtime.mat');
% Select the time series data from the spectrum data
timeSeriesData = bandtime(9,1:6300);
% % Decompose the time series using a moving average for the trend
trendComponent = smoothdata(timeSeriesData, 'movmean', 12); % Change 12 to your specific window size if needed
y = trendComponent(1,1:6200)';

[hypothesis, pValue, ~, ~] = adftest(y);
disp('Check for stationarity again before differencing');
if hypothesis == 0
    disp('The null hypothesis of a unit root cannot be rejected.');
    disp('The differenced time series is non-stationary.');
else
    disp('The null hypothesis of a unit root is rejected.');
    disp('The differenced time series is stationary.');
end
disp(['adftest p-value: ', num2str(pValue)]);

t = 1:length(y);

figure;
dy = diff(y,1); % First difference of the data
% Check for stationarity again after differencing
[hypothesis, pValue, ~, ~] = adftest(dy);
disp('Check for stationarity again before differencing');
if hypothesis == 0
    disp('The null hypothesis of a unit root cannot be rejected.');
    disp('The differenced time series is non-stationary.');
else
    disp('The null hypothesis of a unit root is rejected.');
    disp('The differenced time series is stationary.');
end
disp(['adftest p-value: ', num2str(pValue)]);
subplot(2,1,1);
autocorr(dy);
title('ACF of Differenced Data');
subplot(2,1,2);
parcorr(dy);
title('PACF of Differenced Data');

% Fit ARIMA model
% Mdl = arima(14,1,14);
Mdl = arima(13,1,13);
EstMdl = estimate(Mdl, y);

% Model diagnostics
res = infer(EstMdl, y);

% Forecast the next 300 values
numForecastSteps = 100;
[yF, yMSE] = forecast(EstMdl, numForecastSteps, 'Y0', y);

% Confidence bounds
UB = yF + 1.96*sqrt(yMSE);
LB = yF - 1.96*sqrt(yMSE);

% Plot the forecasts along with the original series
figure;
h4 = plot(1:6200, y, 'b');
hold on;
h5 = plot(t(end)+1:t(end)+numForecastSteps, yF, 'r', 'LineWidth', 2);
h6 = plot(t(end)+1:t(end)+numForecastSteps, UB, 'k--', 'LineWidth', 1.5);
    h7 = plot(6200:6300,trendComponent(1,6200:6300));
% h7 = plot(6200:6300,trendComponent(6200:6300,1));
plot(t(end)+1:t(end)+numForecastSteps, LB, 'k--', 'LineWidth', 1.5);
hold on;
% plot(1:6400,y);
legend([h4, h5, h6, h7], {'Original Data', 'Forecast', '95% Confidence Interval', 'Expected data'}, 'Location', 'NorthWest');
title(' Forecasting Occapancy Using ARIMA model');
xlabel('Time Point(10 seconds interval)');
ylabel('Occapancy');
hold off;
