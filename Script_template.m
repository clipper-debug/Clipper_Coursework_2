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

%% TASK 2 - LED TEMPERATURE MONITORING DEVICE IMPLEMENTATION [25 MARKS]

% Insert answers here


%% TASK 3 - ALGORITHMS – TEMPERATURE PREDICTION [30 MARKS]

% Insert answers here


%% TASK 4 - REFLECTIVE STATEMENT [5 MARKS]

% Insert answers here