`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2026 17:59:31
// Design Name: 
// Module Name: main_decoder
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


module main_decoder(
input  [6:0] opcode,
    output reg   branch,
    output reg   memRead,
    output reg   memtoReg,
    output reg   memWrite,
    output reg   ALUSrc,
    output reg   regWrite,
    output reg [1:0] ALUOp     // Provides a hint to the ALU decoder about which ALU operation class to perform
    ); 
                           
   always @(*) begin
    // Default values
    branch   = 0;
    memRead  = 0;
    memtoReg = 0;
    memWrite = 0;
    ALUSrc   = 0;
    regWrite = 0;
    ALUOp    = 2'b00;

    case (opcode)
        7'b0110011: begin // R-type (add, sub, sll, slt, etc.)
            regWrite = 1;
            ALUOp    = 2'b10;
        end
        7'b0010011: begin // I-type (addi, slti, xori, slli, etc.)
            regWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b11; // Use 2'b11 to signal I-type to ALU Decoder
        end
        7'b0000011: begin // Load (lw)
            regWrite = 1;
            memRead  = 1;
            memtoReg = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00; // ALU adds for address calculation
        end
        7'b0100011: begin // Store (sw)
            memWrite = 1;
            ALUSrc   = 1;
            ALUOp    = 2'b00; // ALU adds for address calculation
        end
        7'b1100011: begin // Branch (beq)
            branch   = 1;
            ALUOp    = 2'b01; // ALU subtracts for comparison
        end
        default: ; // Defaults already set
    endcase
end
    
endmodule
