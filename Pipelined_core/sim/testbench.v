`timescale 1ns / 1ps

module testbench;

    reg clk;
    reg reset;
    wire [31:0] result_out;

    top_module dut (
        .clk        (clk),
        .reset      (reset),
        .result_out (result_out)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1;
        #20;             // Wait 2 clock cycles
        reset = 0;       // Deassert Reset
       
        #1500;           // Run for 1500ns (equivalent to 150 clock cycles)
        
        $display("[TB] Simulation Completed Safely.");
        $finish;         // Stop the simulation
    end

endmodule