function [xx_p, yy_p, transMatrix] = reorientLatLon(lat,lon)
%reorientLatLon  re-orient a series of latitude and longitude data points 
% to cartesian coordinates. The translation is chosen such that the first
% and last data points are on the x-axis.
%
%   Copyright 2013 - 2014 The MathWorks, Inc

%% Convert latitude, longitude and elevation to cartesian coordinates
[ lat2met, lon2met ] = LatLon2Met( lat );

xx = (lon-lon(1))*lon2met;
yy = (lat-lat(1))*lat2met;

%% Perform coordinate transformation to orient in direction of travel
% Calculate translation angle (is there an easier way to handle 0 and
% negatives?
if xx(end) < 0
    transAngle = pi + atan(yy(end)/xx(end));
elseif xx(end) > 0
    transAngle = atan(yy(end)/xx(end));
else
    if yy(end) > 0
        transAngle = pi/2;
    elseif yy(end) < 0
        transAngle = 3*pi/2;
    else
        transAngle = 0;
    end
end

% Perform translation
transMatrix = [cos(transAngle) sin(transAngle);-sin(transAngle) cos(transAngle)];
xx_yy_p = transMatrix*[xx';yy'];
xx_p = xx_yy_p(1,:)';
yy_p = xx_yy_p(2,:)';
clear xx_yy_p