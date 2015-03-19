function [ startTime, latOff, lonOff, htOff,altOff, dOff ] = getVisPar(latLogsout)
%getVisPar - prompt user for visualization parameters

stopTime = latLogsout.Values.Time(end);
startTimePrompt = sprintf('Enter the start time (sec) [Note that stop time is %d (sec)]',...
    round(stopTime));

uiInit.name = 'Visualization parameters';
uiInit.prompt   = {startTimePrompt,...
    'Offset in North/South (m)',...
    'Offset in East/West (m)',...
    'Offset of height (m)',...
    'Altitude offset for overhead image (m)',...
    'Distance offset (m)'};
uiInit.default  = {'0','0','0','5','300','0'};
uiInit.numLimes = 1;
uiInit.options.Resize = 'on';
uiInit.answer = inputdlg(uiInit.prompt,uiInit.name,...
    uiInit.numLimes,uiInit.default,uiInit.options);

startTime           = str2double(uiInit.answer{1});
offNM               = str2double(uiInit.answer{2});
offEW               = str2double(uiInit.answer{3});
htOff               = str2double(uiInit.answer{4});
altOff              = str2double(uiInit.answer{5});             
dOff                = str2double(uiInit.answer{6});

if startTime > stopTime
    error('Start time is greater than stop time')
end

% Convert offset in meters to degrees of latitude and longitude
[ lat2met, lon2met ] = LatLon2Met(latLogsout.Values.Data );
latOff       = offNM/lat2met;
lonOff       = offEW/lon2met;
end

