clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
cd(project_dir);

main_03_complete_ofdm;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
result_path = fullfile(project_dir, 'results', 'complete', 'complete_snr_ber.mat');
assert(exist(result_path, 'file') == 2);

data = load(result_path);
assert(isfield(data, 'results'));
assert(isfield(data.results, 'snr_db'));
assert(isfield(data.results, 'ber'));
assert(isfield(data.results, 'per'));

num_snr = numel(data.results.snr_db);
assert(numel(data.results.ber) == num_snr);
assert(numel(data.results.per) == num_snr);

disp('test_main_03_complete_ofdm passed');
