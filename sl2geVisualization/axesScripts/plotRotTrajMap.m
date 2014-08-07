function [mapFigure, mapAxes, mapHandle, terrainHandle, currentHandle] = plotRotTrajMap(ZA, RA, lon,lat,orientation)
% plotTrajMap - Display the texture map with route
%
%   Copyright 2013 - 2014 The MathWorks, Inc
scrsz   = get(0,'ScreenSize');
mapFigure = figure('Renderer','zbuffer','Position',[1521  451  319  623]);
set(mapFigure,'Color','k')

mapAxes = axesm('MapProjection','mercator','Origin',[0 0 orientation]); % mapping toolbox
set(mapAxes,'Position',[0 0 1 1])
terrainHandle = geoshow(ZA, RA, 'DisplayType', 'texturemap');           % mapping toolbox
demcmap(double(ZA))                                                     % mapping toolbox
% [cmap, climits ] = demcmap(double(ZA));

hold on
mapHandle = geoshow(lat,lon,'Color',[0.75 0.75 0.75],'LineWidth',3);     % mapping toolbox
currentHandle = geoshow(lat(1), lon(1),'Color','r','LineWidth',2);

set(mapAxes,'Xlim',[-2.04 -1.994])
set(mapAxes,'Ylim',[-.365 -.275])
warning('Map axes x and y limits were determined manually for California. You may need to set X and Y limits manually to capture map.')