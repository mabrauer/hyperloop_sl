newRtStr    = 'Create a new route';
runSimStr   = 'Run a simulation from existing route';
runVisStr   = 'Run visualization from existing simultion';

workflow = questdlg( 'What would you like to do?','Desired workflow',...
    newRtStr,runSimStr,runVisStr,newRtStr);

switch workflow
    case newRtStr
        error('I haven''t written this function yet!')
    case runSimStr
        set_up_Hyperloop
        set_up_loadModel
    case runVisStr
        cd sl2geVisualization
        main_sl2ge
end
