%% Open user selected KML file
cd Route
[kmlFilename, kmlPath] = uigetfile('*.kml','Select the KML file for your route');
cd(kmlPath)
[lat_kml, lon_kml, z] = read_kml(kmlFilename);
clear kmlFilename kmlPath

%% Create distance vector and eliminate redundant positions
[ d, lat1, lon1, z ] = distanceBetweenLatLon( lat_kml, lon_kml, z );
clear lat_kml lon_kml 

%% Decide how to handle elevation data
disp('*** Checking Elevation data ***')

licMapTB    = checkToolbox('Mapping Toolbox');
noElev      = and((max(z)==0),(min(z)==0));

if and(noElev,licMapTB)
    % data isn't included but user has mapping toolbox, so load using
    % mapping tool
    disp('> Elevation data not included. Using Mapping Toolbox')
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
    warning('> There is no elevation data included in your kml file')
    warning('  It is recommended to either:')
    warning('   - Use the Mapping Toolbox')
    warning('   - Supplement your KML file using www.gpsvisualizer.com') 
else
    % elevation data and no mapping toolbox
    warning('> Using elevation data provided.')
    warning('  You may get better results using the Mapping Toolbox')
end

clear licMapTB noElev

%% Populate elevation and height data assuming constant height above ground

% Create initial elevation vector with constant height above ground
z_dist      = d;
constHeight = 2;
fprintf('*** Populating elevation data with constant %dm above ground level ***',constHeight)
z_elevTube  = z + constHeight*ones(size(z));

% Create smoothed elevation profile by downsampling and fitting the data
if checkToolbox('Curve Fitting Toolbox')
    % Determine downsampling
    avgDist         = 500;  % average 500 m between elevation points 
    dsIndex         = round((length(z_dist)/(d(end)/avgDist)));
    
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

%% Create velocity vector
disp('*** Populating velocity vector ***')

% Create a prompt and request user to define velocity (single speed)
velDlg.prompt = {'Enter target velocity (mph)'};
velDlg.title = 'Target velocity';
velDlg.num_lines = 1;
velDlg.default = {'760'};
velDlg.options.Resize='on';
velDlg.options.WindowStyle='normal';
velDlg.options.Interpreter='tex';
velTgtString_mph = inputdlg(velDlg.prompt,velDlg.title,...
    velDlg.num_lines,velDlg.default,velDlg.options);
clear velDlg

% Create velocity/distance profile based on defined acceleration limits
vel_mps = 0.44704*str2num(velTgtString_mph{1});
[v, ~] = recalcVelocity(d,vel_mps*ones(size(d)),5,1);
warning('Simple velocity profile. Modify the d and v vectors to customize.')
clear velTgtString_mph vel_mps

%% Save the route data
disp('*** Saving route data ***')
saveDlg.prompt = {'Enter a filename for your route'};
saveDlg.title = 'Save Route';
saveDlg.num_lines = 1;
saveDlg.default = {'myFile'};
saveDlg.options.Resize='on';
saveDlg.options.WindowStyle='normal';
saveDlg.options.Interpreter='tex';
routeFilename = inputdlg(saveDlg.prompt,saveDlg.title,saveDlg.num_lines,...
    saveDlg.default,saveDlg.options);
save(routeFilename{1},'lat1','lon1','v','d','z_dist','z_elevTube','z_height','topo')
clear saveDlg

%% Return to project root folder
cd(projectRoot)
clearvars -except ProjectRoot