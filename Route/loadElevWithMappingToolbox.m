function [elev, topo] = loadElevWithMappingToolbox(lat, lon)
% loadKmlRoute  Saves latitude and longitude information from kml file into
%               MATLAB format. If mapping toolbox is available, elevation
%               data for area map and route profile is also included.

% Copyright 2013 - 2014 The MathWorks, Inc


%% Define region surrounding route
% User parameters for area map bounds
degSpace    = 0.05;     % At least this much space around round (deg)
degRound    = 0.1;      % Maps is rounded to nearest (deg)

% Define the lat and lon limits. Make sure there is at least
% degSpace degrees of space, rounding out to the nearest degRound degree
latLim = [degRound*floor(min(lat-degSpace)/degRound) degRound*ceil(max(lat+degSpace)/degRound)];
lonLim = [degRound*floor(min(lon-degSpace)/degRound) degRound*ceil(max(lon+degSpace)/degRound)];

% Determine reasonable resolution for area bounded by latLim and lonLim
maxPts      = 1000;         % max number of points along each axis of map
% have issues accessing server with larger
cellSize    = max((latLim(2)-latLim(1)),(lonLim(2)-lonLim(1)))/maxPts;
minCellSize = 5.5556e-04;                   % finest resoultion (deg)
cellSize    = max(minCellSize,cellSize);    % resolution (deg)

%% Retrieve Elevation Data for overall area
disp(' > Loading aster elevation data...')

layers = wmsfind('nasa.network*elev','SearchField','serverurl');
maxAttempts = 5;
for actAttempt = 1:maxAttempts
    try
        % Find the layers from the NASA WorldWind server.
        layers = wmsupdate(layers);
        % Select the 'EarthAsterElevations30m' layer containing SRTM30 data merged with global ASTER data
        aster = layers.refine('earthaster','SearchField','layername');
        % Load data from server
        [topo.ZA, topo.RA] = wmsread(aster, 'Latlim', latLim, 'Lonlim', lonLim, ...
            'CellSize', cellSize, 'ImageFormat', 'image/bil');
        break
    catch err
        disp(sprintf('    attempt %d of %d to access server failed',actAttempt,maxAttempts))
        if actAttempt == maxAttempts
            rethrow(err);
        end
        pause(5)
    end
end

clear cellSize secSampling degRound degSpace minSample minCellSize maxPts maxAttempts


%% Calculate elevation data along route
disp(' > Calculating elevation along route...this may take a minute...')
ZA_lat  = linspace(latLim(1), latLim(2), size(topo.ZA,1));
ZA_lon  = linspace(lonLim(1), lonLim(2), size(topo.ZA,2));
elev    = zeros(size(lat));

% Add some status as this loop takes a long time
statusUpdatesTotal = 5;
statusUpdate = 1;

for ii = 1:size(lat,1)
    elev(ii) = interp2(ZA_lon,ZA_lat,flipud(topo.ZA),lon(ii),lat(ii));
    % in Northern and Western hemisphere, need to flip NS for monotomically
    % increasing latitude vector
    if ii>(size(lat,1)/statusUpdatesTotal*statusUpdate)
        disp(sprintf('    completed %d of %d elevation points',ii,size(lat,1)))
        statusUpdate = statusUpdate + 1;
    end
end
disp(sprintf('    completed %d of %d elevation points',ii,size(lat,1)))

clear ii