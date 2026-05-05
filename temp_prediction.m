% TEMP_PREDICTION Continuously predicts future capsule temperature.
% This function reads voltage from an MCP9700 temperature sensor using
% Arduino, converts the voltage to temperature in Celsius, calculates the
% temperature change rate, and predicts the temperature after 5 minutes.
% It also controls three LEDs. The green LED is ON when the temperature is
% stable and within the comfort range. The red LED is ON when temperature
% increases faster than 4 C/min. The yellow LED is ON when temperature
% decreases faster than 4 C/min.
% Input: a - Arduino object created in the main coursework script.
% Update: use average temperature data to smooth the prediction
% Test text:
% clear;
% clc;
% a = arduino("COM5", "Uno");
% temp_prediction(a);

function temp_prediction(a)

% Creating arrays to store data and time counter
timeData = [];
temperatureData = [];
timeCounter = 0;

% Define temperature range and rate limit, so i can use it later on
lowerLimit = 18;
upperLimit = 24;
rateLimit = 4; % unit: C/min

% Define prediction time, so i can use it later on
predictionTime = 300; % 5 minutes = 300 seconds

% Create an emppty array to store smooth temperature data
smoothTemperatureData = [];

% Define smoothing settings
averageNumber = 10; % use recent 10 readings to smooth temperature
rateWindow = 30; % use about recent 30 seconds to calculate rate

% Continuous prediction loop
while true

    % Read voltage from temperature sensor
    voltage = readVoltage(a, 'A0');

    % Convert voltage to temperature
    temperature = (voltage - 0.5) / 0.01;

    % Store new data
    timeData = [timeData, timeCounter];
    temperatureData = [temperatureData, temperature];

    % Smooth the temperature using recent readings
    startAveragePoint = max(1, length(temperatureData) - averageNumber + 1); % Update: 1 is for when reading number is below 10, it will cause error
    smoothTemperature = mean(temperatureData(startAveragePoint:end)); 

    % Store smoothed temperature data
    smoothTemperatureData = [smoothTemperatureData, smoothTemperature];

    % Check if there is enough data to calculate rate
    if length(smoothTemperatureData) < rateWindow

        % Not enough long-term data, so i set rate to zero
        rate_s = 0;

    else

        % Use recent data to reduce the effect of noise
        % Use about the last 10 seconds of data if available
        oldPoint = max(1, length(smoothTemperatureData) - rateWindow + 1);

        % Calculate temperature difference
        tempChange = smoothTemperatureData(end) - smoothTemperatureData(oldPoint);

        % Calculate time difference
        timeChange = timeData(end) - timeData(oldPoint);

        % Avoid dividing by zero
        if timeChange == 0
            rate_s = 0;
        else
            % Calculate rate in C/s
            rate_s = tempChange / timeChange;
        end

    end

    % Convert rate from C/s to C/min
    rate_min = rate_s * 60;

    % Predict temperature after 5 minutes
    predictedTemperature = smoothTemperature + rate_s * predictionTime;

    % Display current information in command window
    fprintf('Current temperature: %.2f C\n', temperature);
    fprintf('Smoothed temperature: %.2f C\n', smoothTemperature);
    fprintf('Temperature change rate: %.2f C/min\n', rate_min);
    fprintf('Predicted temperature in 5 minutes: %.2f C\n\n', predictedTemperature);

    % LED control according to temperature change rate
    if rate_min > rateLimit

        % Temperature increasing too quickly: red LED constant ON
        writeDigitalPin(a, 'A1', 0);
        writeDigitalPin(a, 'A2', 0);
        writeDigitalPin(a, 'A3', 1);

    elseif rate_min < -rateLimit

        % Temperature decreasing too quickly: yellow LED constant ON
        writeDigitalPin(a, 'A1', 0);
        writeDigitalPin(a, 'A2', 1);
        writeDigitalPin(a, 'A3', 0);

    elseif smoothTemperature >= lowerLimit && smoothTemperature <= upperLimit

        % Stable and within comfort range: green LED constant ON
        writeDigitalPin(a, 'A1', 1);
        writeDigitalPin(a, 'A2', 0);
        writeDigitalPin(a, 'A3', 0);

    elseif smoothTemperature < lowerLimit

        % Temperature is too low but not changing too quickly
        writeDigitalPin(a, 'A1', 0);
        writeDigitalPin(a, 'A2', 1);
        writeDigitalPin(a, 'A3', 0);

    else

        % Temperature is too high but not changing too quickly
        writeDigitalPin(a, 'A1', 0);
        writeDigitalPin(a, 'A2', 0);
        writeDigitalPin(a, 'A3', 1);

    end

    % Maintain about 1 second between readings
    pause(1);

    % Increase the time counter by about 1 second after each loop
    timeCounter = timeCounter + 1;

end

end