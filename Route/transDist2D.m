function [d, x, y, remIdx] = transDist2D(x, y)
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
    if and(d(ii) < 10,ii<size(d,1));
        x = [x(1:ii-1);x(ii+1:end)];
        y = [y(1:ii-1);y(ii+1:end)];
        d(ii+1) = d(ii+1) + d(ii);
        d = [d(1:ii-1);d(ii+1:end)];
        remIdx = [remIdx;ii];
    else
        d(ii) = d(ii) + d(ii-1);
        ii = ii+1;
    end
end