function [handle] = plotTrajAccel(t_v,v,t,accel, d)
% plotTrajAccel - create a figure with subplots of distance (optional),
% velocity and lateral/longitudinal acceleration vs. time. Return handle to
% the figure, axes and individual data lines.
%
%   Copyright 2013 - 2014 The MathWorks, Inc

% t_v - Time in sec for velocity data
% v - Velocity in m/s
% t - Time in sec for acceleration and distance data
% accel - Acceleration in m/s2
% d - Distance in m (optional)

%% Determine if distance should be included
% check if distance data should be included in plot
if nargin == 5;
    subplotIndex = [311 312 313];
    incDist = true;
else
    subplotIndex = [000 211 212];
    incDist = false;
end

%% Create plot
scrsz = get(0,'ScreenSize');
handle.fig = figure('Position',[scrsz(3)*0.51 scrsz(4)*0.05 scrsz(3)*0.48 scrsz(4)*0.85]);

% Distance subplot if included
if incDist
    subplot(subplotIndex(1))
    handle.dist = line(t/60,d*0.000621371,'LineWidth',2);
    ylabel('Distance (miles)','FontSize',14)
    grid on
    set(gca,'FontSize',14)
end

% Velocity subplot
subplot(subplotIndex(2))
handle.vel      = line(t_v/60,v*2.23694,'LineWidth',2);
grid on
ylabel('Velocity (mph)','FontSize',14)
set(gca,'FontSize',14)

% Acceleration subplot
subplot(subplotIndex(3))
handle.accelLong    = line(t/60,accel(:,1)/9.82,'LineWidth',2);
handle.accelLat     = line(t/60,accel(:,2)/9.82,'LineWidth',2,'Color','g');
legend('Longitudinal','Lateral','Location','North')
grid on
ylabel('Acceleration (g)','FontSize',14)
xlabel('Time (min)','FontSize',14)
set(gca,'FontSize',14)
ylim([-1.5 1.5])

%% Add invisible cursor and create handle structure 
% Distance
if incDist
    handle.distAxes = get(handle.dist,'Parent');
    hold(handle.distAxes,'on');
    axes(handle.distAxes)
    handle.distCursor = line(nan,nan,'MarkerEdgeColor','y','Marker','o','MarkerSize',8,'LineWidth',4);
end

% Velocity
handle.velAxes  = get(handle.vel,'Parent');
handle.accAxes  = get(handle.accelLat,'Parent');
hold(handle.velAxes,'on');
axes(handle.velAxes)
handle.velCursor = line(nan,nan,'MarkerEdgeColor','y','Marker','o','MarkerSize',8,'LineWidth',4);

% Acceleration
hold(handle.accAxes,'on');
axes(handle.accAxes)
handle.accLonCursor = line(nan,nan,'MarkerEdgeColor','y','Marker','o','MarkerSize',8,'LineWidth',4);
handle.accLatCursor = line(nan,nan,'MarkerEdgeColor','m','Marker','o','MarkerSize',8,'LineWidth',4);
