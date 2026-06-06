clear; clc;

addpath(fullfile(pwd, 'common'));
addpath(fullfile(pwd, 'rx'));

rng(1);

params = ofdm_config();
[short_train, long_train, params] = gen_train(params);

result_dir = fullfile(pwd, 'results', 'module');
if ~exist(result_dir, 'dir')
    mkdir(result_dir);
end

snr_db = params.snr_module_db;
num_packets = params.num_packets;
ideal_packet_start = 501;
pre_noise_len = ideal_packet_start - 1;
short_len = numel(short_train);
true_channel = true_channel_response(params);

packet_mse = zeros(size(snr_db));
frequency_mse = zeros(size(snr_db));
fine_time_mse = zeros(size(snr_db));
channel_mse = zeros(size(snr_db));

for snr_idx = 1:numel(snr_db)
    packet_err = zeros(num_packets, 1);
    frequency_err = zeros(num_packets, 1);
    fine_time_err = zeros(num_packets, 1);
    channel_err = zeros(num_packets, 1);

    for pkt_idx = 1:num_packets
        payload = exp(1i * pi / 2 * randi([0 3], 1000, 1));
        tx_signal = [short_train; long_train; payload];

        rx_packet = add_channel_effects(tx_signal, params, snr_db(snr_idx), pre_noise_len, 0, params.channel);
        start_idx = packet_detect(rx_packet, params);
        if isempty(start_idx)
            packet_err(pkt_idx) = params.search_win;
        else
            packet_err(pkt_idx) = start_idx - ideal_packet_start;
        end

        rx_freq = add_channel_effects(tx_signal, params, snr_db(snr_idx), 0, params.cfo_hz, params.channel);
        freq_est = frequency_sync(rx_freq, params);
        frequency_err(pkt_idx) = (freq_est - params.cfo_hz) / params.cfo_hz;

        rx_time = add_channel_effects(tx_signal, params, snr_db(snr_idx), 0, 0, params.channel);
        fine_idx = fine_time_sync(rx_time, params.long_symbol, params);
        ideal_fine_idx = short_len + params.long_cp_len + 1;
        fine_time_err(pkt_idx) = fine_idx - ideal_fine_idx;

        rx_long_training = add_channel_effects(long_train, params, snr_db(snr_idx), 0, 0, params.channel);
        channel_est = channel_estimation(rx_long_training, params);
        channel_err(pkt_idx) = mean(abs(channel_est - true_channel).^2) / mean(abs(true_channel).^2);
    end

    packet_mse(snr_idx) = mean(packet_err.^2);
    frequency_mse(snr_idx) = mean(abs(frequency_err).^2);
    fine_time_mse(snr_idx) = mean(fine_time_err.^2);
    channel_mse(snr_idx) = mean(channel_err);
end

results = struct();
results.snr_db = snr_db;
results.num_packets = num_packets;
results.packet_mse = packet_mse;
results.frequency_mse = frequency_mse;
results.fine_time_mse = fine_time_mse;
results.channel_mse = channel_mse;

save(fullfile(result_dir, 'module_snr_mse.mat'), 'results');
plot_mse(snr_db, packet_mse, 'Packet Detection SNR-MSE', 'MSE', fullfile(result_dir, 'packet_detection_snr_mse.png'));
plot_mse(snr_db, frequency_mse, 'Frequency Synchronization SNR-MSE', 'MSE', fullfile(result_dir, 'frequency_sync_snr_mse.png'));
plot_mse(snr_db, fine_time_mse, 'Fine Timing Synchronization SNR-MSE', 'MSE', fullfile(result_dir, 'fine_time_sync_snr_mse.png'));
plot_mse(snr_db, channel_mse, 'Channel Estimation SNR-MSE', 'MSE', fullfile(result_dir, 'channel_estimation_snr_mse.png'));

function channel = true_channel_response(params)
h_freq = fft(params.channel, params.fft_len);
h_reordered = h_freq;
h_reordered(params.reorder) = h_freq;
channel = h_reordered(params.used_subc_idx);
end

function plot_mse(snr_db, mse_value, title_text, y_label, output_path)
fig = figure('Visible', 'off', 'Color', 'w');
semilogy(snr_db, mse_value, 'o-', 'LineWidth', 1.2);
grid on;
xlabel('SNR/dB');
ylabel(y_label);
title(title_text);
saveas(fig, output_path);
close(fig);
end
