% Filename:     stopFcn_hyperloop_arc.m
% Description:  StopFcn callback at end of simulation of hyperloop_arc.slx
%               Plots simulation results onto 
%               (1) map, show desired and actual trajectory
%               (2) time-domain plots of distance, velocity and
%               acceleration
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Re-orient x-y data to latitude and longitude coordinates
[latAct, lonAct ]   = reorientXY2LatLon(logsout.getElement('xact').Values.Data,...
    logsout.getElement('yact').Values.Data,transMatrix,lat1(1),lon1(1),latMean);

%% Save results file
saveDlg.prompt = {'Enter a filename for your results'};
saveDlg.title = 'Save Simulation Results';
saveDlg.num_lines = 1;
saveDlg.default = {['Results_',datestr(now,'yyyy-mm-dd_HH-MM')]};
saveDlg.options.Resize='on';
saveDlg.options.WindowStyle='normal';
saveDlg.options.Interpreter='tex';
resultsFilename = inputdlg(saveDlg.prompt,saveDlg.title,saveDlg.num_lines,...
    saveDlg.default,saveDlg.options);
clear saveDlg
if not(isempty(resultsFilename))
    save([projectRoot,'\SimResults\',resultsFilename{1}])
else
    disp('Saving results cancelled')
end
clear resultsFilename


%% Plot data
plotHandle = plotTrajAccel(...
    logsout.getElement('velocityTrans').Values.Time,...
    logsout.getElement('velocityTrans').Values.Data,...
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