function [rxSignal, info] = add_channel_effects(txSignal, params, snrDb, preNoiseLength, cfoHz, h)
if nargin < 6 || isempty(h)
    h = params.channel;
end
if nargin < 5 || isempty(cfoHz)
    cfoHz = params.cfoHz;
end
if nargin < 4 || isempty(preNoiseLength)
    preNoiseLength = 0;
end

channelOut = filter(h, 1, txSignal);

signalPower = mean(abs(channelOut).^2);
noisePower = signalPower / 10^(snrDb/10);
noise = sqrt(noisePower/2) * (randn(size(channelOut)) + 1i*randn(size(channelOut)));
rxSignal = channelOut + noise;

n = (0:length(rxSignal)-1).';
rxSignal = rxSignal .* exp(1i * 2*pi*cfoHz*n/params.sampleRate);

if preNoiseLength > 0
    preNoise = sqrt(noisePower/2) * (randn(preNoiseLength, 1) + 1i*randn(preNoiseLength, 1));
    rxSignal = [preNoise; rxSignal];
end

info.channel = h;
info.snrDb = snrDb;
info.cfoHz = cfoHz;
info.preNoiseLength = preNoiseLength;
end

