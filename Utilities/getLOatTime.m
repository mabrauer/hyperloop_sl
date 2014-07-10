function value = getLOatTime(logsout, signalName, time)
index = find(logsout.getElement(signalName).Values.Time>time,1);
value = logsout.getElement(signalName).Values.Data(index);
end

