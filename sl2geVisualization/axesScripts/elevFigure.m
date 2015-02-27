function elevHandles = elevFigure(hAxes)

%% Create figure
% hFig = figure('Position',[200 50 600 400]);
% set(hFig,'Name','Elevation')
% set(hFig,'Color','black')

%% Define axes
% hAxes = gca;
hold on
set(hAxes,'Color','black')
set(hAxes,'SortMethod','childorder') % updated from using DrawMode property based on R2014b warning
set(hAxes,'FontSize',12)
set(hAxes,'GridLineStyle',':')
set(hAxes,'XColor','white')
set(hAxes,'YColor','white')
ylabel('Elevation (m)','Color','white','FontSize',12)
xlabel('Distance (km)','Color','white','FontSize',12)

%% Get data from base workspace
z_dist          = evalin('base','z_dist');
z_elev          = evalin('base','z_elev');
z_elevTube      = evalin('base','z_elevTube');

%% Initialize plots
% vertical range to maintain
elevPlotRange   = 100;  % note this is defined in udpateFigures.m for running value 
elevPlotDist    = 1;    % note this is defined in udpateFigures.m for running value
dataLength      = size(z_dist,1);

% Limits
xlim([0 elevPlotDist])
ylim([z_elevTube(1)-elevPlotRange/2 z_elevTube(1)+elevPlotRange/2])
set(hAxes,'YLimMode','manual')
set(hAxes,'XLimMode','manual')

% Initial plots
elevHandles.hElev           = plot(z_dist/1e3,z_elev,'w','LineWidth',3);
elevHandles.hElevTube       = plot(z_dist/1e3,nan*ones(size(z_dist)),'y','LineWidth',2);
elevHandles.hElevTubeNow    = plot(z_dist(1)/1e3, z_elevTube(1),'yo','MarkerSize',8,'MarkerFaceColor','y');

end