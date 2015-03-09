function startDragRoutePts( ~, ~, h  )

% Get handles to axes and figure
ha = get(h.routePts,'parent');  
hf = get(ha,'parent'); 

% find cursor position in lat and lon
cursorPos   = get(gca,'CurrentPoint');
lon_lat     = cursorPos(1,1:2);

% find index to closest position in route data
RouteLon    = get(h.routePts,'XData');
RouteLat    = get(h.routePts,'YData');
Route       = [RouteLon' RouteLat'];
error       = Route - ones(size(Route))*[lon_lat(1) 0;0 lon_lat(2)];
errorAbs    = abs(error);
error       = sum(errorAbs,2);
index       = find(min(abs(error))==abs(error));

set(hf,'windowButtonMotionFcn',{@dragRoutePt, h, index});
set(hf,'windowButtonUpFcn',{@stopDraggingRoutePt, h });
end

function dragRoutePt( ~ ,~, h, index  )
cursorPos   = get(gca,'CurrentPoint');
lon_lat     = cursorPos(1,1:2);

RouteLon    = get(h.routePts,'XData');
RouteLat    = get(h.routePts,'YData');
Route       = [RouteLon' RouteLat'];

Route(index,:) = lon_lat;

set(h.routePts,'XData',Route(:,1),'YData',Route(:,2))

end

function stopDraggingRoutePt(~,~,h)

% Turn off button up and button motion functions
set(gcf,'windowButtonUpFcn',[]);
set(gcf,'windowButtonMotionFcn',[]);

%% Recalculate plot data
recalcPlotData(h)

end
