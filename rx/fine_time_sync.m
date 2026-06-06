function [fine_idx, metric] = fine_time_sync(rx_signal, long_train_symbol, params)
arguments
    rx_signal (:,1) double
    long_train_symbol (:,1) double
    params (1,1) OfdmParams
end

rx_signal = rx_signal(:);
long_train_symbol = long_train_symbol(:);

search_start = max(1, round(params.fine_search_start));
search_end = min(round(params.fine_search_end), numel(rx_signal) - numel(long_train_symbol) + 1);
if search_end < search_start
    error('fine_time_sync:InvalidSearchRange', ...
        'The timing search range is invalid for the received signal length.');
end

metric = zeros(search_end - search_start + 1, 1);
for idx = search_start:search_end
    metric(idx - search_start + 1) = sum(rx_signal(idx:idx + numel(long_train_symbol) - 1) .* conj(long_train_symbol));
end

[~, peak_offset] = max(abs(metric));
fine_idx = search_start + peak_offset - 1;
end
