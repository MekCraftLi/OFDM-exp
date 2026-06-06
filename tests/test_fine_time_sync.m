clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
addpath(fullfile(project_dir, 'rx'));
addpath(fullfile(project_dir, '..', 'week11'));
cd(project_dir);

rng(13);
params = ofdm_config();
[short_train, long_train, params] = gen_train(params);
payload = exp(1i * pi / 2 * randi([0 3], 300, 1));
tx_signal = [short_train; long_train; payload];
[rx_signal, ~] = add_channel_effects(tx_signal, params, 20, 500, params.cfo_hz, 1);

[packet_start, ~] = packet_detect(rx_signal, params);
rx_from_packet = rx_signal(packet_start:end);
[~, corrected_signal] = frequency_sync(rx_from_packet, params);

[fine_idx, metric] = fine_time_sync(corrected_signal, params.long_symbol, params);
[ref_fine_idx, ref_metric] = fineTimingLongTraining( ...
    corrected_signal, params.long_symbol, params.fine_search_start, params.fine_search_end);

assert(isequal(fine_idx, ref_fine_idx));
assert(isequal(size(metric), size(ref_metric)));
assert(max(abs(metric - ref_metric)) < 1e-12);

disp('test_fine_time_sync passed');
