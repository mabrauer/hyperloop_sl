%% Initial set-up of project paths and such
[projectRoot, hadToOpen] = set_up_HyperloopProject;

%% Initiate user specified workflow
if not(hadToOpen)   % only initiate workflows if project was already open
    setupRtStr  = 'Set up a route';
    runSimStr   = 'Run a simulation from existing route';
    runVisStr   = 'Run visualization from existing simultion';
    
    workflow = questdlg( 'What would you like to do?','Desired workflow',...
        setupRtStr,runSimStr,runVisStr,setupRtStr);
    
    switch workflow
        case setupRtStr
            clear setupRtStr runSimStr runVisStr workflow hadToOpen
            newRtStr    = 'Import a new route';
            modifyRtStr = 'Modify an existing route';
            routeWorkflow = ...
                questdlg('What would you like to do with the route?',...
                'Route',newRtStr,modifyRtStr,newRtStr);
            switch routeWorkflow
                case newRtStr
                    clear routeWorkflow newRtStr modifyRtStr
                    set_up_newRoute
                case modifyRtStr
                    clear routeWorkflow newRtStr modifyRtStr
                    modifyRoute
                case ''
                    clear routeWorkflow newRtStr modifyRtStr
                    disp('User did not select a workflow')
            end
        case runSimStr
            clear setupRtStr runSimStr runVisStr workflow hadToOpen
            set_up_runSim
        case runVisStr
            clear setupRtStr runSimStr runVisStr workflow hadToOpen
            main_sl2ge
        case ''
            clear newRtStr runSimStr runVisStr workflow hadToOpen
            disp('User did not select a workflow')
    end
    
    % projectRoot should be the only variable retained at end
end