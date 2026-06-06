function [freq_est, corrected_signal] = frequency_sync(rx_signal, params)
arguments
    rx_signal (:,1) double
    params (1,1) OfdmParams
end

delay_len = params.packet_delay_len;
offset = params.pkt_det_offset;
short_len = params.num_short_train_blks * params.short_train_block_len;
corr_len = short_len - offset;

rx_signal = rx_signal(:);
last_base_idx = min(offset + corr_len - delay_len, numel(rx_signal) - delay_len);
if last_base_idx < offset
    error('frequency_sync:SignalTooShort', ...
        'The received signal is too short for CFO estimation.');
end

base_idx = (offset:last_base_idx).';
auto_corr = rx_signal(base_idx) .* conj(rx_signal(base_idx + delay_len));
mean_corr = sum(auto_corr);

freq_est = -angle(mean_corr) / (2 * pi * delay_len / params.sample_rate);

n = (0:numel(rx_signal)-1).';
corrected_signal = rx_signal .* exp(-1i * 2 * pi * freq_est * n / params.sample_rate);
end
