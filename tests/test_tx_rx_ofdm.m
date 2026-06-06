clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
addpath(fullfile(project_dir, 'tx'));
addpath(fullfile(project_dir, 'rx'));
cd(project_dir);

rng(23);
params = ofdm_config();
[~, ~, params] = gen_train(params);

num_blocks = 4;
num_bits = 48 * params.mod_level * num_blocks / 2;
info_bits = randi([0 1], num_bits, 1);

[tx_signal, tx_info] = tx_ofdm(info_bits, params);
rx_signal = filter(params.channel, 1, tx_signal);
[rx_bits, rx_info] = rx_ofdm(rx_signal, params);

assert(isequal(rx_bits(1:num_bits), info_bits));
assert(tx_info.num_ofdm_symbols == num_blocks);
assert(rx_info.num_ofdm_symbols == num_blocks);

disp('test_tx_rx_ofdm passed');
