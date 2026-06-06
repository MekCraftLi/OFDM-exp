function [rx_signal, info] = add_channel_effects(tx_signal, params, snr_db, pre_noise_length, cfo_hz, h)
arguments
    tx_signal (:,1) double
    params (1,1) OfdmParams
    snr_db (1,1) double
    pre_noise_length (1,1) double {mustBeInteger, mustBeNonnegative} = 0
    cfo_hz (1,1) double = NaN
    h (:,1) double = zeros(0, 1)
end

if isempty(h)
    h = params.channel;
end
if isnan(cfo_hz)
    cfo_hz = params.cfo_hz;
end

channel_out = filter(h, 1, tx_signal);

signal_power = mean(abs(channel_out).^2);
noise_power = signal_power / 10^(snr_db/10);
noise = sqrt(noise_power/2) * (randn(size(channel_out)) + 1i*randn(size(channel_out)));
rx_signal = channel_out + noise;

n = (0:length(rx_signal)-1).';
rx_signal = rx_signal .* exp(1i * 2*pi*cfo_hz*n/params.sample_rate);

if pre_noise_length > 0
    pre_noise = sqrt(noise_power/2) * (randn(pre_noise_length, 1) + 1i*randn(pre_noise_length, 1));
    rx_signal = [pre_noise; rx_signal];
end

info.channel = h;
info.snr_db = snr_db;
info.cfo_hz = cfo_hz;
info.pre_noise_length = pre_noise_length;
end
