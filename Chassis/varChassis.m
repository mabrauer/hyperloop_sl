% Filename:     varChassis.m
% Description:  Defines enumeration data type for active Chassis variant

% Copyright 2013 - 2014 The MathWorks, Inc

classdef varChassis < Simulink.IntEnumType
   enumeration
      Alpha         (1) % Simulink only
      Alpha_sm      (2) % Simulink and SimMechanics
      Alpha_sm_s3D  (3) % Simulink/SimMechanics/Simulink 3D Animation
   end
end