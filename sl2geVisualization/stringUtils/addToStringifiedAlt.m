function [altA] = addToStringifiedAlt(altA,altAOffset)

alt = str2num(altA(2:end-1));
alt = alt + altAOffset;

altA = ['[' num2str(alt(1), '%0.9e')];
for i=2:size(alt) altA = [altA ',' num2str(alt(i), '%0.9e')]; end
altA = [altA ']'];

end