%% Open user selected KML file
cd Route
[kmlFilename, kmlPath] = uigetfile('*.kml','Select the KML file for your route');
cd(kmlPath)
[lat1, lon1, z] = read_kml(kmlFilename);
clear kmlFilename kmlPath

%% Create distance vector and eliminate redundant positions
disp('*** Creating distance vector ***')

% get x and y position in meters, oriented from start to end along x axis
[x, y, transMatrix]     = reorientLatLon(lat1,lon1);

% get distance vector, eliminating redundant position points
[d, x, y]               = transDist2D(x, y);

% convert position points back to latitude and longitude
[lat1, lon1]            = reorientXY2LatLon(x,y,transMatrix,lat1(1),lon1(1));

clear x y transMatrix

%% Decide how to handle elevation data
disp('*** Checking Elevation data ***')
licMapTB = checkToolbox('Mapping Toolbox');
noElev = and((max(z)==0),(min(z)==0));

if and(noElev,licMapTB)
    % data isn't included but user has mapping toolbox, so load using
    % mapping tool
    disp('Elevation data not included. Using Mapping Toolbox')
    z = loadElevWithMappingToolbox(lat1, lon1);
elseif licMapTB
    % data is included but user has mapping toolbox, give option to use it
    questStr = 'You have the mapping toolbox, would you like to use it load new elevation data?';
    keepStr = 'Keep existing elevation data';
    replaceStr = 'Load new data and replace existing';
    desElevData = questdlg(questStr,'Elevation Data',...
        keepStr,replaceStr,keepStr);
    if strcmp(desElevData,replaceStr)
        % replace existing elevation data
        z = loadElevWithMappingToolbox(lat1, lon1);
    end
    clear questStr keepStr replaceStr desElevData
elseif noElev
    % no elevation data and no mapping toolbox
    warning('There is no elevation data included in your kml file')
    warning('It is recommended to either:')
    warning('   - Use the Mapping Toolbox')
    warning('   - Supplement your KML file using www.gpsvisualizer.com') 
else
    % elevation data and no mapping toolbox
    warning('Using elevation data provided.')
    warning('You may get better results using the Mapping Toolbox')
end

clear licMapTB noElev

%% Populate elevation and height data assuming constant height above ground
disp('*** Populating elevation data with constant 5m above ground level ***')
z_dist      = d;
z_height    = 5*ones(size(z_dist));
z_elevTube  = z + z_height;

clear z

%% Create velocity vector
disp('*** Populating velocity vector ***')
velDlg.prompt = {'Enter target velocity for route (mph)'};
velDlg.title = 'Target velocity';
velDlg.num_lines = 1;
velDlg.default = {'760'};
velDlg.options.Resize='on';
velDlg.options.WindowStyle='normal';
velDlg.options.Interpreter='tex';
vel_mph = inputdlg(velDlg.prompt,velDlg.title,velDlg.num_lines,...
    velDlg.default,velDlg.options);
clear velDlg

vel_mps = 0.44704*str2num(vel_mph{1});

v = vel_mps*ones(size(d));
warning('Velocity vector is constant %0.0f (m/s)',vel_mps)
warning('Modify the d and v vectors to change the desired velocity')

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
save(routeFilename{1},'lat1','lon1','v','d','z_dist','z_elevTube','z_height')
clear saveDlg

%% Return to project root folder
project = simulinkproject;
cd(project.RootFolder)
clear project
