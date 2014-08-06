function [ xRefactor ] = refactorData(x,dataRefactor,interpFlag);
% dataRefactor    = 10; 
dataLenOrig     = size(x,1);
dataLenMod      = dataRefactor*(dataLenOrig-1);
xRefactor               = zeros(dataLenMod,1);

for ii = 1:dataLenOrig-1
    if interpFlag
        xRefactor(dataRefactor*(ii-1)+1:dataRefactor*ii+1) = ...
            linspace(x(ii),x(ii+1),dataRefactor+1);
    else
        xRefactor(dataRefactor*(ii-1)+1:dataRefactor*ii+1) = ...
            linspace(x(ii),x(ii+1),dataRefactor+1);
    end
end