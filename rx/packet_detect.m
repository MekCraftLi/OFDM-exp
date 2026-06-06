function [start_idx, metric] = packet_detect(rx_signal, params)
arguments
    rx_signal (:,1) double
    params (1,1) OfdmParams
end

delay_len = params.packet_delay_len;
search_win = params.search_win;
avg_len = params.packet_avg_len;
threshold = params.threshold;

rx_signal = rx_signal(:);
max_metric_len = min(search_win + avg_len, numel(rx_signal) - delay_len);
if max_metric_len <= avg_len
    error('packet_detect:SignalTooShort', 'The received signal is too short for packet detection.');
end

base_idx = (1:max_metric_len).';
delayed_idx = base_idx + delay_len;
delay_xcorr = rx_signal(base_idx) .* conj(rx_signal(delayed_idx));
delay_power = abs(rx_signal(delayed_idx)).^2;

smooth_kernel = ones(avg_len, 1);
ma_delay_xcorr = abs(filter(smooth_kernel, 1, delay_xcorr));
ma_rx_power = filter(smooth_kernel, 1, delay_power);
ma_rx_power(ma_rx_power < eps) = eps;

raw_metric = ma_delay_xcorr ./ ma_rx_power;
metric = raw_metric(avg_len + 1:end);
metric = metric(1:min(search_win, numel(metric)));

hit_idx = find(metric > threshold, 1, 'first');
if isempty(hit_idx)
    start_idx = [];
else
    start_idx = hit_idx;
end
end
