% Filename:     stopFcn_hyperloop_arc.m
% Description:  StopFcn callback at end of simulation of hyperloop_arc.slx
%               Plots simulation results onto 
%               (1) map, show desired and actual trajectory
%               (2) time-domain plots of distance, velocity and
%               acceleration
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Re-orient x-y data to latitude and longitude coordinates
[latAct, lonAct ]   = reorientXY2LatLon(logsout.getElement('xact').Values.Data,...
    logsout.getElement('yact').Values.Data,transMatrix,lat1(1),lon1(1));

%% Plot data
plotHandle = plotTrajAccel(...
    logsout.getElement('velocityTrans').Values.Time,...
    logsout.getElement('velocityTrans').Values.Data,...
    [logsout.getElement('aX').Values.Data  logsout.getElement('aY').Values.Data],...
    logsout.getElement('dact').Values.Data);

%% Add map and route points
load caliAster
[mapAxes, plotHandle.map] = plotTrajMap(ZA, RA, lon1, lat1,lonLim,latLim);

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