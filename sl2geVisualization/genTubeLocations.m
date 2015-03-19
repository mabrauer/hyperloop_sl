function [tubeLat, tubeLon, tubeElev, tubeHeading, tubeTilt] = genTubeLocations(logsout,...
    z_dist,z_elevTube, gap, latOffset,lonOffset)

d       = logsout.getElement('dact').Values.Data(1:end-1);
lat     = logsout.getElement('lat').Values.Data(1:end-1)+latOffset;
lon     = logsout.getElement('lon').Values.Data(1:end-1)+lonOffset;
lat0    = lat(1);
lon0    = lon(1);

[xx, yy, transMatrix] = reorientLatLon(lat,lon);

% Get locations of pillars
[xPillar, yPillar, tubeElev] = calcPillarLoc(d,xx,yy,z_dist,z_elevTube,gap);

% Covnert x-y pillar locations to latitude and longitude
midLat  = (max(lat)+min(lat))/2 ;
[tubeLat, tubeLon]          = reorientXY2LatLon(xPillar,yPillar,...
    transMatrix,lat0,lon0,midLat);

% Determine heading and tilt for each tube between pillars
[tubeHeading, tubeTilt] = calcPillarAngles(xPillar, yPillar, tubeElev, gap,transMatrix);

function [xPillar, yPillar, zPillar] = calcPillarLoc(d,xx,yy,z_dist,z_elevTube,gap)
% get elevation axis lined up with d vector
zz       = interp1(z_dist,z_elevTube,d); 
% create d vector at 30m increments
dPillar = [0:gap:max(d)];           

% get x,y and z at 30m increments
xPillar = interp1(d,xx,dPillar,'spline')';         
yPillar = interp1(d,yy,dPillar,'spline')';
zPillar = interp1(d,zz,dPillar,'spline')';

function [tubeHeading, tubeTilt] = calcPillarAngles(xPillar, ...
    yPillar, zPillar,gap, transMatrix)

% Tilt is just arc-tangent of change in elevation over distance between
tubeTilt        =  atan(diff(zPillar)/gap); 
tubeTilt(end+1) =  tubeTilt(end);       % extend to keep same size

% heading in x-y frame
tubeHeadingXY = atan2(diff(yPillar),diff(xPillar));

% convert to N-S frame
forwardLocal        = [1;0];
tubeHeading         = zeros(size(tubeHeadingXY));
for ii = 1:length(tubeHeadingXY)
    theta = tubeHeadingXY(ii);
    transMatrixLocal    = [cos(theta) sin(theta);-sin(theta) cos(theta)];
    headingVector       = inv(transMatrix)*inv(transMatrixLocal)*forwardLocal;
    tubeHeading(ii)     = atan2(headingVector(2),headingVector(1));
            % 0 deg is facing E.
            % 90 is N
            % -90 is S
            % 180 or -180 is W
end   