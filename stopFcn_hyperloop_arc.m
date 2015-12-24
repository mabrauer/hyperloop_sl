% Filename:     stopFcn_hyperloop_arc.m
% Description:  StopFcn callback at end of simulation of hyperloop_arc.slx
%               Plots simulation results onto 
%               (1) map, show desired and actual trajectory
%               (2) time-domain plots of distance, velocity and
%               acceleration
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Re-orient x-y data to latitude and longitude coordinates
midLat  = (max(lat1)+min(lat1))/2 ;
[latAct, lonAct ]   = reorientXY2LatLon(logsout.getElement('xact').Values.Data,...
    logsout.getElement('yact').Values.Data,transMatrix,lat1(1),lon1(1),midLat);
clear midLat

%% Save results file
disp('*** Saving route data ***')
if exist('routeFilename','var')
    defaultFilename = strcat(routeFilename(1:end-4),'_Sim_',datestr(now,'yyyy-mm-dd_HH-MM'));
else
    defaultFilename = strcat('Results_Sim_',datestr(now,'yyyy-mm-dd_HH-MM'));
end
if exist('projectRoot','var')
    defaultFilename = fullfile(projectRoot,'SimResults',defaultFilename);
end
[resultsFilename,resultsPathname] = uiputfile('*.mat','Save the route data',defaultFilename);
resultsFilename = strcat(resultsPathname,resultsFilename);

save(resultsFilename)

% Remove projectRoot from results file as this could lead to issues when
% loading this mat file into another user's project
vars = rmfield(load(resultsFilename),'projectRoot');
save(resultsFilename,'-struct','vars');
clear resultsFilePath resultsFilename vars

%% Plot data
plotHandle = plotTrajAccel(...
    logsout.getElement('velocityTrans').Values.Time,...
    logsout.getElement('velocityTrans').Values.Data,...
    logsout.getElement('velocityTrans').Values.Time,...
    [logsout.getElement('aX').Values.Data  logsout.getElement('aY').Values.Data],...
    logsout.getElement('dact').Values.Data);

%% Add map and route points
% load caliAster
degSpace    = 0.05;     % At least this much space around round (deg)
degRound    = 0.1;      % Maps is rounded to nearest (deg)
latLim = [degRound*floor(min(lat1-degSpace)/degRound) degRound*ceil(max(lat1+degSpace)/degRound)];
lonLim = [degRound*floor(min(lon1-degSpace)/degRound) degRound*ceil(max(lon1+degSpace)/degRound)];
try
    [mapAxes, plotHandle.map] = plotTrajMap(topo.ZA, topo.RA, lon1, lat1,lonLim,latLim);
catch
    load caliAster
    [mapAxes, plotHandle.map] = plotTrajMap(ZA, RA, lon1, lat1,lonLim,latLim);
end
    

hold(mapAxes,'on');
axes(mapAxes)

plotHandle.route     = line(lonAct,latAct,'Color',[0 0.9 0.7],'LineWidth',2);
plotHandle.mapCursor = line(nan,nan,'MarkerEdgeColor','m',...
    'Marker','o','MarkerSize',8,'LineWidth',4);
plotHandle.mapAxes   = mapAxes;

%% Make plots interactive
% Cursor for linking time/position on all plots
if isfield(plotHandle,'dist')
    set(plotHandle.dist,        'ButtonDownFcn',{@startDragCursor,plotHandle })
    linkaxes([plotHandle.distAxes plotHandle.velAxes plotHandle.accAxes],'x');
else
    linkaxes([plotHandle.velAxes plotHandle.accAxes],'x');
end
set(plotHandle.accelLong,   'ButtonDownFcn',{@startDragCursor,plotHandle })
set(plotHandle.accelLat,    'ButtonDownFcn',{@startDragCursor,plotHandle })
set(plotHandle.vel,         'ButtonDownFcn',{@startDragCursor,plotHandle })