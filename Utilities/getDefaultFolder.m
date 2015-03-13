function [fullPathToFolder] = getDefaultFolder(targetFolder)
% provide full path to a target folder that should be under the project
% root if it can be found. Otherwise, return an empty array

if not(ischar(targetFolder))
    error('input must be a string')
end

try 
    projectRoot = evalin('base','projectRoot');
    fullPathToFolder = strcat(projectRoot,'\',targetFolder);
catch 
    [~, currentFolder] = fileparts(pwd);
    if strcmp(currentFolder,targetFolder)
        % we're in the target folder
        fullPathToFolder = pwd;
    else
        fullPathToFolder = [];
        return
    end       
end

% in all cases, except returning null, check that it is a valid folder
if not(isdir(fullPathToFolder))
    error('Returned path is not a directory')
end

    
    
        
