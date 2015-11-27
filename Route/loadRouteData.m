% Filename:     loadRouteData.m
% Description:  Loads route data for the hyperloop_arc model
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Load data file and remove redundant points
[~, deepestFolder] = fileparts(pwd);

if exist('projectRoot','var')
    cd( fullfile(projectRoot,'Route') )
elseif and(exist('Route','dir'),not(strcmp(deepestFolder,'Route')))
    % Route directory exists and we're not in it
    cd Route
end

[routeFilename, routePath] = uigetfile('*.mat','Select the Route data file');
load([routePath,routeFilename])
clear routePath

if exist('projectRoot','var')
    cd(projectRoot)
elseif and(exist('Route','dir'),strcmp(deepestFolder,'Route'))
    % Route folder exists and we're in it
    cd ..
end

clear deepestFolder

% This data file must include
    %   lat1, lon1 - corresponding latitude and longitude points on route
    %   d, v - distance and velocity vector covering total
    %       distance of route and corresponding velocity at those points
    %   z_dist, z_elevTube, z_height - absolute elevation and height wrt
    %       ground covering total distance of route

% remove any redundant data points (no delta position)
zeroDeltaDInd           = find(diff(d)==0);
% accel(zeroDeltaDInd)    = [];
d(zeroDeltaDInd)        = [];
lat1(zeroDeltaDInd)     = [];
lon1(zeroDeltaDInd)     = [];
% t(zeroDeltaDInd)        = [];
v(zeroDeltaDInd)        = [];
% vt(zeroDeltaDInd)       = [];
clear zeroDeltaDInd

%% Convert latitude and longitude data to x,y coordinate system
[xx, yy, transMatrix]   = reorientLatLon(lat1,lon1);
latMean = mean(lat1);
phi                     = zeros(size(xx));