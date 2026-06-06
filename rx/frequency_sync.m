function [freq_est, corrected_signal] = frequency_sync(rx_signal, params)
arguments
    rx_signal (:,1) double
    params (1,1) OfdmParams
end

error('frequency_sync:NotImplemented', 'Implement frequency synchronization after packet detection.');
end
