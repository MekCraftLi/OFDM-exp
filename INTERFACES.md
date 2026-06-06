# work3 Interface Design

## Common Parameters

All modules receive a `params` structure created by:

```matlab
params = ofdm_config();
```

Important fields:

```matlab
params.fftLen
params.cpLen
params.blockLen
params.sampleRate
params.cfoHz
params.usedSubcIdx
params.dataSubcIdx
params.pilotSubcIdx
params.reorder
params.threshold
params.searchWin
```

## Module Interfaces

Packet detection:

```matlab
[startIdx, metric] = packet_detect(rxSignal, params)
```

Frequency synchronization:

```matlab
[freqEst, correctedSignal] = frequency_sync(rxSignal, params)
```

Fine timing synchronization:

```matlab
[fineIdx, metric] = fine_time_sync(rxSignal, longTrainSymbol, params)
```

Channel estimation:

```matlab
[channelEst, info] = channel_estimation(rxLongTraining, params)
```

Channel equalization:

```matlab
eqData = channel_equalization(freqData, channelEst, params)
```

Phase compensation:

```matlab
compData = phase_compensation(eqData, pilotSyms, params)
```

Complete transmitter:

```matlab
[txSignal, txInfo] = tx_ofdm(infoBits, params)
```

Complete receiver:

```matlab
[rxBits, rxInfo] = rx_ofdm(rxSignal, params)
```

## Resource Management

- `params` owns constants and index definitions.
- Main scripts own SNR vectors, Monte Carlo loops, plots, and result paths.
- Algorithm functions do not create figures and do not write files.
- Received signals are column vectors.
- Frequency-domain OFDM data uses columns as OFDM symbols.

