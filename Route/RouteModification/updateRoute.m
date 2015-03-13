function updateRoute(~,~,h)
%updateRoute - Callback function called from uiButton on route figure that exports route
% data to a MAT file

% Copyright 2015 The MathWorks, Inc

%% Minimize the figures
warning('off','MATLAB:HandleGraphics:ObsoletedProperty:JavaFrame');

jFrameTD = get(h.fig,'JavaFrame');
jFrameMap = get(h.mapFigure,'JavaFrame');

jFrameTD.setMinimized(true);
jFrameMap.setMinimized(true);

%% Get route data (same method used in recalcPlotData but different sampling methods)
% get user data from figure
data = h.mapFigure.UserData;

% get updated Route and velocity data
RouteLon    = get(h.routePts,'XData');
RouteLat    = get(h.routePts,'YData');
Route       = [RouteLon' RouteLat'];
velTargets  = get(h.vel,'YData')';

% Recalculate trajectory
[lat1, lon1, v,~,d,~,~] = calcTraj(Route, velTargets/2.23694, ...
    data.smoothFactor, data.transAccelLim, data.incRes, data.stopAtEnd); %#ok<ASGLU>

%% Get topography information
[topo, z_dist, z_elevTube, z_height] = ...
    getElevationData(lat1, lon1, d); %#ok<ASGLU>

%% Save the route data
disp('*** Saving route data ***')
routeFilename = evalin('base','routeFilename');
defaultFilename = strcat(routeFilename(1:end-4),'_update');
[routeFilename,routePathname] = uiputfile('*.mat','Save the route data',defaultFilename);
routeFilename = strcat(routePathname,routeFilename);
save(routeFilename,'lat1','lon1','v','d','z_dist','z_elevTube','z_height','topo')

disp('---Route saved. Run startHere to run a simulation')