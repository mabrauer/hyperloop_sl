function [accel_local] = accelFromTrajectory(x,y,v)

% Check size of inputs, all subsequent math assumes row vectors
[rows, cols] = size(x);
if rows > cols
    x = x';y=y';v=v';
    transFlag = 1;
elseif cols == rows
    error('Input data is square, unable to determine orientation')
end

trajLen = size(x,2);

%% Sectional displacements and orientations
% Calculate sectional displacement and orientation vectors
dx = [diff(x),0];
dy = [diff(y),0];
tau = [dx;dy];
s = sqrt(tau(1,:).^2+tau(2,:).^2);

% Time between each section
t = 2*s(1:end-1)./(v(2:end)+v(1:end-1));
t(trajLen) = 0;

%% Velocity and acceleration
% Velocity vector at each point (tangential to orientation vectors before
% and after that point)
tauNorm = zeros(size(tau));
Vv_temp = zeros(size(tauNorm));
Vv      = zeros(size(tauNorm));
for ii = 1:trajLen % is there a row by row norm?
  if ii ~= trajLen  % not the last entry
      tauNorm(:,ii) = tau(:,ii)/norm(tau(:,ii)); % Normalized orientation vectors (magnitude of 1)
      Vv_temp(:,ii) = mean([tauNorm(:,ii),tauNorm(:,ii+1)],2);  % take mean
      Vv_temp(:,ii) = Vv_temp(:,ii)/norm(Vv_temp(:,ii));        % re-normalize
  else              % last entry
      tauNorm(:,ii) = tauNorm(:,ii-1);
      Vv_temp(:,ii) = tauNorm(:,ii);
  end
  Vv(:,ii)      = v(ii)*Vv_temp(:,ii);     
end

clear Vv_temp

% Acceleration in global coordinate frame
alpha = (Vv(:,2:end)-Vv(:,1:end-1))./[t(1:end-1);t(1:end-1)];
alpha(:,trajLen) = [0;0];

%% Local acceleration (body reference frame)
theta       = zeros(1,trajLen);
coordTrans  = zeros(2,2,trajLen);
accel_local = zeros(2,trajLen); 
for ii=1:trajLen
    if dx(ii)<0         % quadrant II or III
        theta(ii) = pi + atan(dy(ii)/dx(ii));
    elseif dx(ii)>0     % quadrant I or IV
        theta(ii) = atan(dy(ii)/dx(ii));
    elseif dy(ii)>=0    % 90 degree case
        theta(ii) = pi/2;
    else                % 270 degree case
        theta(ii) = -pi/2;
    end
    coordTrans(:,:,ii)= [cos(theta(ii)) sin(theta(ii));-sin(theta(ii)) cos(theta(ii))];
    accel_local(:,ii) = coordTrans(:,:,ii)*alpha(:,ii);
end

% Transpose output if inputs were column vectors
if transFlag == 1
    accel_local = accel_local';
end