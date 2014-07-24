function updateGoogleEarth( u )
% Function called from Simulink. 

% Update vehicle position in workspace
vehPosU     = u(1:6);
[ustrLat, ustrLon, ustrAlt, ustrHead, ustrRoll, plrIdx] = stringifyU(vehPosU);
evalStr = ['gv_lat = ' ustrLat '; gv_lon = ' ustrLon '; gv_alt = '  ustrAlt '; gv_heading = ' ustrHead '; gv_roll = ' ustrRoll '; gv_plrIdx = ' plrIdx ';'];
evalin('base', evalStr);


% Update main viewer settings in workspace
laPosU      = u(7:12);
[ustrLat, ustrLon, ustrAlt, ustrHead, ustrTilt, ustrRange] = stringify6U(laPosU);
evalStr = ['la_lat = ' ustrLat '; la_lon = ' ustrLon '; la_alt = '  ustrAlt '; la_heading = ' ustrHead '; la_tilt = ' ustrTilt '; la_range = ' ustrRange ';'];
evalin('base', evalStr);

% Call main update from workspace
evalin('base','mainGoogleEarthUpdate')
end

