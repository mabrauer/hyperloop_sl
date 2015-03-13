function [lat, lon, v, vt,d, accel,t] = calcTraj(Route, ...
    v, smoothFactor, transAccelLim, incRes,stopAtEnd)

% INPUTS:
% Route:        [lon lat] longitude and latitude vectors [n x 2]
% v:            velocity (mps) [n x 1]
% smoothFactor  scalar to define fit SmoothingParam
% incRes        scalar amount to increase the resolution
% stopAtEnd     boolean to define if velocity should be reduced to 0 at end
%
% OUTPUT:
% lat           latitude vector [n*incRes x 1]
% lon           longitude vector [n*incRes x 1]
% v             velocity (mps) [n*incRes x 1]
% vt            target velocity (mps) [n*incRes x 1]
% d             distance (m) [n*incRes x 1]
% accel         forward and side-to-side acceleration (mps2)  [n*incRes x 2]
% t             time(sec) [n*incRes x 1]

disp('*** Calculating trajectory velocity and acceleration ***')

% Reorient XY data into cartesian coordinates, along route axis
[x,y,transMatrix] = reorientLatLon(Route(:,2),Route(:,1));

% Check if data is monotonically increasing. If not, don't use the fit to
% calculate distance
monoIncreasing = all(diff(x)>0);

if not(monoIncreasing)
    vt = v;
    disp(' > Data is not monotonically increasing, so results may be innacurate')
else
    % Create fit model of x,y data in order to increase resolution
    fitTraj = fit(x,y,'smoothingspline','SmoothingParam',smoothFactor);
    
    % Add finer resolution to data using fit
    x   = refactorData(x,incRes,true);
    vt  = refactorData(v,incRes,true);
    y   = feval(fitTraj,x);
    % not doing anything for z (elevation). Smoothing spline not available on 
    % 3D data. Should do a curve fit on z vs x (repeat cftool and feval for z)
end

% Calculate translational distance vector 
% (removes sequential duplicates from x, y data as well as vt vector)
[d, x, y, remIdx] = transDist2D(x, y, 10);
vt(remIdx) = [];
% does point-to-point distance, not accounting for curvature

% Modify velocity based on translational acceleration limits
[v, t] = recalcVelocity(d,vt,transAccelLim,stopAtEnd);

%% Calculate acceleration along trajectory
accel = accelFromTrajectory(x,y,v);

% Reorient x, y back to latitude and longitude
[lat, lon ] = reorientXY2LatLon(x,y,transMatrix,Route(1,2),Route(1,1),mean(Route(:,2)));
