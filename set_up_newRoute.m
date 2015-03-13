%% Open user selected KML file
[defaultRouteFolder] = getDefaultFolder('Route');
[kmlFilename, kmlPath] = uigetfile('*.kml','Select the KML file for your route',defaultRouteFolder);
[lat_kml, lon_kml, z] = read_kml(strcat(kmlPath,kmlFilename));
clear kmlFilename kmlPath defaultRouteFolder

%% Create distance vector and eliminate redundant positions
[ d, lat1, lon1, z ] = distanceBetweenLatLon( lat_kml, lon_kml, z );
clear lat_kml lon_kml 

%% Get elevation data
[topo, z_dist, z_elevTube, z_height] = getElevationData(lat1, lon1, d, z);

%% Create velocity vector
disp('*** Creating velocity vector ***')

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
disp(' > Simple velocity profile. Modify the d and v vectors to customize.')
clear velTgtString_mph vel_mps

%% Save the route data
disp('*** Saving route data ***')
[routeFilename,routePathname] = uiputfile('*.mat','Save the route data');
routeFilename = strcat(routePathname,routeFilename);
save(routeFilename,'lat1','lon1','v','d','z_dist','z_elevTube','z_height','topo')

clear routeFilename routePathname

%% Return to project root folder and give user suggestions on next steps
disp('---Route saved. Run startHere to either modify this route or run a simulation')
clearvars -except ProjectRoot
if exist('projectRoot','var')
    cd(projectRoot)
end