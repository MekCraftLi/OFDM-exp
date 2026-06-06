clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
addpath(fullfile(project_dir, 'common'));
addpath(fullfile(project_dir, 'rx'));
cd(project_dir);

params = ofdm_config();
num_symbols = 4;
phase_err = pi / 5;
tx_data = reshape(1:48*num_symbols, 48, num_symbols) + 1i * reshape(2:48*num_symbols+1, 48, num_symbols);
eq_data = tx_data .* exp(1i * phase_err);
pilot_syms = ones(numel(params.pilot_subc_patt), num_symbols) .* exp(1i * phase_err);

comp_data = phase_compensation(eq_data, pilot_syms, params);

assert(max(abs(comp_data - tx_data), [], 'all') < 1e-12);

disp('test_phase_compensation passed');
