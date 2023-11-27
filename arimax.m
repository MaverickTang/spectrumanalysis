clear all;

% Load your actual data file
load('subspectrumData1.mat');
load('bandtime.mat');
% Assuming 'X' is your matrix of exogenous variables with the same number of rows as 'subspectrumData'
% load('exogenousData.mat'); % You need to load or define your exogenous variables here

% Select the time series data from the spectrum data
y = subspectrumData(:,9);
trendComponent = smoothdata(y, 'movmean', 12); % Smooth the data
y = trendComponent(1:6200); % Use smoothed data for fitting

exogenousData=[subspectrumData(:,5) , subspectrumData(:,10),subspectrumData(:,12)];

%% 稳定性检验
% Check for stationarity before differencing
[hypothesis, pValue] = adftest(y);
disp('Check for stationarity before differencing');
if hypothesis == 0
    disp('The series is non-stationary.');
else
    disp('The series is stationary.');
end
disp(['adftest p-value: ', num2str(pValue)]);


% Check for stationarity before differencing
for i=1:3
    [hypothesis, pValue] = adftest(exogenousData(:,i));
    disp('Check for stationarity for exogenousData before differencing');
    if hypothesis == 0
        disp('The series is non-stationary.');
    else
        disp('The series is stationary.');
    end
    disp(['adftest p-value: ', num2str(pValue)]);
end

exogenousData=diff(exogenousData,1);


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

%% 随机性检验
% Perform Ljung-Box Q-test
[h, pValue] = lbqtest(dy,'lags',10);
if h == 0
    disp('Differenced time series is completely random');
else
    disp('Differenced time series is not completely random');
end
disp(['Ljung-Box Q: when lags =10 p-value: ', num2str(pValue)]);
[h, pValue] = lbqtest(dy,'lags',20);
disp(['Ljung-Box Q: when lags =20 p-value: ', num2str(pValue)]);
%% Arima模型
% Fit ARIMA model
Mdl = arima(13,1,13);

% Here we assume 'X' is your matrix of exogenous variables
X = exogenousData(1:6214, :); % Match the rows of your exogenous data to the time series data

% Include the exogenous variables in the model - this is what makes it an ARIMAX model
EstMdl = estimate(Mdl, y, 'X', X);

% Uncomment the above line and comment out the line below when you have your exogenous variables
% EstMdl = estimate(Mdl, y);

% Forecast the next 100 values
numForecastSteps = 100;
[yF, yMSE] = forecast(EstMdl, numForecastSteps, 'Y0', y, 'XF', X(end-numForecastSteps+1:end,:));

% Uncomment the above line and comment out the line below when you have your exogenous variables
% [yF, yMSE] = forecast(EstMdl, numForecastSteps, 'Y0', y);

% Confidence bounds
UB = yF + 1.96*sqrt(yMSE);
LB = yF - 1.96*sqrt(yMSE);

% Plot the forecasts along with the original series
figure;
h4 = plot(1:6200, y, 'b');
hold on;
h5 = plot(6201:6300, yF, 'r', 'LineWidth', 2);
h6 = plot(6201:6300, UB, 'k--', 'LineWidth', 1.5);
h7 = plot(6201:6300, LB, 'k--', 'LineWidth', 1.5);
% Assume 'expectedData' is the actual observed data you want to plot for comparison
h8 = plot(6200:6300, trendComponent(6200:6300,1), 'g'); % Uncomment when you have 'expectedData'
legend([h4, h5, h6, h8], {'Original Data', 'Forecast', '95% Confidence Interval', 'Expected data'}, 'Location', 'NorthWest');
title('ARIMAX Forecasted Signal');
xlabel('Time Point');
ylabel('Signal');
hold off;
