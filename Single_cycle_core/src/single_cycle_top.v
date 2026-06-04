`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.01.2026 20:15:41
// Design Name: 
// Module Name: single_cycle_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module single_cycle_top(
input clk,
input rst
    );
 wire [31:0] pc_o, PCPlus4, ImmExt, PCTarget, PCNext,
       inst, writeData, readData1, readData2, alu_in2,
       alu_result, mem_read_data;
 wire PCSrc, zero, regWrite, memWrite, memtoReg, memRead, ALUSrc;
 wire [3:0] aluControl;
    
 pc m_pc(
    .clk(clk),
    .rst(rst),
    .pc_i(PCNext),
    .pc_o(pc_o)
   );
   
 pc_adder m1_pc_adder (
     .a(pc_o),
     .b(32'd4),
     .c(PCPlus4)
 );
 
 pc_adder m2_pc_adder (
     .a(pc_o),
     .b(ImmExt),
     .c(PCTarget)
 );
 
 mux mux_pc (
     .sel(PCSrc),
     .s0(PCPlus4),
     .s1(PCTarget),
     .out(PCNext)
 );
 
 instruction_memory m_inst_mem (
      .readAddr(pc_o),
      .inst(inst) 
 );

 control_unit m_control(
     .opcode(inst[6:0]),
     .funct7(inst[31:25]),
     .funct3(inst[14:12]),
     .zero(zero),
     .regWrite(regWrite),
     .memWrite(memWrite),
     .memtoReg (memtoReg),
     .memRead(memRead),
     .ALUSrc(ALUSrc),
     .PCSrc(PCSrc),
     .aluControl(aluControl)
 );
 
 register_file m_register (
      .clk(clk),
      .rst(rst),
      .regWrite(regWrite),
      .readReg1(inst[19:15]),
      .readReg2(inst[24:20]),
      .writeReg(inst[11:7]),
      .writeData(writeData),
      .readData1(readData1),
      .readData2(readData2)
 );
 
  ImmGen m_imm(
      .inst(inst),
      .imm(ImmExt)
  );
  
  
  mux mux_alu (
      .sel(ALUSrc),
      .s0(readData2),
      .s1(ImmExt),
      .out(alu_in2)
  );
  
  alu m_alu (
      .RD_1(readData1),
      .RD_2(alu_in2),
      .alu_control(aluControl),
      .result(alu_result),
      .zero(zero),
      .l_t_u(),
      .g_t_u(),
      .n_e(),
      .l_t_s(),
      .g_t_s(),
      .V(),
      .C()
  );
  
  data_memory m_datamem (
      .rst(rst),
      .clk(clk),
      .memWrite(memWrite),
      .memRead(memRead),
      .address(alu_result),
      .writeData(readData2),
      .readData(mem_read_data)
  );
   
   mux mux_result (
       .sel(memtoReg),
       .s0(alu_result),
       .s1(mem_read_data),
       .out(writeData)
   );
   
    
endmodule
