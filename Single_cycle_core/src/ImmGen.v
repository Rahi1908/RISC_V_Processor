`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.02.2026 18:17:32
// Design Name: 
// Module Name: ImmGen
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


module ImmGen (
    input [31:0] inst,
    output reg [31:0] imm
);
 wire [6:0] opcode = inst[6:0];
 
 always @(*) 
 begin
    case (opcode)
        7'b0010011, 7'b0000011: imm = {{20{inst[31]}}, inst[31:20]}; // I-type , and load instruction
        7'b0100011: imm = {{20{inst[31]}}, inst[31:25], inst[11:7]}; // S-type
        7'b1100011: imm = {{19{inst[31]}}, inst[31], inst[7], inst[30:25], inst[11:8], 1'b0}; // B-type
        default: imm = 32'b0;
    endcase
 end

endmodule
