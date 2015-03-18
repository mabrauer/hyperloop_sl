function [mapFigure, mapAxes, mapHandle, terrainHandle, currentHandle] = plotRotTrajMap(ZA, RA, lon,lat,orientation)
% plotTrajMap - Display the texture map with route
%
%   Copyright 2013 - 2014 The MathWorks, Inc

%% Create figure
mapFigurePos = [1521  451  319  623];
mapFigure = figure('Renderer','zbuffer','Position',mapFigurePos);
set(mapFigure,'Color','k')

%% Create map axis
mapAxes = axesm('MapProjection','mercator','Origin',...
    [mean(lat) mean(lon) orientation],'Grid','on','GLineWidth',0.5,...
    'MLineLocation',1,'PLineLocation',1,...
    'MLabelParallel',mean(lat),'PLabelMeridian',mean(lon),...
    'MeridianLabel','on','ParallelLabel','on',...
    'GColor','white','FontColor','white',...
    'LabelFormat','compass','LabelRotation','on'); % mapping toolbox
    
    %     'MLabelLocation',mean(lat),'PLabelLocation',mean(lon),...

set(mapAxes,'Position',[0 0 1 1])
terrainHandle = geoshow(ZA, RA, 'DisplayType', 'texturemap');           % mapping toolbox
demcmap(double(ZA))                                                     % mapping toolbox
% [cmap, climits ] = demcmap(double(ZA));

hold on
mapHandle = geoshow(lat,lon,'Color',[0.75 0.75 0.75],'LineWidth',3);     % mapping toolbox
currentHandle = geoshow(lat(1), lon(1),'Color','r','LineWidth',2);

%% Set X and Y Limits
XRange = [min(mapHandle.XData) max(mapHandle.XData)];
YRange = [min(mapHandle.YData) max(mapHandle.YData)];

XWidth = XRange(2) - XRange(1);
YHeight = YRange(2) - YRange(1);

FigureAspectRatio   = mapFigurePos(4)/mapFigurePos(3);
DataAspectRatio     = YHeight/XWidth;
BufferRatio         = 1.05;

if DataAspectRatio > FigureAspectRatio
    % keep YRange for YLim but extend XRange
    set(mapAxes,'Ylim',YRange*BufferRatio)
    set(mapAxes,'Xlim',XRange*DataAspectRatio/FigureAspectRatio*BufferRatio)
else
    % keep YRange for YLim but extend XRange
    set(mapAxes,'Ylim',YRange*DataAspectRatio/FigureAspectRatio*BufferRatio)
    set(mapAxes,'Xlim',XRange*BufferRatio)
end
