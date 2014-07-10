% Filename:     set_up_loadModel.m
% Description:  Initializes the hyperloop_arc model
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Load and downsample route data
loadRouteData
ds      = 4;
xx_ds   = xx(1:ds:end);
yy_ds   = yy(1:ds:end);
v_ds    = v(1:ds:end);
lat0    = lat1(1);
lon0    = lon1(1);

% Calculate vertical accelerations from data
absOn = false;
z_accel = calcVertAccel(z_elevTube,z_dist,d,v,absOn);   
    % there is a simplification that translational velocity is assumed to
    % match target

%% Configure variants
loadVariants

%% Load design parameters
designPars

%% Open model
hyperloop_arc