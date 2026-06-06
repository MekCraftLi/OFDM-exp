clear; clc;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
cd(project_dir);

main_02_integration_sims;

test_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(test_dir);
result_path = fullfile(project_dir, 'results', 'integration', 'integration_snr_mse.mat');
assert(exist(result_path, 'file') == 2);

data = load(result_path);
assert(isfield(data, 'results'));
assert(isfield(data.results, 'snr_db'));
assert(isfield(data.results, 'packet_mse'));
assert(isfield(data.results, 'frequency_mse'));
assert(isfield(data.results, 'fine_time_mse'));
assert(isfield(data.results, 'channel_mse'));

num_snr = numel(data.results.snr_db);
assert(numel(data.results.packet_mse) == num_snr);
assert(numel(data.results.frequency_mse) == num_snr);
assert(numel(data.results.fine_time_mse) == num_snr);
assert(numel(data.results.channel_mse) == num_snr);

disp('test_main_02_integration_sims passed');
