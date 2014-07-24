dactInit        = getLOatTime(logsout, 'dact', startTime);
counterOffset   = floor(dactInit/pillarSpacing);
pillarIndex     = counterOffset + 1;
nextMapUpdtPlr  = counterOffset + 1;

heightGainBlock = 'sl2ge_hyperloop/heightData/HeightWrtVehicle1';
heightOffset    = str2num(get_param(heightGainBlock,'Gain'));

numPillars = 30;
for i=1:numPillars
    iO = i + counterOffset;
    handles.myDoc1.parentWindow.execScript(['addTube()'], 'Jscript');
    if i==1
        pause(3)
    else
        pause(1)
    end
    [latT, lonT, altT, headT, tiltT, ~] = stringifyLLAHTR(tubeLat(iO), ...
        tubeLon(iO), tubeElev(iO)+heightOffset, -tubeHeading(iO)*180/pi, ...
        tubeTilt(iO)*180/pi, 0);
    handles.myDoc1.parentWindow.execScript(['addTubeModel(' latT ',' lonT ',' altT ',' headT ',' tiltT ')'], 'Jscript');
end