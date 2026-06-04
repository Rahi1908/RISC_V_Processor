`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2026 19:15:06
// Design Name: 
// Module Name: control_unit_top
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


module control_unit(
    input [6:0] opcode,
    input [6:0] funct7,
    input [2:0] funct3,
    input zero,
    output regWrite,    
    output memWrite,    
    output memtoReg,    
    output memRead,     
    output ALUSrc,      
    output PCSrc,     
    output [3:0] aluControl 
);

    wire [1:0] ALUOp;
    wire branch;

    // 1. Main Decoder Instance
    main_decoder u_main_dec (
        .opcode(opcode),
        .branch(branch),
        .memRead(memRead),
        .memtoReg(memtoReg),
        .memWrite(memWrite),
        .ALUSrc(ALUSrc),
        .regWrite(regWrite),
        .ALUOp(ALUOp)
    );

    // 2. ALU Decoder Instance
    alu_decoder u_alu_dec (
        .ALUOp(ALUOp),
        .funct7(funct7),
        .funct3(funct3),
        .ALUCtl(aluControl)
    );

 
    // 3. Program Counter Source Logic
    // If it's a branch instruction AND the ALU zero flag is set, we jump.
    assign PCSrc = branch & zero;

endmodule