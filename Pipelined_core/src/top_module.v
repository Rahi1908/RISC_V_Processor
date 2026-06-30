`timescale 1ns / 1ps
module top_module#(parameter depth_reg = 32,
parameter d_width = 32)(
    input  reset,
    input  clk,
    output [31:0] result_out
);

wire [31:0] addr, next_addr, ins, four_pc;
wire RegWrite, MemWrite, Jump, Branch, ALUSrc;
wire [1:0] ResultSrc;
wire [2:0] imsrc;
wire [3:0] alucontrol;
wire w, hw, b;
wire [11:0] imm;
wire [6:0] opcode, funct7;
wire [2:0] funct3;
wire [$clog2(depth_reg)-1:0] rs_addr, rt_addr, rd_addr;
wire [d_width-1:0] write_data, r_data_1, r_data_2;
wire [24:0] ins_offset;
wire signed [31:0] offset;
wire [31:0] read_data_1, read_data_2, result;
wire zero, l_t_u, g_t_u, n_e, l_t_s, g_t_s;
wire [31:0] updated_pc, read_data;
wire bj, flush, stall;
wire [31:0] next_addr_s2, ins_s2, four_pc_s2;
wire RegWrite_s3, MemWrite_s3, Jump_s3, Branch_s3, ALUSrc_s3;
wire [1:0] ResultSrc_s3;
wire [3:0] alucontrol_s3;
wire w_s3, hw_s3, b_s3;
wire [31:0] r_data_1_s3, r_data_2_s3, next_addr_s3, four_pc_s3, offset_s3;
wire [2:0] funct3_s3;
wire [4:0] Rs1E, Rs2E, RdE;
wire RegWrite_s4, MemWrite_s4;
wire [1:0] ResultSrc_s4;
wire [31:0] result_s4, write_datamem_s4, four_pc_s4;
wire w_s4, hw_s4, b_s4;
wire [4:0] RdM;
wire RegWrite_s5;
wire [1:0] ResultSrc_s5;
wire [31:0] result_s5, read_data_s5, four_pc_s5;
wire [4:0] RdW;
wire [1:0] ForwardAE, ForwardBE;
wire [31:0] srca, srcb, write_datamem;
wire [31:0] mux_pc_out;

assign result_out = result;

assign flush = bj;

mux_32 pc_mux (.reset(reset),.a(four_pc),.b(updated_pc),.s(bj),.res(mux_pc_out));

pc pc_reg (.reset(reset),.clk(clk),.stall(stall),.addr(mux_pc_out),.next_addr(next_addr));

instruction_mem imem (.next_addr(next_addr),.ins(ins));

alu_four pc_four (.flush(flush),.next_addr(next_addr),.four_pc(four_pc));

pp_stage_2 pp2 (.clk(clk),.reset(reset),.flush(flush),.stall(stall),
    .next_addr(next_addr),.ins(ins),.four_pc(four_pc),
    .next_addr_s2(next_addr_s2),.ins_s2(ins_s2),.four_pc_s2(four_pc_s2));

assign imm = ins_s2[31:20]; assign opcode = ins_s2[6:0];
assign funct3 = ins_s2[14:12]; assign funct7 = ins_s2[31:25];
assign rs_addr = ins_s2[19:15]; assign rt_addr = ins_s2[24:20];
assign rd_addr = ins_s2[11:7]; assign ins_offset = ins_s2[31:7];

controlpath cp (.flush(flush),.imm(imm),.reset(reset),.ins(opcode),
    .funct3(funct3),.funct7(funct7),.RegWrite(RegWrite),.MemWrite(MemWrite),
    .Jump(Jump),.Branch(Branch),.ALUSrc(ALUSrc),.ResultSrc(ResultSrc),
    .imsrc(imsrc),.alucontrol(alucontrol),.w(w),.hw(hw),.b(b));

reg_file rf (.clk(clk),.flush(flush),.rs_addr(rs_addr),.rt_addr(rt_addr),
    .rd_addr(RdW),.write_data(write_data),.r_data_1(r_data_1),
    .r_data_2(r_data_2),.RegWrite(RegWrite_s5));

extender_offsethandler ext (.flush(flush),.funct3(funct3),.ins(ins_offset),
    .imsrc(imsrc),.offset(offset));

pp_stage_3 pp3 (.clk(clk),.reset(reset),.flush(flush),.stall(stall),
    .RegWrite(RegWrite),.MemWrite(MemWrite),.Jump(Jump),.Branch(Branch),
    .ALUSrc(ALUSrc),.ResultSrc(ResultSrc),.alucontrol(alucontrol),
    .w(w),.hw(hw),.b(b),.r_data_1(r_data_1),.r_data_2(r_data_2),
    .next_addr_s2(next_addr_s2),.four_pc_s2(four_pc_s2),.offset(offset),
    .funct3(funct3),.Rs1D(rs_addr),.Rs2D(rt_addr),.RdD(rd_addr),
    .RegWrite_s3(RegWrite_s3),.MemWrite_s3(MemWrite_s3),.Jump_s3(Jump_s3),
    .Branch_s3(Branch_s3),.ALUSrc_s3(ALUSrc_s3),.ResultSrc_s3(ResultSrc_s3),
    .alucontrol_s3(alucontrol_s3),.w_s3(w_s3),.hw_s3(hw_s3),.b_s3(b_s3),
    .r_data_1_s3(r_data_1_s3),.r_data_2_s3(r_data_2_s3),
    .next_addr_s3(next_addr_s3),.four_pc_s3(four_pc_s3),.offset_s3(offset_s3),
    .funct3_s3(funct3_s3),.Rs1E(Rs1E),.Rs2E(Rs2E),.RdE(RdE));

mux_32_3in forward_mux_A (.reset(reset),.a(r_data_1_s3),.b(write_data),
    .c(result_s4),.s(ForwardAE),.res(srca));

mux_32_3in forward_mux_B (.reset(reset),.a(r_data_2_s3),.b(write_data),
    .c(result_s4),.s(ForwardBE),.res(write_datamem));

mux_32 alusrc_mux (.reset(reset),.a(write_datamem),.b(offset_s3),
    .s(ALUSrc_s3),.res(srcb));

ALU alu_core (.read_data_1(srca),.read_data_2(srcb),.alucontrol(alucontrol_s3),
    .result(result),.zero(zero),.l_t_u(l_t_u),.g_t_u(g_t_u),
    .n_e(n_e),.l_t_s(l_t_s),.g_t_s(g_t_s));

alu_pc branch_target_calc (.next_addr(next_addr_s3),.offset(offset_s3),
    .updated_pc(updated_pc),.reset(reset));

bj_det branch_jump_eval (.reset(reset),.Branch(Branch_s3),.Jump(Jump_s3),
    .funct3(funct3_s3),.zero(zero),.l_t_u(l_t_u),.g_t_u(g_t_u),
    .n_e(n_e),.l_t_s(l_t_s),.g_t_s(g_t_s),.bj(bj));

pp_stage_4 pp4 (.clk(clk),.reset(reset),.RegWrite_s3(RegWrite_s3),
    .MemWrite_s3(MemWrite_s3),.ResultSrc_s3(ResultSrc_s3),.result(result),
    .write_datamem(write_datamem),.four_pc_s3(four_pc_s3),
    .w_s3(w_s3),.hw_s3(hw_s3),.b_s3(b_s3),.RdE(RdE),
    .RegWrite_s4(RegWrite_s4),.MemWrite_s4(MemWrite_s4),
    .ResultSrc_s4(ResultSrc_s4),.result_s4(result_s4),
    .write_datamem_s4(write_datamem_s4),.four_pc_s4(four_pc_s4),
    .w_s4(w_s4),.hw_s4(hw_s4),.b_s4(b_s4),.RdM(RdM));

data_mem dmem (.clk(clk),.MemWrite(MemWrite_s4),.addr(result_s4[6:0]),
    .write_data(write_datamem_s4),.w(w_s4),.hw(hw_s4),.b(b_s4),
    .read_data(read_data));

pp_stage_5 pp5 (.clk(clk),.reset(reset),.RegWrite_s4(RegWrite_s4),
    .ResultSrc_s4(ResultSrc_s4),.result_s4(result_s4),.read_data(read_data),
    .four_pc_s4(four_pc_s4),.RegWrite_s5(RegWrite_s5),
    .ResultSrc_s5(ResultSrc_s5),.result_s5(result_s5),
    .read_data_s5(read_data_s5),.four_pc_s5(four_pc_s5),
    .RdM(RdM),.RdW(RdW));

mux_32_3in writeback_mux (.reset(reset),.a(result_s5),.b(read_data_s5),
    .c(four_pc_s5),.res(write_data),.s(ResultSrc_s5));

hazard_unit hu (.reset(reset),.Rs1E(Rs1E),.Rs2E(Rs2E),.RdM(RdM),.RdW(RdW),
    .RegWrite_s4(RegWrite_s4),.RegWrite_s5(RegWrite_s5),
    .ResultSrc_s3(ResultSrc_s3),.RdE(RdE),.Rs1D(rs_addr),.Rs2D(rt_addr),
    .ForwardAE(ForwardAE),.ForwardBE(ForwardBE),.stall(stall));

endmodule