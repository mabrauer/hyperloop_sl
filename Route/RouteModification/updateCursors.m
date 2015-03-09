function updateCursors( h,time  )
%updateCursors   update cursor position on all plots
%   Copyright 2013 - 2015 The MathWorks, Inc

if not(isnan(time))  % if time is NaN, cursor hasn't been implemented yet, don't update
    
    % Get high resolution and low resolution data
    [dataHR, dataLR] = getData(h);
    
%     index   = min(find(data.time>time));
    indexHR   = find(dataHR.time>time,1);
    indexLR   = find(dataLR.time>time,1);
    
    try
        dist    = dataHR.dist(indexHR);
        set(h.distCursor,'XData',time,'YData',dist)
    end
    
    vel     = dataLR.vel(indexLR);
    accLon  = dataHR.accLon(indexHR);
    accLat  = dataHR.accLat(indexHR);
    lat     = dataHR.lat(indexHR);
    lon     = dataHR.lon(indexHR);
    
    set(h.velCursor,'XData',time,'YData',vel)
    set(h.accLonCursor,'XData',time,'YData',accLon)
    set(h.accLatCursor,'XData',time,'YData',accLat)
    set(h.mapCursor,'XData',lon,'YData',lat)
end

end

