useGPU = 1; % do you have a GPU? Kilosorting 1000sec of 32chan simulated data takes 55 seconds on gtx 1080 + M2 SSD.

fpath = '/project/ecog/emily/DATA/KiloSort/MG49';
% fpath    = 'F:\DATA\Spikes\eMouse\'; % where on disk do you want the
% simulation? ideally and SSD...
if ~exist(fpath, 'dir'); mkdir(fpath); end

% This part adds paths
addpath(genpath('/project/ecog/emily/KiloSort')) % path to kilosort folder
% addpath(genpath('D:\CODE\GitHub\npy-matlab')) % path to npy-matlab
% scripts
pathToYourConfigFile = '/project/ecog/emily/KiloSort/MG49'; % for this example it's ok to leave this path inside the repo, but for your own config file you *must* put it somewhere else!  

% Run the configuration file, it builds the structure of options (ops)
run(fullfile(pathToYourConfigFile, 'config_MG49.m'))

% This part makes the channel map for this simulation
createChannelMap_MG49; 

% Create a zscored binary file of the data
make_MG49Data(fpath, ops);

%
% This part runs the normal Kilosort processing on the simulated data
[rez, DATA, uproj] = preprocessData(ops); % preprocess data and extract spikes for initialization
rez                = fitTemplates(rez, DATA, uproj);  % fit templates iteratively
rez                = fullMPMU(rez, DATA);% extract final spike times (overlapping extraction)

% % save python results file for Phy
% rezToPhy(rez, fpath);

fprintf('Kilosort took %2.2f seconds \n', toc)

% now fire up Phy and check these results. There should still be manual
% work to be done (mostly merges, some refinements of contaminated
% clusters).
%% AUTO MERGES 
% after spending quite some time with Phy checking on the results and
% understanding the merge and split functions, come back here and run
% Kilosort's automated merging strategy. This block will overwrite the
% previous results and python files. Load the results in Phy again: there
% should be no merges left to do (with the default simulation), but perhaps
% a few splits / cleanup. On realistic data (i.e. not this simulation)
% there will be drift also, which will usually mean there are merges left
% to do even after this step. Kilosort's AUTO merges should not be confused
% with the "best" merges done inside the benchmark (those are using the
% real ground truth!!!)

rez = merge_posthoc2(rez);

% save python results file for Phy
% rezToPhy(rez, fpath);

%% save and clean up
% save matlab results file for future use (although you should really only
% be using the manually validated spike_clusters.npy file)
save(fullfile(fpath,  'rez.mat'), 'rez', '-v7.3');

% remove temporary file
delete(ops.fproc);
%%
