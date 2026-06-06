function eq_data = channel_equalization(freq_data, channel_est, params)
arguments
    freq_data double
    channel_est (:,1) double
    params (1,1) OfdmParams
end

data_channel = channel_est(params.data_subc_patt);
channel_mat = repmat(data_channel, 1, size(freq_data, 2));
power_mat = repmat(abs(data_channel).^2 + eps, 1, size(freq_data, 2));

eq_data = freq_data .* conj(channel_mat) ./ power_mat;
end
