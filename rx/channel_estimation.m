function [channel_est, info] = channel_estimation(rx_long_training, params)
arguments
    rx_long_training (:,1) double
    params (1,1) OfdmParams
end

error('channel_estimation:NotImplemented', 'Implement channel estimation after fine timing synchronization.');
end
