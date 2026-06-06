clear; clc;

addpath(fullfile(pwd, 'common'));
addpath(fullfile(pwd, 'rx'));

rng(1);

params = ofdm_config();
[shortTrain, longTrain, params] = gen_train(params);

resultDir = fullfile(pwd, 'results', 'integration');

