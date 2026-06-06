clear; clc;

addpath(fullfile(pwd, 'common'));
addpath(fullfile(pwd, 'rx'));

rng(1);

params = ofdm_config();
[short_train, long_train, params] = gen_train(params);

result_dir = fullfile(pwd, 'results', 'module');
