function [channel_est, info] = channel_estimation(rx_long_training, params)
arguments
    rx_long_training (:,1) double
    params (1,1) OfdmParams
end

fft_len = params.fft_len;
long_cp_len = params.long_cp_len;
used_subc_idx = params.used_subc_idx;
reorder = params.reorder;
long_freq = params.long_freq;

rx_long_training = rx_long_training(:);
if numel(rx_long_training) >= long_cp_len + 2 * fft_len
    long_no_cp = rx_long_training(long_cp_len + 1:long_cp_len + 2 * fft_len);
elseif numel(rx_long_training) >= 2 * fft_len
    long_no_cp = rx_long_training(1:2 * fft_len);
else
    error('channel_estimation:SignalTooShort', ...
        'At least two long training symbols are required.');
end

long_syms = reshape(long_no_cp, fft_len, 2);
freq_long = fft(long_syms) / (fft_len / sqrt(numel(used_subc_idx)));
freq_reordered = freq_long;
freq_reordered(reorder, :) = freq_long;
freq_used = freq_reordered(used_subc_idx, :);

mean_long = mean(freq_used, 2);
channel_est = mean_long .* conj(long_freq);

info = struct();
info.freq_used = freq_used;
info.mean_long = mean_long;
info.true_long_freq = long_freq;
info.fft_len = fft_len;
info.long_cp_len = long_cp_len;
end
