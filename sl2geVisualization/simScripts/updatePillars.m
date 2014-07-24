function updatePillars(u)

indexObject  = u(1);    % rolling index within pillar objects
indexOverall = u(2);    % index over total pillars over complete route
heightAdj    = u(3);    
indexOverallStr = num2str(indexOverall);

evalin('base',['pillarIndex = ',indexOverallStr,';'])

tubeLat     = evalin('base','tubeLat(pillarIndex)');
tubeLon     = evalin('base','tubeLon(pillarIndex)');
tubeAlt     = evalin('base','tubeElev(pillarIndex)')+heightAdj;
tubeHeading = evalin('base','tubeHeading(pillarIndex)');
tubeTilt    = evalin('base','tubeTilt(pillarIndex)');
handles     = evalin('base','handles');

[indexT, latT, lonT, altT, headT, rollT] = stringifyILLAHR(indexObject, ...
    tubeLat, tubeLon, tubeAlt, -tubeHeading*180/pi, tubeTilt*180/pi);

handles.myDoc1.parentWindow.execScript(['moveTube(' indexT ',' latT ',' lonT ',' altT ',' headT ',' rollT ')'], 'Jscript');

end