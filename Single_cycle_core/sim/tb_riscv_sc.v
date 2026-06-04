`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.03.2026 00:11:33
// Design Name: 
// Module Name: tb_riscv_sc
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


module tb_riscv_sc;

reg clk;
reg rst;        // ← must be rst, NOT start

single_cycle_top riscv_DUT(clk, rst);  // ← pass rst here

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin
    rst = 0;        // hold in reset
    #10 rst = 1;    // release reset
    #3000 $finish;
end

endmodule