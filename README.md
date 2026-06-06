# OFDM-exp

OFDM课程实验。

## work3 OFDM Experiment

This folder is the new development workspace for the OFDM MATLAB experiment.

Development order follows `Simulations.pdf`:

1. Module simulations with `SNR-MSE`
2. Module integration with `SNR-MSE`
3. Complete OFDM system with `SNR-BER`

## Folder Layout

```text
work3/
  main_01_module_sims.m
  main_02_integration_sims.m
  main_03_complete_ofdm.m
  common/
  tx/
  rx/
  results/
```

## Rules

- Main scripts control experiments, SNR loops, plots, and saved results.
- Functions implement one algorithm each.
- Shared constants are stored in an `OfdmParams` object from `common/ofdm_config.m`.
- Do not use `global`.
- Do not save figures or data inside algorithm functions.
- Type names use UpperCamelCase, such as `OfdmParams`.
- Functions, variables, and parameter properties use snake_case.

## Run

```matlab
cd('D:/Program/ofdm-exp/work3')
main_01_module_sims
main_02_integration_sims
main_03_complete_ofdm
```
