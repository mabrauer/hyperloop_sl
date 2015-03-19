function [ d, lat1, lon1, z ] = distanceBetweenLatLon( lat, lon, z )
%distanceBetweenLatLon - determine a distance vector that defines the 
% travel distance between a set of latitude and longitude points, also
% return latitude and longitude vectors without redundant points

% Copyright 2015 The MathWorks, Inc
disp('*** Creating distance vector ***')

% Derive x and y coordinates, along with transformation matrix
[x, y, transMatrix]     = reorientLatLon(lat,lon);

% Get initial distance estimate and remove redundant data points
[d, x, y, remIdx]       = transDist2D(x, y, 10);
lat(remIdx) = [];
lon(remIdx) = [];
z(remIdx)   = []; 

% Check if data is monotonically increasing. If not, don't use the fit to
% calculate distance
monoIncreasing = all(diff(x)>0);

if not(monoIncreasing)
    disp(' > WARNING! Route data is not monotonically increasing after re-orienting')
    disp(' > Distance data may not be accurate')
    lat1 = lat;
    lon1 = lon;
else
    %Create fit model of x,y data in order to increase resolution, which will
    %improve the distance calculation (because the vehicle will not travel
    %point-to-point)
    avgDist = 30;                               % (m)
    incRes = ceil((d(end)/avgDist)/length(z));
    if checkToolbox('Curve Fitting Toolbox')
        disp(' > Smoothing route data')
        x_highres   = refactorData(x,incRes,true);
        fitTraj = fit(x,y,'smoothingspline','SmoothingParam',5E-7);
        y_highresFit   = feval(fitTraj,x_highres);
    else
        warning('Curve fitting toolbox not available, consider smoothing your trajectory')
    end
    
    % Get distance vector using high resolution data
    [d, ~, ~, remIdx]       = transDist2D(x_highres, y_highresFit, 0);
    
    % Down-sample distance data back to same size as lat, lon and z
    d = d(1:incRes:end);
    
    % convert position points back to latitude and longitude
    midLat  = (max(lat)+min(lat))/2 ;
    [lat1, lon1]            = reorientXY2LatLon(x,y,transMatrix,lat(1),lon(1),midLat);
end

end

