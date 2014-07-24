% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 175;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = 0; 
% heightOffset        = 15;
% dactOffset          = 0;

altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
startTime           = 295;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
offsetNSinMeters    = 0; 
heightOffset        = 15;
dactOffset          = 0;

% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 5*60+35;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = -10; 
% heightOffset        = 12;
% dactOffset          = 0;

% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 6*60+50;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = -10; 
% heightOffset        = 12;
% dactOffset          = 0;

% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 16*60+0;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = -5; 
% heightOffset        = 12;
% dactOffset          = 0;
% 
% % altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% % startTime           = 20*60+50;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% % offsetNSinMeters    = -5; 
% % heightOffset        = 12;
% % dactOffset          = 0;
% 
% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 26*60+48;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = -15; 
% heightOffset        = 7;
% dactOffset          = -150;
% 
% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 30*60+08;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = -10; 
% heightOffset        = 0;
% dactOffset          = -250;
% % 
% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 32*60+48;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = -5; 
% heightOffset        = 2;
% dactOffset          = 0 ; %-250;
% 
% altAOffset          = 300;  % offset to make pod appear larger in 2nd axis (overhead)
% startTime           = 35*60+8;    % 33*60; % 34.5*60 % 33.5*60 % 28*60
% offsetNSinMeters    = 0; 
% heightOffset        = 0;
% dactOffset          = -250;


% Updates tube locations based on new N-S offset
latOffset       = offsetNSinMeters/110958.98;
[tubeLat, tubeLon, tubeElev, tubeHeading, tubeTilt] = genTubeLocations(logsout,...
    z_dist,z_elevTube, pillarSpacing,latOffset);

% Update height offset
heightGainBlock = 'sl2ge_hyperloop/vehicleMovement/HeightWrtVehicle1';
set_param(heightGainBlock,'Gain',num2str(heightOffset))

disp(sprintf('Initial latitude = %0.3f',getLOatTime(logsout,'lat',startTime)))
disp(sprintf('Initial longitude = %0.3f',getLOatTime(logsout,'lon',startTime)))

initPillars