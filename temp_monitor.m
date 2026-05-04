% TEMP_MONITOR Continuously monitors temperature using an Arduino.
% This function reads the voltage from an MCP9700 temperature sensor,
% converts it to temperature in Celsius, updates a live temperature-time
% graph, and controls three LEDs. The green LED is constantly ON when the
% temperature is within 18-24 C. The yellow LED blinks when the temperature
% is below 18 C, and the red LED blinks when the temperature is above 24 C.
% Input: a - Arduino object created in the main coursework script.


function temp_monitor(a)

% Creating arrays to store data and time counter
timeData = [];
temperatureData = [];
timeCounter = 0;

% Create live graph
figure;

% Continuous monitoring loop
while true

    % Read voltage from temperature sensor
    voltage = readVoltage(a, 'A0');

    % Convert voltage to temperature
    temperature = (voltage - 0.5) / 0.01;

    % Store new data
    timeData = [timeData, timeCounter];
    temperatureData = [temperatureData, temperature];

    % Update live graph
    plot(timeData, temperatureData);
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    title('Live Temperature Monitoring');

    % Use xlim function to set x-axis range
    xlim([0, max(60, timeCounter)]);

    % Refresh the graph
    drawnow;

    % Display current temperature in command window
    fprintf('Current temperature: %.2f C\n', temperature);

    % LED control according to temperature range
    if temperature >= 18 && temperature <= 24

        % Green range: green LED constant ON
        writeDigitalPin(a, 'A1', 1);
        writeDigitalPin(a, 'A2', 0);
        writeDigitalPin(a, 'A3', 0);

        % Maintain about 1 second
        pause(1);

    elseif temperature < 18

        % Too cold: yellow LED blinks at 0.5 s intervals
        writeDigitalPin(a, 'A1', 0);
        writeDigitalPin(a, 'A3', 0);
        writeDigitalPin(a, 'A2', 1);
        pause(0.5);
        writeDigitalPin(a, 'A2', 0);
        pause(0.5);

    else

        % Too hot: red LED blinks at 0.25 s intervals
        writeDigitalPin(a, 'A1', 0);
        writeDigitalPin(a, 'A2', 0);
        writeDigitalPin(a, 'A3', 1);
        pause(0.25);
        writeDigitalPin(a, 'A3', 0);
        pause(0.25);
        writeDigitalPin(a, 'A3', 1);
        pause(0.25);
        writeDigitalPin(a, 'A3', 0);
        pause(0.25);

    end

    % Increase the time counter by about 1 second after each loop
    timeCounter = timeCounter + 1;

end

end