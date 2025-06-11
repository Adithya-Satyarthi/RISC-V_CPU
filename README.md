# RISC-V CPU in Verilog

This repository contains two Verilog implementations of a 32-bit RISC-V CPU, conforming to the RV32I base integer instruction set. Both a single-cycle and a pipelined version have been developed and verified using testbenches written in Cocotb, and simulations run using Icarus Verilog.

## Features

* Architectures:

  * Single-Cycle CPU
  * 5-Stage Pipelined CPU (IF, ID, EX, MEM, WB)

* Instruction Support:

  * All R-type instructions: `add`, `sub`, `sll`, `slt`, `sltu`, `xor`, `srl`, `sra`, `or`, `and`
  * Load/store: `lw`, `sw`
  * Branch: `beq`
  * Jump: `jal`
  * Immediate instructions:

    * `addi`, `ori`,`andi`,`xori`
    * `slli`, `slti`, `sltui`, `srai`, `srli`

* Word size: 32-bit

* Instruction memory and data memory modeled as arrays

* All modules written in synthesizable Verilog-2001

## Verification

* Testbenches written in Python using [Cocotb](https://github.com/cocotb/cocotb)
* Simulation and waveform generation using [Icarus Verilog](http://iverilog.icarus.com/)
* Automated tests include:

  * ALU functionality for R-type and I-type instructions
  * Correct execution of branches and jumps
  * Memory reads and writes
  * Basic pipeline hazard testing

 ## References

- *Computer Organization and Design – RISC-V Edition* by Patterson & Hennessy
- [RISC-V ISA Manual (Unprivileged)](https://riscv.org/technical/specifications/)

