function [fine_idx, metric] = fine_time_sync(rx_signal, long_train_symbol, params)
arguments
    rx_signal (:,1) double
    long_train_symbol (:,1) double
    params (1,1) OfdmParams
end

error('fine_time_sync:NotImplemented', 'Implement fine timing synchronization after frequency synchronization.');
end
