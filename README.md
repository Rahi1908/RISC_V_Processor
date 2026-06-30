# RISC-V RV32I Processor Design

A Verilog implementation of a RISC-V 32-bit integer (RV32I) processor built two ways, a single-cycle design and a 5-stage pipelined design, both simulated and verified in Xilinx Vivado.

**Single-cycle RV32I core**: fetch–decode–execute–mem–writeback complete each clock via combinational control_unit/alu_decoder, register_file, and data_memory; simple but clock period bounded by slowest instruction (loads).

**5-stage pipelined RV32I core**: PC→IF→ID→EX→MEM→WB via pp_stage_2-5 registers, with hazard_unit handling RAW hazards through EX/MEM and MEM/WB forwarding (ForwardAE/BE) and load-use stalls, plus branch/jump flush via bj_det.

---

## Project Overview

### Single-Cycle Design Architecture 

<img src="https://github.com/Rahi1908/RISC_V_Processor/raw/ff484e60ca3a84427d882ef8c2ba717bad158e94/Single_cycle_core/docs/top_level.png" width="800" alt="top_level_block_diagram">


This diagram shows the classic single-cycle RV32I datapath: the PC feeds instruction memory, whose output splits into the opcode (driving the Control unit for Branch/MemRead/MemtoReg/ALUOp/MemWrite/ALUSrc/RegWrite), the register-file address fields (rs1/rs2/rd), and the immediate generator. ALUSrc selects between register data 2 and the sign-extended immediate as the second ALU operand; ALUOp plus funct fields go through the ALU control to pick the operation, and the Zero flag combined with Branch decides (via the AND gate and PC-target adder) whether PC+4 or the branch target is selected for the next PC. MemRead/MemWrite control data memory access, and MemtoReg chooses between ALU result and memory read data for the final register write-back, all happening combinationally within one clock cycle.

Single-Cycle supports:

- R-type: ADD, SUB, AND, OR, XOR, SLL, SRL, SRA, SLT, SLTU
- I-type: ADDI, ANDI, ORI, XORI, SLLI, SRLI, SRAI, SLTI, SLTIU
- Load/Store: LW, SW
- Branch: BEQ only


### Pipelined Design

<img src="https://github.com/Rahi1908/RISC_V_Processor/raw/6cb5f2c270286093cc40f29c4edfe0e9272268a7/Pipelined_core/docs/architectture.jpeg" width="900" alt="pipelined_architecture">

The pipelined RV32I datapath extends the PC through five stages: IF fetches the instruction (instruction_mem) and computes PC+4 (alu_four); pp_stage_2 latches these into ID, where controlpath generates control signals, reg_file reads operands, and extender_offsethandler builds the immediate; pp_stage_3 latches into EX, where mux_32_3in forwarding muxes (driven by hazard_unit's ForwardAE/ForwardBE) select between register data, MEM-stage result, and WB-stage result to resolve RAW hazards, after which the ALU executes and alu_pc/bj_det compute and evaluate the branch/jump target; pp_stage_4 latches into MEM, where data_mem performs the load/store; and pp_stage_5 latches into WB, where mux_32_3in selects between ALU result, memory data, and PC+4 for register write-back. The hazard_unit also detects load-use hazards and stalls the IF/ID boundary one cycle, while a taken branch/jump flushes the IF and ID stage registers via the bj signal.

Pipelined supports (everything above, plus):

- Load: LB, LH, LW (byte/half/word granularity via w/hw/b signals)
- Store: SB, SH, SW
- Branches: BEQ, BNE, BLT, BGE, BLTU, BGEU (via bj_det's funct3 cases)
- Jump: JAL
- MEM→EX and WB→EX forwarding (ForwardAE/ForwardBE)
- Load-use stall (hazard_unit, 1-cycle)
- Branch/jump flush (bj_det → flush signal, clears IF/ID)
- Pipeline registers at all 4 boundaries (pp_stage_2 through pp_stage_5)


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
