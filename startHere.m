%% Initial set-up of project paths and such
projectRoot = set_up_HyperloopProject;

%% Initiate user specified workflow 
newRtStr    = 'Create a new route';
runSimStr   = 'Run a simulation from existing route';
runVisStr   = 'Run visualization from existing simultion';

workflow = questdlg( 'What would you like to do?','Desired workflow',...
    newRtStr,runSimStr,runVisStr,newRtStr);

switch workflow
    case newRtStr
        clear newRtStr runSimStr runVisStr workflow
        set_up_newRoute
    case runSimStr
        clear newRtStr runSimStr runVisStr workflow
        set_up_runSim
    case runVisStr
        clear newRtStr runSimStr runVisStr workflow
        main_sl2ge
end