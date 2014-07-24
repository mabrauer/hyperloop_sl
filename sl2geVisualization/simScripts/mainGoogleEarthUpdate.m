% This script is called from within a MATLAB function called by Simulink
[latA, lonA, altA, headA, rollA, tiltA] = stringifyLLAHRT(gv_lat, gv_lon, gv_alt, gv_heading, gv_roll, tubeTilt(gv_plrIdx)*180/pi);
handles.myDoc1.parentWindow.execScript(['moveGV(' latA ',' lonA ',' altA ',' headA ',' rollA ',' tiltA ')'], 'Jscript');

[altA2] = addToStringifiedAlt(altA,altAOffset);
handles.myDoc2.parentWindow.execScript(['moveAerialV(' latA ',' lonA ',' altA2 ',' headA ')'], 'Jscript');
                     
if not(exist('stationExists','var'))
    handles.myDoc1.parentWindow.execScript(['moveStation(' latA ',' lonA ',' altA ',' headA ',' tiltA ')'], 'Jscript');
%     handles.myDoc2.parentWindow.execScript(['moveStation(' latA ',' lonA ',' altA ',' headA ',' tiltA ')'], 'Jscript');
    stationExists = 1;
end

laI = 0;
[latA, lonA, altA, headA, tiltA, rangeA] = stringifyLLAHTR(la_lat, la_lon, la_alt, la_heading, la_tilt, la_range);
handles.myDoc1.parentWindow.execScript(['moveFullLaView(' num2str(laI) ',' latA ',' lonA ',' altA ',' headA ',' tiltA ',' rangeA ')'], 'Jscript'); 

[latA, lonA, altA, headA, tiltA, rangeA] = stringifyLLAHTR(la_lat, la_lon, la_alt, oh_heading, oh_tilt, oh_range);
handles.myDoc2.parentWindow.execScript(['moveFullLaView(' num2str(laI) ',' latA ',' lonA ',' altA2 ',' headA ',' tiltA ',' rangeA ')'], 'Jscript'); 

%pass in -1 to not update: moveObjects(la, gv, av, t, st)
if not(exist('stationUpdated','var'))
    handles.myDoc1.parentWindow.execScript(['synchronousUpdate(' num2str(laI) ', 0, -1, 0, 0)'], 'Jscript');
    handles.myDoc2.parentWindow.execScript(['synchronousUpdate(' num2str(laI) ', -1, 0, -1, -1)'], 'Jscript');     stationUpdated = 1;
else
    handles.myDoc1.parentWindow.execScript(['synchronousUpdate(' num2str(laI) ', 0, -1, 0, -1)'], 'Jscript');
    handles.myDoc2.parentWindow.execScript(['synchronousUpdate(' num2str(laI) ', -1, 0, -1, -1)'], 'Jscript');
end