function make_MG49Data(fpath)
% this script makes binary file of MG49 Neuroport data

load(fullfile(fpath, 'MG49_Seizure45.mat'), 'Neuroport');
dat = zscore(single(Neuroport.Data));
fidW     = fopen(fullfile(fpath, 'MG49_binary.dat'), 'w');
fwrite(fidW, dat', 'int16');
fclose(fidW); % all done
