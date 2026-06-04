`timescale 1ns / 1ps

module reg_file(
input clk,flush,
input [4:0] rs_addr,
input [4:0] rt_addr,
input [4:0] rd_addr,
input [31:0] write_data,
output reg [31:0] r_data_1,r_data_2,
input RegWrite
    );
    
    reg [31:0] mem [0:31];
    
    initial 
    begin
     $readmemh("register_file_counting.hex",mem);
    end
    
    // Write on negedge so value is available for combinational read
    // before the next posedge 
     
    always @(negedge clk) 
    begin
     if(RegWrite && (rd_addr != 5'd0))  // also protect x0
     mem[rd_addr] <= write_data;
    end
   
    always @(*) 
    begin
        if(flush) 
        begin 
            r_data_1 = 0;
            r_data_2 = 0;
        end
        else 
        begin
            r_data_1 = mem[rs_addr];
            r_data_2 = mem[rt_addr];
        end
    end 
     
endmodule
