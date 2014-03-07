% Filename:     loadRouteData.m
% Description:  Loads route data for the hyperloop_arc model
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Load data file and remove redundant points
load RouteTotal

% remove any redundant data points (no delta position)
zeroDeltaDInd           = find(diff(d)==0);
accel(zeroDeltaDInd)    = [];
d(zeroDeltaDInd)        = [];
lat1(zeroDeltaDInd)     = [];
lon1(zeroDeltaDInd)     = [];
t(zeroDeltaDInd)        = [];
v(zeroDeltaDInd)        = [];
vt(zeroDeltaDInd)       = [];

%% onvert latitude and longitude data to x,y coordinate system
[xx, yy, transMatrix]   = reorientLatLon(lat1,lon1);
phi                     = zeros(size(xx));