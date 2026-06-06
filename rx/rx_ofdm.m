function [rx_bits, rx_info] = rx_ofdm(rx_signal, params)
arguments
    rx_signal (:,1) double
    params (1,1) OfdmParams
end

if isempty(params.long_symbol) || isempty(params.long_freq)
    [~, ~, params] = gen_train(params);
end

[packet_start, packet_metric] = packet_detect(rx_signal, params);
if isempty(packet_start)
    error('rx_ofdm:PacketNotDetected', 'Packet detection did not find a packet.');
end

rx_from_packet = rx_signal(packet_start:end);
[freq_est, corrected_signal] = frequency_sync(rx_from_packet, params);
[fine_idx, time_metric] = fine_time_sync(corrected_signal, params.long_symbol, params);

long_block_start = fine_idx - params.long_cp_len;
if long_block_start < 1
    error('rx_ofdm:InvalidLongTrainingStart', 'Fine timing result is before the long training CP.');
end

long_train_len = params.long_cp_len + params.num_long_train_blks * params.fft_len;
long_block_end = long_block_start + long_train_len - 1;
if long_block_end > numel(corrected_signal)
    error('rx_ofdm:SignalTooShort', 'The received signal does not contain a complete long training field.');
end

rx_long_training = corrected_signal(long_block_start:long_block_end);
[channel_est, channel_info] = channel_estimation(rx_long_training, params);

data_start = long_block_end + 1;
data_signal = corrected_signal(data_start:end);
num_ofdm_symbols = floor(numel(data_signal) / params.block_len);
if num_ofdm_symbols < 1
    error('rx_ofdm:NoDataSymbols', 'The received signal does not contain OFDM data symbols.');
end

data_signal = data_signal(1:num_ofdm_symbols * params.block_len);
time_frames = reshape(data_signal, params.block_len, num_ofdm_symbols);
time_symbols = time_frames(params.cp_len + 1:end, :);

freq_grid = fft(time_symbols) / (params.fft_len / sqrt(numel(params.used_subc_idx)));
freq_reordered = freq_grid;
freq_reordered(params.reorder, :) = freq_grid;
used_symbols = freq_reordered(params.used_subc_idx, :);

freq_data = used_symbols(params.data_subc_patt, :);
freq_pilots = used_symbols(params.pilot_subc_patt, :);
eq_data = channel_equalization(freq_data, channel_est, params);
eq_pilots = equalize_pilots(freq_pilots, channel_est, params);
comp_data = phase_compensation(eq_data, eq_pilots, params);

data_seq = reshape(comp_data, numel(params.data_subc_patt) * num_ofdm_symbols, 1);
demod_seq = qamdemod(data_seq * params.norm_factor, params.mod_order);
coded_bits_mat = de2bi(demod_seq, params.mod_level);
coded_bits = reshape(coded_bits_mat, numel(coded_bits_mat), 1);

trellis = poly2trellis(7, [133 171]);
tb_depth = 7 * 5;
rx_bits = vitdec(coded_bits.', trellis, tb_depth, 'trunc', 'hard').';

rx_info = struct();
rx_info.packet_start = packet_start;
rx_info.packet_metric = packet_metric;
rx_info.freq_est = freq_est;
rx_info.fine_idx = fine_idx;
rx_info.time_metric = time_metric;
rx_info.channel_est = channel_est;
rx_info.channel_info = channel_info;
rx_info.num_ofdm_symbols = num_ofdm_symbols;
rx_info.used_symbols = used_symbols;
rx_info.equalized_data = comp_data;
end

function eq_pilots = equalize_pilots(freq_pilots, channel_est, params)
pilot_channel = channel_est(params.pilot_subc_patt);
channel_mat = repmat(pilot_channel, 1, size(freq_pilots, 2));
power_mat = repmat(abs(pilot_channel).^2 + eps, 1, size(freq_pilots, 2));
eq_pilots = freq_pilots .* conj(channel_mat) ./ power_mat;
end
