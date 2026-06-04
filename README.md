# RISC-V 5-Stage Pipelined Core (Derived from Single-Cycle)

A Verilog implementation of a RISC-V 32-bit integer (RV32I) processor built two ways — a single-cycle design and a 5-stage pipelined design — both simulated and verified in Xilinx Vivado.

---

## Project Overview

### Single-Cycle Design
A clean, reference implementation where every instruction completes in a single clock cycle across all stages — Fetch, Decode, Execute, Memory, and Writeback. Simple control logic with a two-level decoder (main decoder + ALU decoder). Supports **R-type, I-type (arithmetic), Load (`LW` only), Store (`SW` only), and Branch (`BEQ` only)** — totalling **~20 instructions**.

### Pipelined Design
A full 5-stage pipelined core derived from the single-cycle design. Each stage operates concurrently on different instructions, improving throughput. Extends the single-cycle support with complete load/store granularity (`LB`, `LH`, `LW`, `SB`, `SH`, `SW`), all 6 branch types (`BEQ`, `BNE`, `BLT`, `BGE`, `BLTU`, `BGEU`), and `JAL` for jumps — totalling **~37 instructions**. A dedicated hazard unit handles all data and control hazards.

---

## Features

### Single-Cycle
- ✅ R-type: `ADD` `SUB` `AND` `OR` `XOR` `SLL` `SRL` `SRA` `SLT` `SLTU`
- ✅ I-type: `ADDI` `ANDI` `ORI` `XORI` `SLLI` `SRLI` `SRAI` `SLTI` `SLTIU`
- ✅ Load / Store: `LW`, `SW`
- ✅ Branch: `BEQ` only
- ✅ Two-level control unit (main decoder + ALU decoder)
- ✅ Immediate generation via dedicated ImmGen module

### Pipelined
- ✅ All single-cycle instructions, plus:
- ✅ Load: `LB` `LH` `LW` (with byte/halfword/word granularity)
- ✅ Store: `SB` `SH` `SW`
- ✅ Branches: `BEQ` `BNE` `BLT` `BGE` `BLTU` `BGEU`
- ✅ Jump: `JAL`
- ✅ MEM→EX and WB→EX data forwarding
- ✅ Load-use hazard detection with 1-cycle stall
- ✅ Branch/jump flush at EX stage (flush IF/ID on taken)
- ✅ Pipeline registers for all 4 stage boundaries (IF/ID, ID/EX, EX/MEM, MEM/WB)

---

## Testing

### Unit Testing
Each module (ALU, register file, control path, data memory, hazard unit, etc.) was individually instantiated and tested with targeted inputs to verify correct output before integration.

### Integration Testing
The full top-level design was simulated with a custom hex program loaded via `$readmemh`. Waveforms were inspected in Vivado to confirm correct instruction execution, register writeback, memory access, and hazard resolution across multiple instruction sequences.

### Performance Evaluation
The pipelined design was compared against the single-cycle baseline:
- Single-cycle executes one instruction per multiple-gate-delay cycle
- Pipeline achieves near 1 IPC with stall penalties only on load-use and taken branches
- Forwarding eliminates most data hazard stalls without extra cycles

---

## Future Enhancements

- [ ] Add full RV32M extension (multiply/divide)
- [ ] Implement a proper branch predictor to reduce flush penalty
- [ ] FPGA deployment with UART-based program loader (replacing `$readmemh`)
- [ ] Add CSR registers and exception handling
- [ ] Extend to RV64I

---

## RTL Analysis

RTL schematics were generated in Xilinx Vivado using **RTL Analysis → Open Elaborated Design**. The schematic confirms correct module hierarchy, datapath connections, and pipeline register placement across all 5 stages.

> ⚠️ Testbench files should be excluded when running elaboration in Vivado.

---

## Tools
- **Simulator / RTL:** Xilinx Vivado
- **Language:** Verilog
