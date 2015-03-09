function updateSmoothFactor(source,~,h)

smoothFactor = 10^(-source.Value);
h.mapFigure.UserData.smoothFactor = smoothFactor;

recalcPlotData(h)

end