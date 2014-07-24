function [ustrLat, ustrLon, ustrAlt, ustrHead, ustrTilt, ustrRange]  = stringify6U(u)
    nrV = size(u,1);

    ustrLat = ['[' num2str(u(1,1), '%0.9e')];
    for i=2:nrV ustrLat = [ustrLat ';' num2str(u(i,1), '%0.9e')]; end
    ustrLat = [ustrLat ']'];

    ustrLon = ['[' num2str(u(1,2), '%0.9e')];
    for i=2:nrV ustrLon = [ustrLon ';' num2str(u(i,2), '%0.9e')]; end
    ustrLon = [ustrLon ']'];

    ustrAlt = ['[' num2str(u(1,3), '%0.9e')];
    for i=2:nrV ustrAlt = [ustrAlt ';' num2str(u(i,3), '%0.9e')]; end
    ustrAlt = [ustrAlt ']'];

    ustrHead = ['[' num2str(u(1,4), '%0.9e')];
    for i=2:nrV ustrHead = [ustrHead ';' num2str(u(i,4), '%0.9e')]; end
    ustrHead = [ustrHead ']'];
    
    ustrTilt = ['[' num2str(u(1,5), '%0.9e')];
    for i=2:nrV ustrTilt = [ustrTilt ';' num2str(u(i,5), '%0.95e')]; end
    ustrTilt = [ustrTilt ']'];

    ustrRange = ['[' num2str(u(1,6), '%0.9e')];
    for i=2:nrV ustrRange = [ustrRange ';' num2str(u(i,6), '%0.9e')]; end
    ustrRange = [ustrRange ']'];
    
end