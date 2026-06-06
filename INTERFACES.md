# work3 Interface Design

## Common Parameters

All modules receive an `OfdmParams` object created by:

```matlab
params = ofdm_config();
```

Important fields:

```matlab
params.fft_len
params.cp_len
params.block_len
params.sample_rate
params.cfo_hz
params.used_subc_idx
params.data_subc_idx
params.pilot_subc_idx
params.reorder
params.threshold
params.search_win
```

## Module Interfaces

Packet detection:

```matlab
[start_idx, metric] = packet_detect(rx_signal, params)
```

Frequency synchronization:

```matlab
[freq_est, corrected_signal] = frequency_sync(rx_signal, params)
```

Fine timing synchronization:

```matlab
[fine_idx, metric] = fine_time_sync(rx_signal, long_train_symbol, params)
```

Channel estimation:

```matlab
[channel_est, info] = channel_estimation(rx_long_training, params)
```

Channel equalization:

```matlab
eq_data = channel_equalization(freq_data, channel_est, params)
```

Phase compensation:

```matlab
comp_data = phase_compensation(eq_data, pilot_syms, params)
```

Complete transmitter:

```matlab
[tx_signal, tx_info] = tx_ofdm(info_bits, params)
```

Complete receiver:

```matlab
[rx_bits, rx_info] = rx_ofdm(rx_signal, params)
```

## Resource Management

- `params` owns constants and index definitions.
- Main scripts own SNR vectors, Monte Carlo loops, plots, and result paths.
- Algorithm functions do not create figures and do not write files.
- Received signals are column vectors.
- Frequency-domain OFDM data uses columns as OFDM symbols.

## Naming Rules

- Type names use UpperCamelCase: `OfdmParams`.
- Function names use snake_case: `packet_detect`.
- Local variables use snake_case: `search_win`.
- `OfdmParams` properties use snake_case: `packet_delay_len`.
- MATLAB built-in APIs keep their official names, for example `mustBeInteger`.
