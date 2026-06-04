`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2026 15:50:46
// Design Name: 
// Module Name: pc
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


module pc (
    input clk,
    input rst,
    input [31:0] pc_i,
    output reg [31:0] pc_o
);

always @(posedge clk ) begin
	if (~rst)
		pc_o <=32'b0;
	else
		pc_o <= pc_i;
end
endmodule
