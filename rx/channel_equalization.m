function eq_data = channel_equalization(freq_data, channel_est, params)
arguments
    freq_data double
    channel_est (:,1) double
    params (1,1) OfdmParams
end

error('channel_equalization:NotImplemented', 'Implement channel equalization after channel estimation.');
end
