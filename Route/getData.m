function [data] = getData(h)
%getData   get data from plots using plot handle structure
%   Copyright 2013 - 2014 The MathWorks, Inc

% data is in plotted units
data.vel   = get(h.vel,'YData');
data.time  = get(h.vel,'XData');
try
    data.dist  = get(h.dist,'YData');
end
try
    data.velTarg = get(h.velTarg,'YData');
end
data.accLon= get(h.accelLong,'YData');
data.accLat= get(h.accelLat,'YData');
data.lat   = get(h.route,'YData');
data.lon   = get(h.route,'XData');
try
    data.route(:,1) = get(h.routePts,'XData')';
    data.route(:,2) = get(h.routePts,'YData')';
end
data.map(:,1)   = get(h.map,'XData')';
data.map(:,2)   = get(h.map,'YData')';
end

