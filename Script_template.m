% Ruixuan Zou
% biyrz22@nottingham.edu.cn

clear;
clc;

%% PRELIMINARY TASK - ARDUINO AND GIT INSTALLATION [5 MARKS]

% Insert answers here

% Establish Comm between arduino kit and matlab

a = arduino("COM5", "Uno");

% Turn LED ON (just as a copy line)
% writeDigitalPin(a,'D8',1)

% Turn LED OFF (SAME)
% writeDigitalPin(a,'D8',0)

% To make the LED blink at 0.5s interval 10 times

for i = 1:10

    writeDigitalPin(a,'D8',1);
    pause(0.5);

    writeDigitalPin(a,'D8',0);
    pause(0.5);
end    
%% TASK 1 - READ TEMPERATURE DATA, PLOT, AND WRITE TO A LOG FILE [20 MARKS]

% Insert answers here

% Establish connection
a = arduino("COM5", "Uno");

duration = 600;

% Creating the array

time = 0:duration;
voltage = zeros(1,length(time));
temperature = zeros(1,length(time));

% read the value and put into the arrays
for i = 1:length(time)

    voltage(i) = readVoltage(a, 'A0');
    temperature(i) = (voltage(i)-0.5)/0.01; % from the datasheet of MCP970X
    
    % wait for 1 second
    pause(1);

end

% calculate the min, max and aver
maxTemp = max(temperature);
minTemp = min(temperature);
avgTemp = mean(temperature);

% create the plot
plot(time, temperature);
xlabel('Time (s)'); % creating label for x axies
ylabel('Temperature (°C)'); % same
title('Temperature against Time'); % headline

% print recorded data
dateRecorded = datestr(now, 'dd/mm/yyyy');
location = 'Nottingham';
outputText = sprintf('Data logging initiated - %s\nLocation - %s\n\n', dateRecorded, location);

% use outputText=[outputText, new content] to add content on previous

for minute = 0:floor(duration/60)

    numb = minute * 60 + 1; % transform minutes to number of temp data, add 1 each because matlab array starts at 1

    outputText = [outputText, sprintf('Minute\t%d\n', minute)];
    outputText = [outputText, sprintf('Temperature\t%.2f C\n\n', temperature(numb))];

end

outputText = [outputText, sprintf('Max temp %.2f C\n', maxTemp)];
outputText = [outputText, sprintf('Min temp %.2f C\n', minTemp)];
outputText = [outputText, sprintf('Average temp %.2f C\n\n', avgTemp)];
outputText = [outputText, sprintf('Data logging terminated\n')];

fprintf('%s', outputText);

% write the data into text log file
file_id = fopen('capsule_temperature.txt', 'w');

% Write outputText into the text file
fprintf(file_id, '%s', outputText);

% Close the file to save it
fclose(file_id);

% Open the generated file to check the written data
file_id = fopen('capsule_temperature.txt', 'r');

fileContent = fscanf(file_id, '%c');

fclose(file_id);

% Display the content read from the file
disp('Content of capsule_temperature.txt:');
disp(fileContent);
%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here