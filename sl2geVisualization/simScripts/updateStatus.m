function updateStatus(u)
%% Parse data from vector input
speed       = u(1); % mph
dist        = u(2); % miles
time        = u(3); % sec
timeToDest  = u(4); % sec

%% Create strings for each
% Speed
speedStr    = sprintf('%3.0f',speed);

% Distance
distStr     = sprintf('%3.1f',dist);

% Time
time_min    = floor(time/60);
time_sec    = mod(time,60);
if round(time_sec) < 10
    time_secStr = sprintf('0%1.0f',time_sec);
else
    time_secStr = sprintf('%2.0f',time_sec);
end
timeStr     = sprintf('%d:%s',time_min,time_secStr);

% Time to destination
timeTD_min    = floor(timeToDest/60);
timeTD_sec    = mod(timeToDest,60);
if timeTD_sec < 10
    timeTD_secStr = sprintf('0%1.0f',timeTD_sec);
else
    timeTD_secStr = sprintf('%2.0f',timeTD_sec);
end
timeTDStr     = sprintf('%d:%s',timeTD_min,timeTD_secStr);

%% Set text values in GUI
textHandles = evalin('base','hText');
set(textHandles.Speed,'String',speedStr)
set(textHandles.Dist,'String',distStr)
set(textHandles.Time,'String',timeStr)
set(textHandles.TimeTD,'String',timeTDStr)

%% Update clock
clockAxes = evalin('base','clockHandles.axes');
plotTimePie(time,timeToDest, clockAxes);

end