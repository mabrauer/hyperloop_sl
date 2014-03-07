% Filename:     loadVariants.m
% Description:  Loads variants the hyperloop_arc model
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Chassis
if checkToolbox({'Simulink 3D Animation';'SimMechanics';'Simscape'})
    VAR_Chassis     = varChassis.Alpha_sm_s3D;
elseif checkToolbox({'SimMechanics';'Simscape'})
    VAR_Chassis     = varChassis.Alpha_sm;
else
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