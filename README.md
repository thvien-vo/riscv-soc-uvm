# riscv-soc-uvm

A RISC-V SoC built from scratch, with a full UVM verification environment.

## Planned architecture
- RV32I 5-stage pipelined core
- AXI4 interconnect, AXI SRAM, DMA controller
- APB peripherals: UART, Timer, GPIO
- UVM testbenches with functional coverage and assertions

## Status
Work in progress. Currently: writing the first module.

## Tools
Icarus Verilog, Verilator, GTKWave, RISC-V GNU toolchain, Spike, Vivado XSim (UVM)
