function [latA, lonA, altA, headA] = stringifyLLAH(lat, lon, alt, head)

latA = ['[' num2str(lat(1), '%0.9e')];
for i=2:size(lat) latA = [latA ',' num2str(lat(i), '%0.9e')]; end
latA = [latA ']'];

lonA = ['[' num2str(lon(1), '%0.9e')];
for i=2:size(lon) lonA = [lonA ',' num2str(lon(i), '%0.9e')]; end
lonA = [lonA ']'];

altA = ['[' num2str(alt(1), '%0.9e')];
for i=2:size(alt) altA = [altA ',' num2str(alt(i), '%0.9e')]; end
altA = [altA ']'];

headA = ['[' num2str(head(1), '%0.9e')];
for i=2:size(head) headA = [headA ',' num2str(head(i), '%0.9e')]; end
headA = [headA ']'];

end