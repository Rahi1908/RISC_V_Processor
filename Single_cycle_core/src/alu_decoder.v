`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.01.2026 18:34:25
// Design Name: 
// Module Name: alu_decoder
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

module alu_decoder (
    input  [1:0] ALUOp,       // From main decoder
    input  [6:0] funct7,      // Full funct7 from instruction
    input  [2:0] funct3,      // funct3 from instruction
    output reg [3:0] ALUCtl   // 4 bits for ALU
);

always @(*) begin
    case (ALUOp)
        2'b00: ALUCtl = 4'd0; // lw and sw needs add

        2'b01: ALUCtl = 4'd1; // branch needs sub

        2'b10: begin        //integer R-Type
            case (funct3)
                3'b000: ALUCtl = (funct7[5]) ? 4'd1 : 4'd0; // SUB (bit 30 set) or ADD
                3'b001: ALUCtl = 4'd2; // SLL
                3'b010: ALUCtl = 4'd9; // SLT (mapped to 4'd9 in ALU)
                3'b011: ALUCtl = 4'd6; // SLTU (mapped to 4'd6 in ALU)
                3'b100: ALUCtl = 4'd5; // XOR
                3'b101: ALUCtl = (funct7[5]) ? 4'd8 : 4'd7; // SRA (bit 30 set) or SRL
                3'b110: ALUCtl = 4'd3; // OR
                3'b111: ALUCtl = 4'd4; // AND
                default: ALUCtl = 4'd0;
            endcase
        end

        2'b11: begin  // integer I-Type (ADDI, SLTI, XORI, etc.)
            case (funct3)
                3'b000: ALUCtl = 4'd0; // ADDI
                3'b010: ALUCtl = 4'd9; // SLTI
                3'b011: ALUCtl = 4'd6; // SLTUI
                3'b100: ALUCtl = 4'd5; // XORI
                3'b110: ALUCtl = 4'd3; // ORI
                3'b111: ALUCtl = 4'd4; // ANDI
                3'b001: ALUCtl = 4'd2; // SLLI
                3'b101: ALUCtl = (funct7[5]) ? 4'd8 : 4'd7; // SRAI or SRLI
                default: ALUCtl = 4'd0;
            endcase
        end

        default: ALUCtl = 4'd0;
    endcase
end

endmodule
