function updateComfortCircle( handle, radius )
%updateComfortCircle - this function updates a plotted piece of data as a 
% circle with a varying level of intensity

% re-draw circle with defined radius
th = 0 : pi / 40 : 2 * pi;
x = radius*cos(th);
y = radius*sin(th);
set(handle,'XData',x,'YData',y)

% set width of circle based on radius
rVec    = [0   0.1  0.4 1];
wVec    = [0.1 0.5  5   8];
width   = interp1(rVec,wVec,radius,'linear',wVec(end));
set(handle,'LineWidth',width)

% define color of circle
cVec    = [0   0.5 0.8 1];
color   = interp1(rVec,cVec,radius,'linear',cVec(end));
set(handle,'Color',[color 0 0]);

end

