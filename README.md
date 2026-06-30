# RISC-V RV32I Processor Design

A Verilog implementation of a RISC-V 32-bit integer (RV32I) processor built two ways, a single-cycle design and a 5-stage pipelined design, both simulated and verified in Xilinx Vivado.

**Single-cycle RV32I core**: fetch–decode–execute–mem–writeback complete each clock via combinational control_unit/alu_decoder, register_file, and data_memory; simple but clock period bounded by slowest instruction (loads).

**5-stage pipelined RV32I core**: PC→IF→ID→EX→MEM→WB via pp_stage_2-5 registers, with hazard_unit handling RAW hazards through EX/MEM and MEM/WB forwarding (ForwardAE/BE) and load-use stalls, plus branch/jump flush via bj_det.

---

## Project Overview

### Single-Cycle Design Architecture 

<img src="https://github.com/Rahi1908/RISC_V_Processor/raw/ff484e60ca3a84427d882ef8c2ba717bad158e94/Single_cycle_core/docs/top_level.png" width="800" alt="top_level_block_diagram">

Single-Cycle supports:

- R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
- I-type: ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU
- Load/Store: LW, SW
- Branch: BEQ only

RTL analysis

![image_alt](https://github.com/Rahi1908/RISC_V_Processor/blob/b55011220f9a8f507b2961219c79e0e049557ef9/Single_cycle_core/docs/RTL_analysis.png)

### Pipelined Design Architecture 

<img src="https://github.com/Rahi1908/RISC_V_Processor/raw/6cb5f2c270286093cc40f29c4edfe0e9272268a7/Pipelined_core/docs/architectture.jpeg" width="900" alt="pipelined_architecture">

Pipelined supports (everything above, plus):

- Load: LB, LH, LW (byte/half/word granularity via w/hw/b signals)
- Store: SB, SH, SW
- Branches: BEQ, BNE, BLT, BGE, BLTU, BGEU (via bj_det's funct3 cases)
- Jump: JAL
- MEM→EX and WB→EX forwarding (ForwardAE/ForwardBE)
- Load-use stall (hazard_unit, 1-cycle)
- Branch/jump flush (bj_det → flush signal, clears IF/ID)
- Pipeline registers at all 4 boundaries (pp_stage_2 through pp_stage_5)

RTL analysis

![image_alt](https://github.com/Rahi1908/RISC_V_Processor/blob/29afdfe835786a5f3fa28c503061e71a58d06c5d/Pipelined_core/docs/Schematic.png) 


---

## Testing

Assembly testing code 

<img src="https://github.com/Rahi1908/RISC_V_Processor/blob/600ffab937d8b7d4f480cfe114add1a457d46f43/Single_cycle_core/docs/assembly_code.png" width="500" alt="pipelined_architecture">

Final register state:

- s0 (x8) = 163
- sp (x2) = 128
- t0 (x5) = 7
- t1 (x6) = 10
- all other registers = 0

Single Cycle Processor Output

![image_alt](https://github.com/Rahi1908/RISC_V_Processor/blob/810a50441ff617e7c4f29a6bec719396335d47b1/Single_cycle_core/docs/result_1.png)

Pipelined Processor Output 

![image_alt](https://github.com/Rahi1908/RISC_V_Processor/blob/5ca225556ac437933e5d5c51ace7efad2ba81e80/Pipelined_core/docs/testbench_behav.wcfg%2030-06-2026%2009_37_22.png)


---
## Performance Analysis

### Single-Cycle Execution Time
- Each instruction takes exactly 1 cycle
- Total cycles: Cycles_single = N = 38
- Execution time: T_single = N × T_clk_single = 38 × 20 ns = 760 ns
- The clock period (20 ns) is constrained by the slowest instruction's critical path.

### Pipelined Execution Time
- For N instructions:
- Cycles_pipeline_actual = N + (k − 1) + S + F
- where: k = 5 (pipeline depth)
- S = stall cycles = 0 (forwarding resolves all data hazards, no stalls observed)
- F = flush/branch-penalty cycles = 16 (8 taken branches × 2 cycles penalty each)

- Cycles_pipeline_actual = 38 + 4 + 0 + 16 = 58
- T_pipeline = 58 × T_clk_pipeline = 58 × 10 ns = 580 ns

### 3.3 CPI Comparison

- Single-cycle CPI = 1.0
- Pipeline CPI = 58 / 38 = 1.526 (29/19)

### 3.4 Speedup
- Speedup = T_single / T_pipeline_actual = 760 / 580 = 1.3103× (38/29)

![image_alt]()

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
