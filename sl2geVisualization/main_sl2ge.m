%% Check MATLAB version, architecture and licenses
archString  = computer('arch');
mlVersion   = version('-release');

disp('Google Earth plugin only works on 32-bit version of MATLAB')

if not(strcmp('win32',archString))
    error('Google Earth plugin only works on 32-bit version of MATLAB')
end

if not(strcmp('2014a',mlVersion))
    warning('This project was developed in R2014a. Please consider using that version')
end

% Mapping toolbox is used for map figure in top-left
licMappingToolbox   = checkToolbox('Mapping Toolbox');   

% Simulink 3-D Animisation toolbox is used for front view
licSl3DAnimation    = checkToolbox('Simulink 3D Animation');    

%% Load data and open model
altAOffset          = 200; % offset to make pod appear larger in 2nd axis (overhead)
startTime           = 0; %  33*60; % 34.5*60 % 33.5*60 % 28*60
offsetNSinMeters    = 20;  % offset North/South to make visualization
                            % look more realistic (highway median)
heightOffset        = 4;
dactOffset          = 0;    % offset due to slight translational distance
                            % that accumulates along route

% Load data
% load Results_20140331 % this data has improved passenger g calc's but not modified elev
% logsoutPG       = logsout;
% load Results_20140226_modifiedElev
cd SimResults
[simFilename, simPath] = uigetfile('*.mat','Select the simulation results file');
load([simPath,simFilename])
cd(projectRoot)

latOffset       = offsetNSinMeters/110958.98;
if not(exist('z_elev','var'))
    z_elev = z_elevTube-z_height;
end

% Initialize pillars
pillarSpacing   = 30; % meters between pillars
[tubeLat, tubeLon, tubeElev, tubeHeading, tubeTilt] = genTubeLocations(logsout,...
    z_dist,z_elevTube, pillarSpacing,latOffset);
dataLength      = size(z_dist,1);
podIndex        = 1;    % initialize
pillarIndex     = 1;    % initialize

% Open model
open('sl2ge_hyperloop.slx');
heightGainBlock = 'sl2ge_hyperloop/heightData/HeightWrtVehicle1';
set_param(heightGainBlock,'Gain',num2str(heightOffset))
camControlPars  % control parameters for camera stateflow logic
stopTime = logsout.getElement('dact').Values.Time(end);

%% Create UIs and wait
disp('Loading Google Earth plugin. Two stack overflow warnings are normal. Click OK for each')
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
disp('--- Initializing GoogleEarth')
pause(15)
handles.myDoc1.parentWindow.execScript(['addLaView(' num2str(la_range) ',' num2str(la_tilt) ',' num2str(la_alt) ')'], 'Jscript');
pause(2)
handles.myDoc2.parentWindow.execScript(['addLaView(' num2str(oh_range) ',' num2str(oh_tilt) ',' num2str(oh_alt) ')'], 'Jscript');

disp('--- Adding vehicles')
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

disp('--- Adding station')
% Add station to main viewer
handles.myDoc1.parentWindow.execScript(['addStation()'], 'Jscript');
pause(4)
handles.myDoc1.parentWindow.execScript( ...
    ['addStationModel(' num2str(lat0) ',' num2str(lon0) ',' num2str(heading) ')'], 'Jscript');
clear station*

% Initialize pillars
disp('--- Adding pillars')
initPillars

% Move to initial position
% try
disp('--- Transporting to starting position')
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

% Map
disp('Creating map axis')
degSpace    = 0.05;     % At least this much space around round (deg)
degRound    = 0.1;      % Maps is rounded to nearest (deg)
latLim = [degRound*floor(min(lat1-degSpace)/degRound) degRound*ceil(max(lat1+degSpace)/degRound)];
lonLim = [degRound*floor(min(lon1-degSpace)/degRound) degRound*ceil(max(lon1+degSpace)/degRound)];
try
    [mapFigure, mapAxes, plotHandle.map, plotHandle.terrain, plotHandle.current] = ...
        plotRotTrajMap(topo.ZA, topo.RA, logsout.getElement('lon').Values.Data, ...
        logsout.getElement('lat').Values.Data,-60); % assumes lon and lat on same time scale
    nextMapUpdtPlr = 2;
catch
    load caliAster
    [mapFigure, mapAxes, plotHandle.map, plotHandle.terrain, plotHandle.current] = ...
        plotRotTrajMap(ZA, RA, logsout.getElement('lon').Values.Data, ...
        logsout.getElement('lat').Values.Data,-60); % assumes lon and lat on same time scale
    nextMapUpdtPlr = 2;
end

% % old method
% if licMappingToolbox
%     load caliAster
%     [mapFigure, mapAxes, plotHandle.map, plotHandle.terrain, plotHandle.current] = ...
%         plotRotTrajMap(ZA, RA, logsout.getElement('lon').Values.Data, ...
%         logsout.getElement('lat').Values.Data,-60); % assumes lon and lat on same time scale
%     nextMapUpdtPlr = 2;
% end