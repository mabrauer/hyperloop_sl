% Filename:     loadVariants.m
% Description:  Loads variants the hyperloop_arc model
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Chassis
disp('Loading Chassis Variant')
if checkToolbox({'Simulink 3D Animation';'SimMechanics';'Simscape'})
    disp('   Loading Alpha_sm_s3D')
    VAR_Chassis     = varChassis.Alpha_sm_s3D;
elseif checkToolbox({'SimMechanics';'Simscape'})
    disp('   Alpha_sm_s3D not supported. Loading Alpha_sm')
    VAR_Chassis     = varChassis.Alpha_sm;
else
    disp('   Alpha_sm_s3D and Alpha_sm not supported. Loading Alpha')
    VAR_Chassis     = varChassis.Alpha;
end

%% Compressor
VAR_COMP            = varComp.Alpha;

%% Power / Energy Storage
VAR_POWER           = varPower.Alpha;

%% Propulsion
VAR_PROP            = varProp.Alpha;

%% Tube
if checkToolbox({'Stateflow'})
    VAR_TUBE         = varTube.Alpha_sf; 
else
    VAR_TUBE         = varTube.Alpha;
end