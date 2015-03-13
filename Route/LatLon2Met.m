function [ lat2met, lon2met ] = LatLon2Met( lat )
%LATLON2MET Calculates the degree to meter equivalent for degrees of
%longitude and latitude, given a vector of latitudes

% Look-up table of conversions at specific latitudes in Northern hemisphere
LatLon2Met.Lat      = [30      35      40       45      50];
LatLon2Met.Lat2Met  = [110852  110940  111035   111132  111229];
LatLon2Met.Lon2Met  = [96486   91288   85394    78847   71696];

% Determine conversion at middle latitude
midLat  = (max(lat)+min(lat))/2 ;
lat2met = interp1(LatLon2Met.Lat,LatLon2Met.Lat2Met,midLat);
lon2met = interp1(LatLon2Met.Lat,LatLon2Met.Lon2Met,midLat);

end

