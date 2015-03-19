disp('*** Re-initializing the visualization ***')
[ startTime, latOffset, lonOffset, heightOffset,...
    altAOffset, dactOffset ] = getVisPar(logsout.getElement('lat'));

%% Updates tube locations based on new offsets
disp(' > Updating tube locations')

[tubeLat, tubeLon, tubeElev, tubeHeading, tubeTilt] = genTubeLocations(logsout,...
    z_dist,z_elevTube, pillarSpacing,latOffset,lonOffset);

disp(sprintf(' > Initial latitude = %0.3f',getLOatTime(logsout,'lat',startTime)))
disp(sprintf(' > Initial longitude = %0.3f',getLOatTime(logsout,'lon',startTime)))

initPillars