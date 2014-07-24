function myPolarPlot(hAxes, rticks, Radius)

% Create circumferential lines
th = 0 : pi / 50 : 2 * pi;
for ii = 1:rticks
    xunit = Radius/ii*cos(th);
    yunit = Radius/ii*sin(th);
    if ii == 1
        plot(hAxes,xunit,yunit,'w','LineWidth',2)
    else
        plot(hAxes,xunit,yunit,'w','LineWidth',0.5,'LineStyle',':')
    end
    hold on
    set(hAxes,'Color','black')
end

% Create radial lines
plot(hAxes,[-Radius 0 Radius],[0 0 0],'w','LineWidth',1)
plot(hAxes,[0 0 0],[-Radius 0 Radius],'w','LineWidth',1)

% Add labels
text(0,Radius*1.1,'Vertical Gs','Color','white',...
    'HorizontalAlignment','center')
text(Radius*1.1,-Radius*0.3,'Horizontal Gs','Color','white','Rotation',90)
text(0.55*Radius*sin(45*pi/180), 0.55*Radius*sin(45*pi/180),'0.5g','Color','White')
text(1.05*Radius*sin(45*pi/180), 1.05*Radius*sin(45*pi/180),'1g','Color','White')