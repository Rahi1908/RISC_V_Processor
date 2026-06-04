`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.12.2025 16:13:43
// Design Name: 
// Module Name: alu
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


module alu(
input [31:0] RD_1,  //data from either the register file read values or the immediate values
input [31:0] RD_2,  
input [3:0] alu_control, //from the control unit
output reg [31:0] result, //final result
output zero, l_t_u, g_t_u, n_e, l_t_s, g_t_s, V, C //status flags for comparison
    );
reg signed [31:0] A, B;    
wire [31:0] sum;
wire cout;
reg signed [31:0] sub;

always @ (*)
 begin
 A = RD_1;
 B = RD_2;
 sub = A-B;
  case (alu_control)
   4'd0 : result = RD_1 + RD_2;     //ADD, ADDI
   4'd1 : result = A - B;      // SUB
   4'd2 : result = RD_1 << RD_2[4:0];  //sll , slli     
   4'd3 : result = RD_1 | RD_2;   // OR, ORI
   4'd4 : result = RD_1 & RD_2; // AND, ANDI
   4'd5 : result = RD_1 ^ RD_2; // XOR, XORI
   4'd6 : result = ( RD_1 < RD_2 );// sltu, sltui 
   4'd7 : result = RD_1 >> RD_2[4:0]; // srl, srli
   4'd8 : result = $signed(RD_1) >>> RD_2[4:0]; // sra, srai
   4'd9 : result = { 31'b0 , (sub[31]^V) };  //slt
   default : result = RD_1 + RD_2;
  endcase
 end
 
assign {cout , sum} = A + B; 
assign zero = (result == 32'b0);    //zero flag , tells whether the two operands are equal
assign n_e = ~zero;                 // not equal to      
assign l_t_u = (RD_1 < RD_2) ? 1 : 0;   //less than unsigned
assign g_t_u = (RD_1 > RD_2) ? 1 : 0;    //greater than unsigned
assign l_t_s = (A < B) ? 1 : 0;      // less than signed 
assign g_t_s = (A > B) ? 1 : 0;      // greater than signed 
//assign N = result [31];             //sign bit
assign C = (alu_control == 4'b0000) ? cout : 1'b0;  //carry flag
assign V =                                       //over flow falg (considers signed overflow)
    (alu_control == 4'd0) ? (~(RD_1[31] ^ RD_2[31]) & (RD_1[31] ^ sum[31])) :    
    (alu_control == 4'd1) ? ((RD_1[31] ^ RD_2[31]) & (RD_1[31] ^ sub[31])) : 1'b0;
 
endmodule
