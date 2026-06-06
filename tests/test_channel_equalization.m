clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
addpath(fullfile(project_dir, 'rx'));
cd(project_dir);

params = ofdm_config();
num_symbols = 3;
tx_data = reshape(1:48*num_symbols, 48, num_symbols) + 1i * reshape(2:48*num_symbols+1, 48, num_symbols);
channel_est = (1:52).' + 1i * (53:104).';
data_channel = channel_est(params.data_subc_patt);
freq_data = tx_data .* repmat(data_channel, 1, num_symbols);

eq_data = channel_equalization(freq_data, channel_est, params);

assert(max(abs(eq_data - tx_data), [], 'all') < 1e-12);

disp('test_channel_equalization passed');
