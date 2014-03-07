function [lat, lon ] = reorientXY2LatLon(x_p,y_p,transMatrix,lat0,lon0)
%reorientXY2LatLon  re-orient a series of cartesian data points to latitude 
% and longitude points in degrees. The translation matrix, which was used 
% to do the opposite conversion, is required.
%
%   Copyright 2013 - 2014 The MathWorks, Inc

%% Re-orient based on original transMatrix
x_y_p   = [x_p';y_p'];
x_y     = transMatrix\x_y_p;
x_p     = x_y(1,:)';
y_p     = x_y(2,:)';

%% Convert cartesian coordinates to latitude and longitude 
lat2met = 110958.98;    % one degree of latitude is 110958.98 m at 36 deg
lon2met = 90163.66;     % one degree of longitude is 90163.66 m at 36 deg

lon     = x_p/lon2met+lon0;
lat     = y_p/lat2met+lat0;
