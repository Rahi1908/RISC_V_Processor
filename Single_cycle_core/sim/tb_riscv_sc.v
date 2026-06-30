`timescale 1ns / 1ps

module tb_riscv_sc;

    reg clk;
    reg rst;
    wire [31:0] pc_out, alu_out, result_out;

    single_cycle_top dut (
        .clk        (clk),
        .rst        (rst),
        .pc_out     (pc_out),
        .alu_out    (alu_out),
        .result_out (result_out)
    );

    initial begin
        clk = 0;
        forever #10 clk = ~clk;
    end

    initial begin
        rst = 0;   // Assert reset
        #20;       // Wait 1 clock cycle
        rst = 1;   // Deassert reset
        
        #3000;     // Run for 150 cycles to watch the waveform
        $finish;   // Stop simulation
    end

endmodule