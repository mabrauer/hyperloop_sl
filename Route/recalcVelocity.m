function [v, t] = recalcVelocity(d,vt,transAccelLim,stopAtEnd)

v       = zeros(size(vt));
v(1)    = 0;
t       = zeros(size(vt));
for ii = 2:length(d)
    % check if need to start deceleration
    if and(ii == length(d),stopAtEnd)
        % at the end
        v(ii) = 0;
        deltaT = 2*(d(ii)-d(ii-1))/(v(ii)+v(ii-1));
    else
        distToEnd = d(end) - d(ii);
        accelToStop = vt(ii)^2/(2*distToEnd);
        if and(accelToStop >= transAccelLim,stopAtEnd)
            % need to start decel
            v(ii) = sqrt(2*transAccelLim*distToEnd);
            deltaT = 2*(d(ii)-d(ii-1))/(v(ii)+v(ii-1));
        else
            % deceleration to end not required, enforce accel/decel limit
            deltaV = vt(ii)-v(ii-1);
            deltaT = 2*(d(ii)-d(ii-1))/(vt(ii)+v(ii-1));
            accelTarget = deltaV/deltaT;
            accelDir = accelTarget/abs(accelTarget);
            if abs(accelTarget) < transAccelLim
                v(ii) = vt(ii);
            else
                v(ii) = sqrt(v(ii-1)^2+2*accelDir*transAccelLim*(d(ii)-d(ii-1)));
                deltaT = 2*(d(ii)-d(ii-1))/(v(ii)+v(ii-1));
            end
        end
    end
    t(ii) = t(ii-1)+deltaT;
end