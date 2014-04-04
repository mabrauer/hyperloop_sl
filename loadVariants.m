% Filename:     loadVariants.m
% Description:  Loads variants the hyperloop_arc model
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Chassis
disp('Loading Chassis Variant')
if checkToolbox({'Simulink 3D Animation';'SimMechanics';'Simscape'})
    disp('   Loading Alpha_sm_s3D')
    VAR_Chassis     = varChassis.Alpha_sm_s3D;
elseif checkToolbox({'SimMechanics';'Simscape'})
    disp('   Alpha_sm_s3D not supported (missing Simulink 3D Animation license). Loading Alpha_sm')
    VAR_Chassis     = varChassis.Alpha_sm;
else
    disp('   Alpha_sm_s3D not supported (missing Simulink 3D Animation license)')
    disp('   Alpha_sm not supported (missing SimMechanics and/or Simscape license). Loading Alpha')
    VAR_Chassis     = varChassis.Alpha;
end

%% Compressor
disp('Loading Compressor Variant')
VAR_COMP            = varComp.Alpha;
    disp('   Loading Alpha')


%% Power / Energy Storage
disp('Loading Power Variant')
VAR_POWER           = varPower.Alpha;
    disp('   Loading Alpha')


%% Propulsion
disp('Loading Propulsion Variant')
VAR_PROP            = varProp.Alpha;
    disp('   Loading Alpha')

%% Tube
disp('Loading Tube Variant')
if checkToolbox({'Stateflow'})
    VAR_TUBE         = varTube.Alpha_sf; 
    disp('   Loading Alpha_sf')
else
    VAR_TUBE         = varTube.Alpha;
    disp('   Alpha_sf (missing Stateflow license). Loading Alpha')
end