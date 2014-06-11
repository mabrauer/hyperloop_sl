function accelZ = calcVertAccel(z_elevTube,z_dist, d, v, absOn)

% z_elevTube - tube elevation (m) wrt z_dist
% z_dist - distance (m)
% d - distance (m)
% v - velocity (m/s) wrt d

z_velocity          = interp1(d,v,z_dist,'linear','extrap');
elevChange          = diff(z_elevTube);
distChange          = diff(z_dist);
velocity            = z_velocity(1:end-1);
incline             = atan(elevChange./distChange); % radians
velocityZ           = velocity.*sin(incline);
velocityChange      = [0;diff(velocityZ)];
if absOn
    accelZ              = abs(velocityChange./(distChange./velocity));
else
    accelZ              = velocityChange./(distChange./velocity);
end
accelZ              = [0;accelZ];