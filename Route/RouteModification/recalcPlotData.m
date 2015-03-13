function recalcPlotData(h)

% get user data from figure
data = h.mapFigure.UserData;

% get updated Route and velocity data
RouteLon    = get(h.routePts,'XData');
RouteLat    = get(h.routePts,'YData');
Route       = [RouteLon' RouteLat'];
velTargets  = get(h.vel,'YData')';

% Recalculate trajectory
[lat1, lon1, v,vt,d,accel,t] = calcTraj(Route, velTargets/2.23694, ...
    data.smoothFactor, data.transAccelLim, data.incRes, data.stopAtEnd);

decRes = round(length(v)/length(velTargets));

% reduce resolution on velocity
t_v     = t(1:decRes:end);
v       = v(1:decRes:end);

% Convert units to those for plots
t       = t/60;             % seconds to minutes
t_v     = t_v/60;           % seconds to minutes
d       = d*0.000621371;    % meters to miles
v       = v*2.23694;        % meter/sec to miles/hour
vt      = vt*2.23694;       % meter/sec to miles/hour
accel   = accel/9.82;       % meter/sec2 to G's

% Update plotted data
if isfield(h,'dist')
    set(h.dist,'XData',t,'YData',d)
end
set(h.vel,'XData',t_v,'YData',v)
set(h.accelLong,'XData',t,'YData',accel(:,1))
set(h.accelLat,'XData',t,'YData',accel(:,2))
set(h.route,'XData',lon1,'YData',lat1)

% update cursor position
time = get(h.velCursor,'XData');
updateCursors(h,time);

% update time axis
newXLim = [min(t) max(t)];
if isfield(h,'dist')
    set(h.distAxes,'XLim',newXLim)
end
set(h.velAxes,'XLim',newXLim)
set(h.accAxes,'XLim',newXLim)

