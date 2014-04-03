function [checkOK, uninstToolboxes, noLicToolboxes] = checkToolbox(toolboxes)
%checkToolboxInstall -  given a cell array of toolbox names, determines if
%   they are currently installed and have available licenses
%
% INPUTS:   toolboxes - cell array or string with toolbox names to check for
%
% OUTPUTS   checkOK: boolean indacting if all toolboxes are available
%           missingToolboxes: cell array of uninstalled toolboxes
%           noLicToolboxes: cell array of unlicenses toolboxes

%   Copyright 2014 The MathWorks, Inc.

% Input checking - must be single string or cell array of strings
if not(iscellstr(toolboxes))
    if ischar(toolboxes)
        toolboxes = {toolboxes};
    else
        error('Input to checkToolbox must be a string or cell array of strings')
    end
end

% create array of installed toolboxes
verOutput   = ver;
[installedToolboxes{1:length(verOutput)}] = verOutput(:).Name;

% check for each toolbox install
checkEachInst   = ismember(toolboxes,installedToolboxes);
checkInstOK     = all(checkEachInst);
uninstToolboxes = toolboxes(checkEachInst==0);

% check for each toolbox license
checkEachLic    = zeros(length(toolboxes),1);
for ii = 1:length(toolboxes)
    checkEachLic(ii) = license('test',verName2LicName(toolboxes{ii}));
end
checkLicOK      = all(checkEachLic);
noLicToolboxes  = toolboxes(checkEachLic==0);

% check both
checkOK         = and(checkInstOK,checkLicOK);
end
function licenseName = verName2LicName(verName)
%verName2LicName -  returns the analagous license name for a toolbox given
%   the standard toolbox name returned by the ver command
%
% INPUTS:   verName - string with version name from ver
%
% OUTPUTS   licenseName - string with version name from/for license

%   Copyright 2014 The MathWorks, Inc.

verStrings = {'Aerospace Blockset'
    'Aerospace Toolbox'
    'Control System Toolbox'
    'Curve Fitting Toolbox'
    'Fuzzy Logic Toolbox'
    'Global Optimization Toolbox'
    'Instrument Control Toolbox'
    'MATLAB'
    'MATLAB Coder'
    'MATLAB Report Generator'
    'Mapping Toolbox'
    'Model Predictive Control Toolbox'
    'Model-Based Calibration Toolbox'
    'Neural Network Toolbox'
    'Optimization Toolbox'
    'Partial Differential Equation Toolbox'
    'Robust Control Toolbox'
    'SimDriveline'
    'SimElectronics'
    'SimEvents'
    'SimHydraulics'
    'SimMechanics'
    'SimPowerSystems'
    'Simscape'
    'Simulink'
    'Simulink 3D Animation'
    'Simulink Coder'
    'Simulink Control Design'
    'Simulink Design Verifier'
    'Simulink Report Generator'
    'Simulink Verification and Validation'
    'Stateflow'};

licStrings = {'Aerospace_Blockset'; ...
    'Aerospace_Toolbox'; ...
    'Control_Toolbox'; ...
    'Curve_Fitting_Toolbox'; ...
    'Fuzzy_Toolbox'; ...
    'GADS_Toolbox'; ...
    'Instr_Control_Toolbox'; ...
    'MATLAB'; ...
    'MATLAB_Coder'; ...
    'MATLAB_Report_Gen'; ...
    'MAP_Toolbox'; ...
    'MPC_Toolbox'; ...
    'MBC_Toolbox'; ...
    'Neural_Network_Toolbox'; ...
    'Optimization_Toolbox'; ...
    'PDE_Toolbox'; ...
    'Robust_Toolbox'; ...
    'SimDriveline'; ...
    'SimElectronics'; ...
    'SimEvents'; ...
    'SimHydraulics'; ...
    'SimMechanics'; ...
    'Power_System_Blocks'; ...
    'Simscape'; ...
    'SIMULINK'; ...
    'virtual_reality_toolbox'; ...
    'RTW_Embedded_Coder'; ...
    'Simulink_Control_Design'; ...
    'Simulink_Design_Verifier'; ...
    'SIMULINK_Report_Gen'; ...
    'SL_Verification_Validation'; ...
    'Stateflow'};

matchingIndex = find(strcmp(verStrings,verName), 1);
if isempty(matchingIndex)
    error('Toolbox "%s" Not found',verName)
else
    licenseName = licStrings{matchingIndex};
end
end