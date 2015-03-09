function [dataHighRes, dataLowRes] = getData(h)
%getData   get data from plots using plot handle structure
%   Copyright 2013 - 2014 The MathWorks, Inc

% data is in plotted units
dataLowRes.vel    = get(h.vel,'YData');
dataLowRes.time   = get(h.vel,'XData');
dataHighRes.time  = get(h.accelLong,'XData');

try
    dataHighRes.dist  = get(h.dist,'YData');
end
try
    dataLowRes.velTarg = get(h.velTarg,'YData');
end
dataHighRes.accLon= get(h.accelLong,'YData');
dataHighRes.accLat= get(h.accelLat,'YData');
dataHighRes.lat   = get(h.route,'YData');
dataHighRes.lon   = get(h.route,'XData');
try
    dataLowRes.route(:,1) = get(h.routePts,'XData')';
    dataLowRes.route(:,2) = get(h.routePts,'YData')';
end
dataHighRes.map(:,1)   = get(h.map,'XData')';
dataHighRes.map(:,2)   = get(h.map,'YData')';
end

