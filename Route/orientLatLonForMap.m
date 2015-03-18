function [orientation] = orientLatLonForMap(lat,lon)
% ORIENTLATLON - determines an appropriate orientation angle to rotate
% a series of latitude and longitude data, such that they will fit
% optimally in a vertical frame
%
% INPUTS:
%   lat - vector of latitudes
%   lon - vector of longitudes
%   apectRatio - desired aspect ratio (vertical pixels/horizontal pixels)
%
% OUTPUTS:
%   orientation - clockwise rotation angle in degrees

% perform least squares approximation, assuming Ax=b, where x is
% {slope;bias}

% Input checking and reorienting to column vectors
if isrow(lat)
    lat = lat';
elseif not(iscolumn(lat))
    error('Input latitude vector is not a vector')
end

if isrow(lon)
    lon = lon';
elseif not(iscolumn(lon))
    error('Input longitude vector is not a vector')
end


% Perform least squares approximation
A = [lon ones(length(lon),1)];
b = lat;

x = inv(A'*A)*A'*b;         % least squares approximation

% Convert results into orientation angle
slope = x(1);
theta = atan(slope);
orientation = (-pi/2 +theta)*180/pi;