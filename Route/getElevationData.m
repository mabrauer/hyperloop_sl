function [topo, z_dist, z_elevTube, z_height] = ...
    getElevationData(lat1, lon1, d, z)
%getElevationData - finds elevation along input route profile

% Copyright 2013 - 2015 The MathWorks, Inc

%% Decide how to handle elevation data
disp('*** Checking Elevation data ***')

licMapTB    = checkToolbox('Mapping Toolbox');

if nargin==4
    noElev      = and((max(z)==0),(min(z)==0)); % z vector from KML
else
    noElev      = true;    % no z vector (when modifying)
end

if and(noElev,licMapTB)
    % data isn't included but user has mapping toolbox, so load using
    % mapping tool
    disp(' > Elevation data not included. Using Mapping Toolbox')
    [z, topo] = loadElevWithMappingToolbox(lat1, lon1);
elseif licMapTB
    % data is included but user has mapping toolbox, give option to use it
    questStr = 'You have the mapping toolbox, would you like to use it load new elevation data?';
    keepStr = 'Keep existing elevation data';
    replaceStr = 'Load new data and replace existing';
    desElevData = questdlg(questStr,'Elevation Data',keepStr,replaceStr,keepStr);
    if strcmp(desElevData,replaceStr)
        % replace existing elevation data
        [z, topo] = loadElevWithMappingToolbox(lat1, lon1);
    else
        % populate topography
        [~, topo] = loadElevWithMappingToolbox(lat1, lon1); % this doesn't look right
    end
    clear questStr keepStr replaceStr desElevData
elseif noElev
    % no elevation data and no mapping toolbox
    warning(' > There is no elevation data included in your kml file')
    warning('  It is recommended to either:')
    warning('   - Use the Mapping Toolbox')
    warning('   - Supplement your KML file using www.gpsvisualizer.com') 
else
    % elevation data and no mapping toolbox
    warning(' > Using elevation data provided.')
    warning('  You may get better results using the Mapping Toolbox')
end

clear licMapTB noElev

%% Populate elevation and height data assuming constant height above ground

% Create initial elevation vector with constant height above ground
z_dist      = d;
constHeight = 2;
disp(sprintf('*** Populating elevation data with constant %dm above ground level ***',constHeight))
z_elevTube  = z + constHeight*ones(size(z));

% Create smoothed elevation profile by downsampling and fitting the data
if checkToolbox('Curve Fitting Toolbox')
    % Determine downsampling
    avgDist         = 500;  % average 500 m between elevation points 
    dsIndex         = ceil((length(z_dist)/(d(end)/avgDist)));
    
    % Fit downsampled data
    fitElev  = fit(z_dist(1:dsIndex:end),z_elevTube(1:dsIndex:end),...
        'smoothingspline','SmoothingParam',5E-7);
    
    % Derive new elevation vector from fit with original sampling
    z_elevTube   = feval(fitElev,z_dist);
    
    clear avgDist dsIndex
else
    warning('Curve fitting toolbox not available, consider smoothing your elevation profile')
end

% Create height vector (relative to ground) and clean-up
z_height    = constHeight*ones(size(z_elevTube));
clear z constHeight 

end
