function [tx_signal, tx_info] = tx_ofdm(info_bits, params)
arguments
    info_bits (:,1) double
    params (1,1) OfdmParams
end

if isempty(params.preamble)
    [~, ~, params] = gen_train(params);
end

info_bits = double(info_bits(:) ~= 0);
trellis = poly2trellis(7, [133 171]);
info_bits_per_symbol = numel(params.data_subc_patt) * params.mod_level / 2;
padding_len = mod(-numel(info_bits), info_bits_per_symbol);
padded_bits = [info_bits; zeros(padding_len, 1)];

coded_bits = convenc(padded_bits.', trellis).';
qam_input = reshape(coded_bits, numel(coded_bits) / params.mod_level, params.mod_level);
data_symbols = qammod(bi2de(qam_input), params.mod_order) / params.norm_factor;

num_ofdm_symbols = numel(data_symbols) / numel(params.data_subc_patt);
used_symbols = zeros(numel(params.used_subc_idx), num_ofdm_symbols);
used_symbols(params.data_subc_patt, :) = reshape(data_symbols, numel(params.data_subc_patt), num_ofdm_symbols);
used_symbols(params.pilot_subc_patt, :) = 1;

freq_grid = zeros(params.fft_len, num_ofdm_symbols);
freq_grid(params.used_subc_idx, :) = used_symbols;
freq_mapped = freq_grid;
freq_mapped(params.reorder, :) = sqrt(params.fft_len / numel(params.used_subc_idx)) * freq_grid;

time_symbols = sqrt(params.fft_len) * ifft(freq_mapped);
time_frames = [time_symbols(params.fft_len - params.cp_len + 1:params.fft_len, :); time_symbols];
data_signal = reshape(time_frames, params.block_len * num_ofdm_symbols, 1);
tx_signal = [params.preamble; data_signal];

tx_info = struct();
tx_info.num_info_bits = numel(info_bits);
tx_info.padding_len = padding_len;
tx_info.num_ofdm_symbols = num_ofdm_symbols;
tx_info.coded_bits = coded_bits;
tx_info.used_symbols = used_symbols;
end
