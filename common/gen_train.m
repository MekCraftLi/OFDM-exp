function [shortTrain, longTrain, params] = gen_train(params)
if nargin < 1
    params = ofdm_config();
end

shortFreq = sqrt(13/6) * [ ...
    0 0 1+1i 0 0 0 -1-1i 0 0 0 1+1i 0 0 0 -1-1i 0 0 0 -1-1i 0 ...
    0 0 1+1i 0 0 0 0 0 0 -1-1i 0 0 0 -1-1i 0 0 0 1+1i 0 0 0 ...
    1+1i 0 0 0 1+1i 0 0 0 1+1i 0 0].';

longFreq = [ ...
    1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 ...
    1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1].';

shortInput = zeros(params.fftLen, 1);
shortInput(params.usedSubcIdx) = shortFreq;
shortMapped = shortInput;
shortMapped(params.reorder) = sqrt(params.fftLen/numel(params.usedSubcIdx)) * shortInput;
shortTime = sqrt(params.fftLen) * ifft(shortMapped);
shortBlock = shortTime(1:params.shortTrainBlockLen);
shortTrain = repmat(shortBlock, params.numShortTrainBlks, 1);

longInput = zeros(params.fftLen, 1);
longInput(params.usedSubcIdx) = longFreq;
longMapped = longInput;
longMapped(params.reorder) = sqrt(params.fftLen/numel(params.usedSubcIdx)) * longInput;
longTime = sqrt(params.fftLen) * ifft(longMapped);
longTrain = [longTime(params.fftLen - params.longCpLen + 1:params.fftLen); longTime; longTime];

params.shortFreq = shortFreq;
params.longFreq = longFreq;
params.shortSymbol = shortTime;
params.shortBlock = shortBlock;
params.longSymbol = longTime;
params.preamble = [shortTrain; longTrain];
end

