clear all;
% load('subspectrumData1.mat'); % Make sure to load your actual data file
load('bandtime.mat','bandtime');
% Plot the original data
% Select the time series data from the spectrum data
% timeSeriesData = subspectrumData(10,:);


figure;
plot(1:length(timeSeriesData), timeSeriesData, 'LineWidth', 2);
xlabel('Time Point Index (10s interval)');
ylabel('Intensity (dB)');
title('Intensity Over Time');
grid on;



% Decompose the time series using a moving average for the trend
trendComponent = smoothdata(timeSeriesData, 'movmean', 12); % Change 12 to your specific window size if needed

% Extract the seasonal component
% Assuming a known periodicity, e.g., 24 hours. Adjust according to your data
seasonalPeriod = 24; 
% Extract the seasonal component
% Extract the seasonal component
seasonalComponent = timeSeriesData - trendComponent;
seasonalMA = movmean(seasonalComponent, seasonalPeriod, 'Endpoints', 'shrink');  % Shrink the endpoints instead of discarding them
seasonalComponent = seasonalComponent - seasonalMA;  % Now dimensions will match

% seasonalComponent = timeSeriesData - trendComponent;
% seasonalComponent = seasonalComponent - movmean(seasonalComponent, seasonalPeriod, 'Endpoints', 'discard');

% Calculate the remainder component
remainderComponent = timeSeriesData - trendComponent - seasonalComponent;

% Plot the components
figure;
subplot(4, 1, 1);
plot(timeSeriesData);
title('Original Time Series');

subplot(4, 1, 2);
plot(trendComponent);
title('Trend Component');

subplot(4, 1, 3);
plot(seasonalComponent);
title('Seasonal Component');

subplot(4, 1, 4);
plot(remainderComponent);
title('Remainder Component');

 timeSeriesData = trendComponent

% Now, use the remainder component for ARIMA modeling
% You may want to perform stationarity and white noise tests on this remainder component
% and then proceed with ARIMA modeling as before.


% Differencing the data to make it stationary (if necessary)
d = 2; % The degree of differencing
diffTimeSeriesData = diff(timeSeriesData, d);

% After differencing, the length of time series reduces by `d`
t = 1:(size(subspectrumData, 2)-d);

% Plot the differenced data
figure;
plot(t, diffTimeSeriesData, 'LineWidth', 2);
xlabel('Time Point Index (10s interval)');
ylabel('Intensity (dB)');
title('Intensity Over Time Differenced');
grid on;

% Check for stationarity again after differencing
[hypothesis, pValue, ~, ~] = adftest(diffTimeSeriesData);
if hypothesis == 0
    disp('The null hypothesis of a unit root cannot be rejected.');
    disp('The differenced time series is non-stationary.');
else
    disp('The null hypothesis of a unit root is rejected.');
    disp('The differenced time series is stationary.');
end
disp(['adftest p-value: ', num2str(pValue)]);

% Perform Ljung-Box Q-test
[h, pValue] = lbqtest(diffTimeSeriesData);
if h == 0
    disp('Differenced time series is completely random');
else
    disp('Differenced time series is not completely random');
end
disp(['Ljung-Box Q: p-value: ', num2str(pValue)]);



% Now you need to identify the order of the ARIMA model
% The differencing order `d` is already known, and you need to find `p` and `q`
pVals = 0:10; % Possible AR order
qVals = 0:10; % Possible MA order
BICMatrix = zeros(length(pVals), length(qVals));

% ... (rest of your code before this point)

% Initialize matrix to store AIC values
AICMatrix = zeros(length(pVals), length(qVals));

% Search for the best p and q combination using AIC
for p = pVals
    for q = qVals
        try
            model = arima('ARLags', 1:p, 'MALags', 1:q, 'D', d, 'Constant', 0);
            [fit, ~, ~] = estimate(model, diffTimeSeriesData, 'Display', 'off');
            AICMatrix(p + 1, q + 1) = fit.AIC;
        catch e
            AICMatrix(p + 1, q + 1) = inf; % Assign a large number in case of failure
        end
    end
end

% Find the combination of p and q that has the minimum AIC value
[minAIC, idx] = min(AICMatrix(:));
[pOpt, qOpt] = ind2sub(size(AICMatrix), idx);

% Display the optimal p and q values
fprintf('Optimal p value based on AIC: %d\n', pOpt - 1);
fprintf('Optimal q value based on AIC: %d\n', qOpt - 1);
fprintf('Minimum AIC value: %f\n', minAIC);

% ... (rest of your code after this point)


% Search for the best p and q combination
for p = pVals
    for q = qVals
        try
            model = arima('ARLags', 1:p, 'MALags', 1:q, 'D', d, 'Constant', 0);
            [fit, ~, ~] = estimate(model, diffTimeSeriesData, 'Display', 'off');
            BICMatrix(p + 1, q + 1) = fit.BIC;
        catch e
            BICMatrix(p + 1, q + 1) = inf;
        end
    end
end

[minBIC, idx] = min(BICMatrix(:));
[pOpt, qOpt] = ind2sub(size(BICMatrix), idx);
fprintf('Optimal p value: %d\n', pOpt - 1);
fprintf('Optimal q value: %d\n', qOpt - 1);
fprintf('Minimum BIC value: %f\n', minBIC);
