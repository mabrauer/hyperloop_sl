function updateAxes(u)

dact        = u(1);
aX          = u(2);
aY          = u(3);
Vel         = u(4);
pillarIndex = u(5);

% dact - translational distance in m
% aX - side-to-side acceleration in g's
% aY - up-down acceleration in g's
% Vel - translational velocity in mph

%% Update elevation axes
% load variables from workspace
hAxes           = evalin('base','hAxes');
hElevTube       = evalin('base','hElevTube');
hElevTubeNow    = evalin('base','hElevTubeNow');
z_elevTube      = evalin('base','z_elevTube');
z_dist          = evalin('base','z_dist');
dataLength      = evalin('base','dataLength');

elevPlotRange   = 100;  % note this is also defined in elevFigure() for init
elevPlotDist    = 1;    % note this is also defined in elevFigure() for init

% find where we are on the route
dOffset         = evalin('base','dactOffset');
dActOffset      = dact+dOffset;
index           = find(z_dist<dact,1,'last');
indexOffset     = find(z_dist<dActOffset,1,'last');

% index = index(1);

% Update cursor with current position
elevOffset = 2;
set(hElevTubeNow,'XData',z_dist(indexOffset)/1e3,...
    'YData',z_elevTube(indexOffset)+elevOffset);

if index>=1
    % Update line with previous positions
    set(hElevTube,'YData',[elevOffset+z_elevTube(1:indexOffset);nan*ones(dataLength-indexOffset,1)])
    
    
    % Update x-axis limits
    pctRear     = 0.8;
    xStart      = max(0,            dActOffset/1e3-pctRear*elevPlotDist);
    xStop       = max(elevPlotDist, dActOffset/1e3+(1-pctRear)*elevPlotDist);
    set(hAxes,'XLim',[xStart xStop])
    tickSpacing = 0.2;
    set(hAxes,'XTick',[ceil(xStart/tickSpacing)*tickSpacing:tickSpacing...
        :floor(xStop/tickSpacing)*tickSpacing])
    
    % Update y-axis limits
    yMin        = z_elevTube(indexOffset)-elevPlotRange/2;
    yMax        = z_elevTube(indexOffset)+elevPlotRange/2;
    set(hAxes,'YLim',[yMin yMax])
end

%% Update acceleration axes
accHandles      = evalin('base','accHandles');
hAccelNow       = accHandles.hAccelNow;
hAccelHist      = accHandles.hAccel;
intensityCircle = accHandles.intensityCircle;

histNum = 20;   % check value in accAxes.m
for ii = 1:histNum-1;  % first one is smallest
    set(hAccelHist{ii},'XData',get(hAccelHist{ii+1},'XData'),...
        'YData',get(hAccelHist{ii+1},'YData'))
end
set(hAccelHist{histNum},'XData',get(hAccelNow,'XData'),...
    'YData',get(hAccelNow,'YData'))
set(hAccelNow,'XData',aX,'YData',aY)

updateComfortCircle(intensityCircle,sqrt(aX^2+aY^2))

% %% Update velocity axes
% hVelNow = evalin('base','hVelNow');
% set(hVelNow,'YData',Vel)

%% Update map axes (if mapping toolbox is available)
mapFigureExists = evalin('base','exist(''mapFigure'',''var'')');

if mapFigureExists
    nextMapUpdtPlr  = evalin('base','nextMapUpdtPlr');
    mapAxes         = evalin('base','mapAxes');
    
    mapDownSample   = 50;   % only update the map after this number of pillars have been passed
    
    % if pillarIndex == nextMapUpdtPlr
    latDataEvalStr  = sprintf('tubeLat(1:%d:%d)',mapDownSample,pillarIndex);
    lonDataEvalStr  = sprintf('tubeLon(1:%d:%d)',mapDownSample,pillarIndex);
    latPlot         = evalin('base',latDataEvalStr);
    lonPlot         = evalin('base',lonDataEvalStr);
    plotHandle      = evalin('base','plotHandle');
    [x,y]           = mfwdtran(latPlot, lonPlot);
    set(plotHandle.current,'XData',x,'YData',y)
    nextMapEvalStr = sprintf('nextMapUpdtPlr = nextMapUpdtPlr + %d;',mapDownSample);
    evalin('base',nextMapEvalStr);
    % end
end

end