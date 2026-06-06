clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
addpath(fullfile(project_dir, 'rx'));
addpath(fullfile(project_dir, '..', 'week11'));
cd(project_dir);

rng(11);
params = ofdm_config();
[short_train, long_train, params] = gen_train(params);
tx_signal = [short_train; long_train; exp(1i * pi / 2 * randi([0 3], 300, 1))];
[rx_signal, ~] = add_channel_effects(tx_signal, params, 25, 500, params.cfo_hz, 1);

[packet_start, ~] = packet_detect(rx_signal, params);
rx_from_packet = rx_signal(packet_start:end);

[freq_est, corrected_signal] = frequency_sync(rx_from_packet, params);
[ref_freq_est, ~] = estimateCFOShortTraining( ...
    rx_from_packet, params.sample_rate, params.pkt_det_offset, ...
    numel(short_train) - params.pkt_det_offset, params.packet_delay_len);
ref_corrected = compensateCFO(rx_from_packet, ref_freq_est, params.sample_rate);

assert(abs(freq_est - ref_freq_est) < 1e-12);
assert(max(abs(corrected_signal - ref_corrected)) < 1e-12);

disp('test_frequency_sync passed');
