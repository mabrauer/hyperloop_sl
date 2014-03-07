function updatePlots( h,time  )
%updatePlots   update cursor position on all plots
%   Copyright 2013 - 2014 The MathWorks, Inc

if not(isnan(time))  % if time is NaN, cursor hasn't been implemented yet, don't update
    
    data    = getData(h);
    
%     index   = min(find(data.time>time));
    index   = find(data.time>time,1);
    
    try
        dist    = data.dist(index);
        set(h.distCursor,'XData',time,'YData',dist)
    end
    
    vel     = data.vel(index);
    accLon  = data.accLon(index);
    accLat  = data.accLat(index);
    lat     = data.lat(index);
    lon     = data.lon(index);
    
    set(h.velCursor,'XData',time,'YData',vel)
    set(h.accLonCursor,'XData',time,'YData',accLon)
    set(h.accLatCursor,'XData',time,'YData',accLat)
    set(h.mapCursor,'XData',lon,'YData',lat)
end

end

