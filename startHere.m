%% Initial set-up of project paths and such
[projectRoot, hadToOpen] = set_up_HyperloopProject;

%% Initiate user specified workflow
if not(hadToOpen)   % only initiate workflows if project was already open
    newRtStr    = 'Create a new route';
    runSimStr   = 'Run a simulation from existing route';
    runVisStr   = 'Run visualization from existing simultion';
    
    workflow = questdlg( 'What would you like to do?','Desired workflow',...
        newRtStr,runSimStr,runVisStr,newRtStr);
    
    switch workflow
        case newRtStr
            clear newRtStr runSimStr runVisStr workflow hadToOpen
            set_up_newRoute
        case runSimStr
            clear newRtStr runSimStr runVisStr workflow hadToOpen
            set_up_runSim
        case runVisStr
            clear newRtStr runSimStr runVisStr workflow hadToOpen
            main_sl2ge
        case ''
            clear newRtStr runSimStr runVisStr workflow hadToOpen
            disp('User did not select a workflow')
    end
    
% projectRoot should be the only variable retained at end    
end