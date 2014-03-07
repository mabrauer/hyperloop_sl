function [mapAxes, mapHandle] = plotTrajMap(ZA, RA, lon,lat,lonLim,latLim)
% plotTrajMap - Display the texture map with route
%
%   Copyright 2013 - 2014 The MathWorks, Inc
scrsz   = get(0,'ScreenSize');
figure('Renderer','zbuffer','Position',[scrsz(3)*0.01 scrsz(4)*0.05 scrsz(3)*0.5 scrsz(4)*0.85]);

if checkToolbox('Mapping Toolbox')
    geoshow(ZA, RA, 'DisplayType', 'texturemap')    % mapping toolbox
    mapAxes     = gca;
    demcmap(double(ZA))                             % mapping toolbox
else
    lenLatLon = size(ZA);
    coastIndx = [[1:max(lenLatLon)]' [1:max(lenLatLon)]' ones(max(lenLatLon),1)];
    coastLonLat = coastIndx*RA;
    coastLon = coastLonLat(1:lenLatLon(2),1);
    coastLat = coastLonLat(1:lenLatLon(1),2);
    contour(coastLon,coastLat,ZA,[0 0],'k','LineWidth',2)
    mapAxes     = gca;
    clear lenLatLon coastIndx coastLonLat
end

xlim(lonLim);
ylim(latLim);
hold on
mapHandle = line(lon,lat,'Color','r','LineWidth',3);