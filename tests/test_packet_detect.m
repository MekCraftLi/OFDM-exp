clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
addpath(fullfile(project_dir, 'rx'));
addpath(fullfile(project_dir, '..', 'week11'));
cd(project_dir);

rng(7);
params = ofdm_config();
[short_train, long_train, params] = gen_train(params);
tx_signal = [short_train; long_train];
[rx_signal, ~] = add_channel_effects(tx_signal, params, 30, 500, 0, 1);

[start_idx, metric] = packet_detect(rx_signal, params);
[ref_start_idx, ref_metric] = packetDetectShortTraining( ...
    rx_signal, params.threshold, params.search_win, ...
    params.packet_delay_len, params.packet_avg_len);

assert(isequal(start_idx, ref_start_idx));
assert(isequal(size(metric), size(ref_metric)));
assert(max(abs(metric - ref_metric)) < 1e-12);

disp('test_packet_detect passed');
