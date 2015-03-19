function checkSystemForVisual()
%CHECKSYSTEMFORVISUAL - perform evaluation of user's system to make sure it
%is compliant with the visualization
% Visualization requires 32-bit version of R2014a or R2014b. It uses both
% the mapping toolbox and Simulink 3D Animation.

archString  = computer('arch');
mlVersion   = version('-release');

if not(strcmp('win32',archString))
    error('Google Earth plugin only works on 32-bit version of MATLAB')
end
if and(not(strcmp('2014a',mlVersion)),not(strcmp('2014b',mlVersion)))
    warning('This project has been validated in R2014a and R2014b. Please consider using one of those versions')
end

% Mapping toolbox is used for map figure in top-left
licMappingToolbox   = checkToolbox('Mapping Toolbox');
if not(licMappingToolbox)
    warning('Mapping Toolbox not available. Visualization may not work.')
end

% Simulink 3-D Animisation toolbox is used for front view
licSl3DAnimation    = checkToolbox('Simulink 3D Animation');
if not(licSl3DAnimation)
    warning('Simulink 3D Animation not available. Visualization may not work.')
end

if and(and(or(strcmp('2014a',mlVersion),(strcmp('2014b',mlVersion))),...
        licMappingToolbox),licSl3DAnimation)
    disp(' > System compatible')
end