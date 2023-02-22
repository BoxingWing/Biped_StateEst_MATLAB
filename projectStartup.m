% change the folder that stores the generated code
cacheFolder=fullfile(pwd,'Cache');
if ~exist(cacheFolder,'dir')
    mkdir(cacheFolder);
end
buildFolder=fullfile(pwd,'Build');
if ~exist(buildFolder,'dir')
    mkdir(buildFolder);
end
% Get the current configuration
cfg = Simulink.fileGenControl('getConfig');

% Change the parameters to non-default locations
% for the cache and code generation folders
cfg.CacheFolder = cacheFolder;
cfg.CodeGenFolder = buildFolder;
%cfg.CodeGenFolderStructure = 'TargetEnvironmentSubfolder';

Simulink.fileGenControl('setConfig', 'config', cfg);

clear cfg cacheFolder buildFolder;