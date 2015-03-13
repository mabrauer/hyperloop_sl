%% User options
incDist         = true;     % include distance in time domain figure (true or false)
transAccelLim   = 5;        % forward acceleration limit (5 m/s2 = 0.5g)
smoothFactor    = 5E-7;     % smoothing factor for fitting provided data to spline
incRes          = 10;       % multiplication factor for adding resolution to data provided above
stopAtEnd       = true;

createDataStruct            % put value aboves into a single userData structure

%% Load route data
loadRouteData
clear latMean phi transMatrix
clear z_height z_elevTube z_dist

%% Analyze trajectory data (derive t and accel vectors)
[lat_p, lon_p, v_p,~,d_p,accel_p,t_p] = calcTraj([lon1 lat1], v,...
    userData.smoothFactor, userData.transAccelLim, userData.incRes, true);

%% Downsample velocity and RoutePt data for plots

% Determine about of downsampling
tgtDecimation           = round(length(d_p)/(d_p(end)/2000));           % target 2km gaps on average
maxDecimation           = floor(length(d_p)/25);                        % leave at least 25 points
decRoutePts             = min(min(tgtDecimation,maxDecimation),50);     % apply and limit to 50x

% Apply decimation
velTargets              = v_p(1:decRoutePts:end); % must be same size as 
                                    % routePts for calcTraj calculations
t_v                     = t_p(1:decRoutePts:end);
RoutePts                = [lat_p(1:decRoutePts:end),lon_p(1:decRoutePts:end)];

% Preserve last data point
if velTargets(end) ~= v_p(end)
    velTargets(end+1) = v_p(end);
    t_v(end+1) = t_p(end);
    RoutePts(end+1,:) = [lat_p(end),lon_p(end)];
end

clear tgtDecimation maxDecimation decRoutePts

%% Plot data and maps with simplified and smoothed routes
% Plot distance (if selected), velocity and acceleration
if userData.incDist
    tdPlot  = plotTrajAccel(t_v,velTargets,t_p,accel_p,d_p);
else
    tdPlot  = plotTrajAccel(t_v,velTargets,t_p,accel_p);
end

% Plot map
[tdPlot.mapAxes, tdPlot.map]    = plotTrajMap(topo.ZA, topo.RA, lon_p,lat_p);
tdPlot.mapFigure                = get(tdPlot.mapAxes,'Parent');

hold(tdPlot.mapAxes,'on');
axes(tdPlot.mapAxes)

tdPlot.route            = line(lon_p,lat_p,'Color','y','LineWidth',2);
% tdPlot.routeOffHwy      = line(lon_p,nan(size(lon_p)),'Color','r',...
%     'LineWidth',2);
tdPlot.mapCursor        = line(nan,nan,'MarkerEdgeColor','m',...
    'Marker','o','MarkerSize',8,'LineWidth',4);
tdPlot.routePts         = ...
    line(RoutePts(:,2),RoutePts(:,1),...
    'MarkerEdgeColor','y','Marker','s','MarkerSize',5,...
    'LineStyle','none','MarkerFaceColor','y');

% Store user data in map figure's UserData field
tdPlot.mapFigure.UserData = userData; 
clear accel_p d_p lat_p lon_p t_p userData

%% Make plots interactive
% Cursor for linking time/position on all plots
if isfield(tdPlot,'dist')
    set(tdPlot.dist,        'ButtonDownFcn',{@startDragCursor,tdPlot })
    linkaxes([tdPlot.distAxes tdPlot.velAxes tdPlot.accAxes],'x');
else
    linkaxes([tdPlot.velAxes tdPlot.accAxes],'x');
end
set(tdPlot.accelLong,   'ButtonDownFcn',{@startDragCursor,tdPlot })
set(tdPlot.accelLat,    'ButtonDownFcn',{@startDragCursor,tdPlot })

% Cursor for adjusting velocity targets
set(tdPlot.vel,         'ButtonDownFcn',{@startDragVelocityPt,tdPlot })

% Cursor for adjusting route points and all calculations
set(tdPlot.routePts,    'ButtonDownFcn',{@startDragRoutePts,tdPlot })

%% Add buttons to figure
uiExport = uicontrol(tdPlot.mapFigure, 'Style', 'pushbutton',...
    'String', 'Export modified route',...
    'Units','normalized',...
    'Position', [0.25 0.9 0.5 0.05],...
    'FontUnits','normalized',...
    'FontSize',0.5,...
    'Callback', {@updateRoute,tdPlot}); 

uiSmoothTxt = uicontrol(tdPlot.mapFigure, 'Style', 'text',...
    'String', 'Smoothness of fit',...
    'Units','normalized',...
    'Position', [0.73 0.09 0.2 0.05],...
    'FontUnits','normalized',...
    'FontSize',0.4); 

uiSmooth = uicontrol(tdPlot.mapFigure, 'Style', 'slider',...
    'Min',0,'Max',10,'Value',7,...
    'Units','normalized',...
    'Position', [0.75 0.05 0.2 0.05],...
    'FontUnits','normalized',...
    'FontSize',0.5,...
    'Callback', {@updateSmoothFactor,tdPlot}); 

%% Clean up workspace variables
clear velTargets xx yy uiExport uiSmoothTxt uiSmooth