% Filename:     designPars.m
% Description:  Loads design parameters for the hyperloop_arc model
                
% Copyright 2013 - 2014 The MathWorks, Inc

%% Tube
Tube.tempAmbient        = 293;      % 20 C
Tube.pressureAmbient    = 100;      % 100 Pascals referenced on page 12 (Pa)
Tube.powerTube          = -3e6;     % guess for pumps and other tube side power requirements(W)
Tube.powerGridMax       = 6e6;      % max grid power is 6MW from page 35
Tube.powerSolar         = 6e6;      % peak solar power is defined as 285MW on 
                                    % page 35. This seems high given the power 
                                    % capacity of other components. Assume 6 MW 
                                    % for now.
Tube.energyStorage      = 36e6*60*60; % 36 MWhr on page 35 (W-s) 

%% Chassis
Chassis.Mass            = 15e3;     % (kg)
Chassis.DragCoeff       = 320/1130; % 1130 km/h causes 320 N of friction (N/kph)
Chassis.Height          = 1.1;      % (m)             
Chassis.Width           = 1.35;     % (m)        
Chassis.TubeRadius      = 1.15;     % (m)

%% Propulsion
Prop.MaxForce           = 15e3*9.81;% (N) capable of 1 g accel on page 32;  

%% Suspension
Suspension.ChassisMass  = 15e3;     % (kg)

%% Power
Power.MaxEnergy         = 5*85e3*60*60; % (W-s)
                                    % Model S is ~500kg for 85 kWh.
                                    % Page 22 talks about 2500 kg of 
                                    % batteries, so that's roughly 5x85 kWh
Power.Efficiency        = 0.98;     % (0-1) assumption for bi-directional 
                                    % efficiency in and out of battery                                    
                                    
%% Compressor
Comp.CoolantTemp        = 293;      % (K)
Comp.CoolantFlow        = 0.14;     % (kg/sec)
Comp.CoolantMass        = 290;      % (kg)
Comp.Comp1Ratio         = 21;
Comp.IC1OutletTemp      = 300;      % (K)
Comp.FlowToSusp         = 0.2;      % (kg/sec)
Comp.Comp2Ratio         = 5.2;
Comp.IC2OutletTemp      = 400;      % (K)