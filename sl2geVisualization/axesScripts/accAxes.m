function accHandles = accAxes(hAxes_Accel)

%% Define acceleration axes
% Parameters
ticks   = 2;
maxRadius  = 1;

% Create polar axes
set(hAxes_Accel,'Color','black')
myPolarPlot(hAxes_Accel, ticks, maxRadius)

% Add default circle to indicate intensity
cirX = [0 0 0 0];
cirY = [0 0 0 0];
accHandles.intensityCircle = plot(hAxes_Accel,cirX,cirY);

% Add default data at 0,0
mainSize    = 12;
[x, y]      = pol2cart(0*pi/180,0);
numTraces   = 20;
for ii = 1:numTraces    % smallest ones first
    iIntensity   = ii/numTraces;
    iSize        = mainSize*ii/numTraces;
    accHandles.hAccel{ii}   = plot(hAxes_Accel,x, y,'yo','MarkerSize',iSize,...
        'MarkerFaceColor',[iIntensity iIntensity 0],...
        'MarkerEdgeColor','none');
end
accHandles.hAccelNow   = plot(hAxes_Accel,x, y,'yo','MarkerSize',mainSize,...
    'MarkerFaceColor','y','MarkerEdgeColor','k');

