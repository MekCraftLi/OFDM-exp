clear; clc;

addpath(fullfile(pwd, 'common'));
addpath(fullfile(pwd, 'tx'));
addpath(fullfile(pwd, 'rx'));

rng(1);

params = ofdm_config();
[~, ~, params] = gen_train(params);

result_dir = fullfile(pwd, 'results', 'complete');
if ~exist(result_dir, 'dir')
    mkdir(result_dir);
end

snr_db = params.snr_complete_db;
num_packets = params.num_packets;
num_ofdm_symbols = 10;
num_info_bits = numel(params.data_subc_patt) * params.mod_level * num_ofdm_symbols / 2;
pre_noise_len = 500;

ber = zeros(size(snr_db));
per = zeros(size(snr_db));

for snr_idx = 1:numel(snr_db)
    num_err = 0;
    packet_err = zeros(num_packets, 1);

    for pkt_idx = 1:num_packets
        info_bits = randi([0 1], num_info_bits, 1);
        tx_signal = tx_ofdm(info_bits, params);
        rx_signal = add_channel_effects(tx_signal, params, snr_db(snr_idx), ...
            pre_noise_len, params.cfo_hz, params.channel);

        try
            rx_bits = rx_ofdm(rx_signal, params);
            rx_bits = rx_bits(1:num_info_bits);
            packet_err(pkt_idx) = sum(abs(rx_bits - info_bits));
        catch
            packet_err(pkt_idx) = num_info_bits;
        end

        num_err = num_err + packet_err(pkt_idx);
    end

    ber(snr_idx) = num_err / (num_packets * num_info_bits);
    per(snr_idx) = sum(packet_err ~= 0) / num_packets;
end

results = struct();
results.snr_db = snr_db;
results.num_packets = num_packets;
results.num_info_bits = num_info_bits;
results.ber = ber;
results.per = per;

save(fullfile(result_dir, 'complete_snr_ber.mat'), 'results');
plot_ber(snr_db, ber, per, fullfile(result_dir, 'complete_snr_ber.png'));

function plot_ber(snr_db, ber, per, output_path)
fig = figure('Visible', 'off', 'Color', 'w');
semilogy(snr_db, ber, 'o-', 'LineWidth', 1.2);
hold on;
semilogy(snr_db, per, 's-', 'LineWidth', 1.2);
hold off;
grid on;
xlabel('SNR/dB');
ylabel('BER and PER');
title('Complete OFDM SNR-BER');
legend('BER', 'PER', 'Location', 'best');
saveas(fig, output_path);
close(fig);
end
