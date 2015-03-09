function startDragCursor( ~, ~, h  )
%startDragCursor  activate updating plots as cursor is dragged
%   Copyright 2013 - 2014 The MathWorks, Inc

ha = get(h.vel,'parent');  
hf = get(ha,'parent'); 
dragCursor( 0, 0, h );
set(hf,'windowButtonMotionFcn',{@dragCursor,h });
set(hf,'windowButtonUpFcn',{@stopDragging});
end

function stopDragging(~,~)
%stopDragging   disable action functions for moving mouse or releasing button
%   Copyright 2013 - 2014 The MathWorks, Inc
set(gcf,'windowButtonUpFcn',[]);
set(gcf,'windowButtonMotionFcn',[]);
end

function dragCursor( ~ ,~, h  )
%dragCursor   get time position of active cursor and update all plots
%   Copyright 2013 - 2014 The MathWorks, Inc
cursorPos   = get(gca,'CurrentPoint');
time        = cursorPos(1,1);
updateCursors(h,time);
end