`timescale 1ns / 1ps
module data_mem(
    input         clk,
    input         MemWrite,
    input [6:0] addr, 
    input  [31:0] write_data,
    input         w, hw, b,
    output reg [31:0] read_data
);

    reg [7:0] data_mem [127:0];

    integer i;
    initial begin
        for (i = 0; i < 128; i = i + 1)
            data_mem[i] = 8'h00;
    end

    // Read logic (little-endian byte assembly)
    always @(*) begin
        if (w)
            read_data = {data_mem[addr+3], data_mem[addr+2], data_mem[addr+1], data_mem[addr]};
        else if (hw) begin
            if (addr[1] == 0)
                read_data = {{16{1'b0}}, data_mem[addr+1], data_mem[addr]};
            else
                read_data = {{16{1'b0}}, data_mem[addr+3], data_mem[addr+2]};
        end
        else if (b) begin
            read_data = {{24{1'b0}}, data_mem[addr]};
        end
        else
            read_data = 32'b0;
    end

    // Write logic
    always @(posedge clk) begin
        if (MemWrite) begin
            if (w) begin
                data_mem[addr]   <= write_data[7:0];
                data_mem[addr+1] <= write_data[15:8];
                data_mem[addr+2] <= write_data[23:16];
                data_mem[addr+3] <= write_data[31:24];
            end
            else if (hw) begin
                if (addr[1] == 0) begin
                    data_mem[addr]   <= write_data[7:0];
                    data_mem[addr+1] <= write_data[15:8];
                end
                else begin
                    data_mem[addr+2] <= write_data[7:0];
                    data_mem[addr+3] <= write_data[15:8];
                end
            end
            else if (b) begin
                data_mem[addr] <= write_data[7:0];
            end
        end
    end

endmodule