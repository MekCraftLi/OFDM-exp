clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
addpath(fullfile(project_dir, 'rx'));
addpath(fullfile(project_dir, '..', 'week11'));
cd(project_dir);

rng(17);
params = ofdm_config();
[~, long_train, params] = gen_train(params);

rx_long_training = filter(params.channel, 1, long_train);
[channel_est, info] = channel_estimation(rx_long_training, params);
[ref_channel_est, ref_info] = estimateChannelLongTraining( ...
    rx_long_training, params.long_freq, params.used_subc_idx, params.reorder);

assert(isequal(size(channel_est), size(ref_channel_est)));
assert(max(abs(channel_est - ref_channel_est)) < 1e-12);
assert(isstruct(info));
assert(isfield(info, 'freq_used'));
assert(isfield(info, 'mean_long'));
assert(isfield(info, 'true_long_freq'));

disp('test_channel_estimation passed');
