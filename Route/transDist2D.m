function [d, x, y, remIdx] = transDist2D(x, y, minDelta)
% Calculates linear displacement vector corresponding to 2-D route data. 
% Will remove sequential x-y duplicates 

%% Determine translational position vector
d = zeros(size(x));
d(2:end) = sqrt((x(2:end)-x(1:end-1)).^2+...
    (y(2:end)-y(1:end-1)).^2);
% rowsRemovedNum = 0;
ii = 2;
remIdx = [];
while ii<=size(d,1);
    if and(d(ii) < minDelta,ii<size(d,1));
        d(ii-1) = d(ii-1) + d(ii);       % add delta to previous delta point
        d(ii) = [];                         
        remIdx = [remIdx;ii+length(remIdx)];
    else
        d(ii) = d(ii) + d(ii-1);
        ii = ii+1;
    end
end
x(remIdx)    = [];
y(remIdx)    = [];