clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
cd(project_dir);

params = ofdm_config();

assert(isa(params, 'OfdmParams'));
assert(params.fft_len == 64);
assert(params.cp_len == 16);
assert(params.block_len == 80);
assert(params.packet_delay_len == 16);
assert(params.packet_avg_len == 32);
assert(params.search_win == 700);
assert(params.cfo_hz == 0.2 * params.sample_rate / params.fft_len);
assert(numel(params.used_subc_idx) == 52);

disp('test_naming_and_params passed');
