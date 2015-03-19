%% Check MATLAB version, architecture and licenses
disp('*** Checking system compatibility ***')
checkSystemForVisual();

%% Load data and open model
disp('*** Loading simulation ***')

% Load simulation results
disp(' > Loading dynamic simulation results')

if exist('projectRoot','var')
    defaultFile = strcat(projectRoot,'\SimResults');
else
    defaultFile = [];
end
[simFilename, simPath] = uigetfile('*.mat','Select the simulation results file',defaultFile);
load([simPath,simFilename])

if not(exist('z_elev','var'))
    z_elev = z_elevTube-z_height;
end

% Set custom parameters for visualizations. These may change based on user
% preference and optimzation of certain sections of the route
disp(' > Setting customizations for visualization')
[ startTime, latOffset, lonOffset, heightOffset,...
    altAOffset, dactOffset ] = getVisPar(logsout.getElement('lat'));

% Initialize pillars
disp(' > Calculating pillar locations')

pillarSpacing   = 30; % meters between pillars
[tubeLat, tubeLon, tubeElev, tubeHeading, tubeTilt] = genTubeLocations(logsout,...
    z_dist,z_elevTube, pillarSpacing,latOffset,lonOffset);
dataLength      = size(z_dist,1);
podIndex        = 1;    % initialize
pillarIndex     = 1;    % initialize

% Open model
disp(' > Opening simulink model')
open('sl2ge_hyperloop.slx');
heightGainBlock = 'sl2ge_hyperloop/heightData/HeightWrtVehicle1';
set_param(heightGainBlock,'Gain',num2str(heightOffset))
camControlPars  % control parameters for camera stateflow logic
stopTime = logsout.getElement('dact').Values.Time(end);
stopTimeResolution = 0.1;   % use this value to round off stopTime to avoid solver warning
stopTime = round(stopTime/stopTimeResolution)*stopTimeResolution;

%% Create UIs and wait
disp('*** Loading Google Earth plugin ***')
disp(' > Two stack overflow warnings are normal. Click OK for each')
myEarth = sl2ge_multiple;
pause(15);
handles = guidata(myEarth);

%% Set initial positions and view
% Start at MathWorks
lat0        = logsout.getElement('lat').Values.Data(1);
lon0        = logsout.getElement('lon').Values.Data(1);
heading     = logsout.getElement('heading_deg').Values.Data(1);

% Hyperloop (ground vehicle)
gv_lat      = lat0;
gv_lon      = lon0;
gv_alt      = 0;
gv_heading  = 0;

% Main view
la_lat      = lat0;
la_lon      = lon0;
la_alt      = 500;
la_heading  = 0;
la_tilt     = 75;
la_range    = 80;

% Overhead view
oh_heading  = 0;
oh_tilt     = 0;
oh_range    = 800;
oh_alt      = 300;

%% Initialize models in GE

% Add views
disp('*** Initializing GoogleEarth ***')
pause(15)
handles.myDoc1.parentWindow.execScript(['addLaView(' num2str(la_range) ',' num2str(la_tilt) ',' num2str(la_alt) ')'], 'Jscript');
pause(2)
handles.myDoc2.parentWindow.execScript(['addLaView(' num2str(oh_range) ',' num2str(oh_tilt) ',' num2str(oh_alt) ')'], 'Jscript');

disp(' > Adding vehicles')
% Add hyperloop vehicle to main viewer (ground vehicle)
handles.myDoc1.parentWindow.execScript(['addGroundVehicle()'], 'Jscript');
pause(3)
handles.myDoc1.parentWindow.execScript( ...
    ['addGVModel(' num2str(lat0) ',' num2str(lon0) ',' num2str(heading) ')'], 'Jscript');

% Add hyperloop vehicle to aerial viewer
handles.myDoc2.parentWindow.execScript(['addAerialVehicle()'], 'Jscript');
pause(2)
handles.myDoc2.parentWindow.execScript( ...
    ['addAerialModel(' num2str(lat0) ',' num2str(lon0) ',' num2str(heading) ')'], 'Jscript');

disp(' > Adding station')
% Add station to main viewer
handles.myDoc1.parentWindow.execScript(['addStation()'], 'Jscript');
pause(4)
handles.myDoc1.parentWindow.execScript( ...
    ['addStationModel(' num2str(lat0) ',' num2str(lon0) ',' num2str(heading) ')'], 'Jscript');
clear station*

% Initialize pillars
disp(' > Adding pillars')
initPillars

% Move to initial position
% try
disp(' > Transporting to starting position')
handles.myDoc1.parentWindow.execScript(['teleportTo(' num2str(lat0) ',' num2str(lon0) ',' num2str(la_heading) ')'], 'Jscript');
handles.myDoc2.parentWindow.execScript(['teleportTo(' num2str(lat0) ',' num2str(lon0) ',' num2str(la_heading) ')'], 'Jscript');
% catch
%     handles.myDoc1.parentWindow.execScript(['teleportTo(' num2str(la_lat) ',' num2str(la_lon) ',' num2str(la_heading) ')'], 'Jscript');
%     handles.myDoc2.parentWindow.execScript(['teleportTo(' num2str(la_lat) ',' num2str(la_lon) ',' num2str(la_heading) ')'], 'Jscript');
% end

%% Get axis handles
% Figure
figureHandle    = getappdata(0,'figureHandle');
% Acceleration
accHandles      = getappdata(figureHandle,'accHandles');
hAccelNow       = accHandles.hAccelNow;
hAccelHist      = accHandles.hAccel;
% Clock
clockHandles    = getappdata(figureHandle,'clockHandles');

% Velocity
% velHandles      = getappdata(figureHandle,'velHandles');
% hVelNow         = velHandles.hVelNow;
% Elevation
elevHandles     = getappdata(figureHandle,'elevHandles');
hAxes           = elevHandles.axes;
hElev           = elevHandles.hElev;
hElevTube       = elevHandles.hElevTube;
hElevTubeNow    = elevHandles.hElevTubeNow;
% Text
hText.Speed     = getappdata(figureHandle,'textHandleSpeed');
hText.Dist      = getappdata(figureHandle,'textHandleDist');
hText.Time      = getappdata(figureHandle,'textHandleTime');
hText.TimeTD    = getappdata(figureHandle,'textHandleTimeTD');

%% Create Map
disp('*** Creating map axis ***')
disp(' > Calculating optimal rotation of map axis')
mapRotation =  orientLatLonForMap(logsout.getElement('lon').Values.Data,...
        logsout.getElement('lat').Values.Data);
try
    disp(' > Plotting map with available topography')
    [mapFigure, mapAxes, plotHandle.map, plotHandle.terrain, plotHandle.current] = ...
        plotRotTrajMap(topo.ZA, topo.RA, logsout.getElement('lon').Values.Data, ...
        logsout.getElement('lat').Values.Data,mapRotation); % assumes lon and lat on same time scale
    nextMapUpdtPlr = 2;
catch
    % section of code used for old data for original route that wasn't
    % configured to be compatible with call above
    disp(' > Plotting map using caliAster data')
    load caliAster
    [mapFigure, mapAxes, plotHandle.map, plotHandle.terrain, plotHandle.current] = ...
        plotRotTrajMap(ZA, RA, logsout.getElement('lon').Values.Data, ...
        logsout.getElement('lat').Values.Data,mapRotation); % assumes lon and lat on same time scale
    nextMapUpdtPlr = 2;
end

%% Display user options to move forward
disp('*** Ready to being visualization ***')
disp(' > Run simulation to begin')
disp(' > use reInitSim.m to fine-tune the simulation effects')