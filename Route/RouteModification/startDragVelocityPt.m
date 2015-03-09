function startDragVelocityPt( ~, ~, h  )
%startDragVelocityPt activate updating route plots as cursor is dragged on
%velocity
% Get handles to axes and figure
ha = get(h.vel,'parent');  
hf = get(ha,'parent'); 

% find cursor position in time and velocity
cursorPos   = get(gca,'CurrentPoint');
cursorTime  = cursorPos(1,1);
cursorVel   = cursorPos(1,2);

% find index to closest time in velocity data
time        = get(h.vel,'XData');
indxBtnDown = find(time>cursorTime,1,'first');

origColor = get(h.vel,'Color');
set(h.vel,'Color','Yellow')

set(hf,'windowButtonUpFcn',{@stopDraggingVelocityPt, h, indxBtnDown, origColor });

end

function stopDraggingVelocityPt(~,~,h,indxBtnDown, origColor)
cursorPos   = get(gca,'CurrentPoint');
cursorTime  = cursorPos(1,1);
cursorVel   = cursorPos(1,2);

% Determine which side of the original index we are on
time        = get(h.vel,'XData');
index       = find(time>cursorTime,1,'first');
if index < indxBtnDown
    timeDir = -1;   % time before original index
else
    timeDir = 1;    % time after original index
end

% Find range of velocity data to modify
velocity   = get(h.vel,'YData');
indexRange = findIndexToMove(time,velocity,indxBtnDown,timeDir);

% Update that section of data to the current cursor velocity
velocity(indexRange) = cursorVel;
set(h.vel,'YData',velocity)

set(h.vel,'Color',origColor);

%% Recalculate plot data
recalcPlotData(h)

%% Disable button up fcn
set(gcf,'windowButtonUpFcn',[]);
end

function indexRange = findIndexToMove(time,vel,index,direction)
% For now just move everything from beginning or to end
% Would like to update to find next/last transition point
if direction < 0
    indexRange = [1:index];
else
    indexRange = [index:1:length(time)-1];
end
end
