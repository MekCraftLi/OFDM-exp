function [short_train, long_train, params] = gen_train(params)
arguments
    params (1,1) OfdmParams = OfdmParams()
end

short_freq = sqrt(13/6) * [ ...
    0 0 1+1i 0 0 0 -1-1i 0 0 0 1+1i 0 0 0 -1-1i 0 0 0 -1-1i 0 ...
    0 0 1+1i 0 0 0 0 0 0 -1-1i 0 0 0 -1-1i 0 0 0 1+1i 0 0 0 ...
    1+1i 0 0 0 1+1i 0 0 0 1+1i 0 0].';

long_freq = [ ...
    1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 1 1 -1 -1 1 1 -1 1 -1 1 1 1 1 ...
    1 -1 -1 1 1 -1 1 -1 1 -1 -1 -1 -1 -1 1 1 -1 -1 1 -1 1 -1 1 1 1 1].';

short_input = zeros(params.fft_len, 1);
short_input(params.used_subc_idx) = short_freq;
short_mapped = short_input;
short_mapped(params.reorder) = sqrt(params.fft_len/numel(params.used_subc_idx)) * short_input;
short_time = sqrt(params.fft_len) * ifft(short_mapped);
short_block = short_time(1:params.short_train_block_len);
short_train = repmat(short_block, params.num_short_train_blks, 1);

long_input = zeros(params.fft_len, 1);
long_input(params.used_subc_idx) = long_freq;
long_mapped = long_input;
long_mapped(params.reorder) = sqrt(params.fft_len/numel(params.used_subc_idx)) * long_input;
long_time = sqrt(params.fft_len) * ifft(long_mapped);
long_train = [long_time(params.fft_len - params.long_cp_len + 1:params.fft_len); long_time; long_time];

params.short_freq = short_freq;
params.long_freq = long_freq;
params.short_symbol = short_time;
params.short_block = short_block;
params.long_symbol = long_time;
params.preamble = [short_train; long_train];
end
