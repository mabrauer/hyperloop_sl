function pieHandles = plotTimePie(time,timeRemain, axes)

if time > 1
    data = [60*60-time-timeRemain;timeRemain;time];
    labels = {'','',''};
    pieHandles = pie(axes,data,labels);
    set(pieHandles(1),'FaceColor','k')
    set(pieHandles(3),'FaceColor','w')
    set(pieHandles(5),'FaceColor','y')
    
    set(pieHandles(1),'LineStyle','none')
    set(pieHandles(3),'LineStyle','none')
else
    data = [60*60-timeRemain;timeRemain];        
    labels = {'',''};
    pieHandles = pie(axes,data,labels);
    set(pieHandles(1),'FaceColor','k')
    set(pieHandles(3),'FaceColor','w')
    
    set(pieHandles(1),'LineStyle','none')
    set(pieHandles(3),'LineStyle','none')
end

end