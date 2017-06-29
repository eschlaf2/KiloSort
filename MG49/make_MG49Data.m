function make_MG49Data(fpath, ops)
% this script makes binary file of MG49 Neuroport data. Enter
% sample_interval as [s_start, s_end]

s_start = ops.s_start;
s_end = ops.s_end;

load(fullfile(fpath, 'MG49_Seizure45.mat'), 'Neuroport');
dat = Neuroport.Data(...
    s_start:min(s_end, length(Neuroport.Data)),:);

outfile = ops.fbinary;
fidW = fopen(outfile, 'w');
fwrite(fidW, dat', 'int16');
fclose(fidW); % all done
