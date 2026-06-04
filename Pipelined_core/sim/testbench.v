`timescale 1ns / 1ps

module testbench;

// ── clock and reset ──────────────────────────────────────────
reg clk, reset;
initial clk = 0;
always #5 clk = ~clk;   // 10ns clock period

// ── all output wires matching your top_module port list ──────
wire [31:0] addr, next_addr, ins, four_pc;
wire        RegWrite, MemWrite, Jump, Branch, ALUSrc;
wire [1:0]  ResultSrc;
wire [2:0]  imsrc;
wire [3:0]  alucontrol;
wire        w, hw, b;
wire [11:0] imm;
wire [6:0]  opcode;
wire [2:0]  funct3;
wire [6:0]  funct7;
wire [4:0]  rs_addr, rt_addr, rd_addr;
wire [31:0] write_data;
wire [31:0] r_data_1, r_data_2;
wire [24:0] ins_offset;
wire signed [31:0] offset;
wire [31:0] read_data_1, read_data_2;
wire [31:0] result;
wire        zero, l_t_u, g_t_u, n_e, l_t_s, g_t_s;
wire [31:0] updated_pc;
wire        bj;
wire [31:0] read_data;

// stage 2
wire [31:0] next_addr_s2, ins_s2, four_pc_s2;

// stage 3
wire        RegWrite_s3, MemWrite_s3, Jump_s3, Branch_s3, ALUSrc_s3;
wire [1:0]  ResultSrc_s3;
wire [3:0]  alucontrol_s3;
wire        w_s3, hw_s3, b_s3;
wire [31:0] r_data_1_s3, r_data_2_s3;
wire [31:0] next_addr_s3, four_pc_s3, offset_s3;
wire [2:0]  funct3_s3;
wire [4:0]  Rs1E, Rs2E, RdE;

// stage 4
wire        RegWrite_s4, MemWrite_s4;
wire [1:0]  ResultSrc_s4;
wire [31:0] result_s4, write_datamem_s4, four_pc_s4;
wire        w_s4, hw_s4, b_s4;
wire [4:0]  RdM;

// stage 5
wire        RegWrite_s5;
wire [1:0]  ResultSrc_s5;
wire [31:0] result_s5, read_data_s5, four_pc_s5;
wire [4:0]  RdW;

// hazard
wire [1:0]  ForwardAE, ForwardBE;
wire        stall;

// EX stage
wire [31:0] srca, srcb, write_datamem;

// ── instantiate YOUR top_module ──────────────────────────────
top_module dut (
    .clk             (clk),
    .reset           (reset),
    .addr            (addr),
    .next_addr       (next_addr),
    .ins             (ins),
    .four_pc         (four_pc),
    .RegWrite        (RegWrite),
    .MemWrite        (MemWrite),
    .Jump            (Jump),
    .Branch          (Branch),
    .ALUSrc          (ALUSrc),
    .ResultSrc       (ResultSrc),
    .imsrc           (imsrc),
    .alucontrol      (alucontrol),
    .w               (w),
    .hw              (hw),
    .b               (b),
    .imm             (imm),
    .opcode          (opcode),
    .funct3          (funct3),
    .funct7          (funct7),
    .rs_addr         (rs_addr),
    .rt_addr         (rt_addr),
    .rd_addr         (rd_addr),
    .write_data      (write_data),
    .r_data_1        (r_data_1),
    .r_data_2        (r_data_2),
    .ins_offset      (ins_offset),
    .offset          (offset),
    .read_data_1     (read_data_1),
    .read_data_2     (read_data_2),
    .result          (result),
    .zero            (zero),
    .l_t_u           (l_t_u),
    .g_t_u           (g_t_u),
    .n_e             (n_e),
    .l_t_s           (l_t_s),
    .g_t_s           (g_t_s),
    .updated_pc      (updated_pc),
    .bj              (bj),
    .read_data       (read_data),
    .next_addr_s2    (next_addr_s2),
    .ins_s2          (ins_s2),
    .four_pc_s2      (four_pc_s2),
    .RegWrite_s3     (RegWrite_s3),
    .MemWrite_s3     (MemWrite_s3),
    .Jump_s3         (Jump_s3),
    .Branch_s3       (Branch_s3),
    .ALUSrc_s3       (ALUSrc_s3),
    .ResultSrc_s3    (ResultSrc_s3),
    .alucontrol_s3   (alucontrol_s3),
    .w_s3            (w_s3),
    .hw_s3           (hw_s3),
    .b_s3            (b_s3),
    .r_data_1_s3     (r_data_1_s3),
    .r_data_2_s3     (r_data_2_s3),
    .next_addr_s3    (next_addr_s3),
    .four_pc_s3      (four_pc_s3),
    .offset_s3       (offset_s3),
    .funct3_s3       (funct3_s3),
    .Rs1E            (Rs1E),
    .Rs2E            (Rs2E),
    .RdE             (RdE),
    .RegWrite_s4     (RegWrite_s4),
    .MemWrite_s4     (MemWrite_s4),
    .ResultSrc_s4    (ResultSrc_s4),
    .result_s4       (result_s4),
    .write_datamem_s4(write_datamem_s4),
    .four_pc_s4      (four_pc_s4),
    .w_s4            (w_s4),
    .hw_s4           (hw_s4),
    .b_s4            (b_s4),
    .RdM             (RdM),
    .RegWrite_s5     (RegWrite_s5),
    .ResultSrc_s5    (ResultSrc_s5),
    .result_s5       (result_s5),
    .read_data_s5    (read_data_s5),
    .four_pc_s5      (four_pc_s5),
    .RdW             (RdW),
    .ForwardAE       (ForwardAE),
    .ForwardBE       (ForwardBE),
    .stall           (stall),
    .srca            (srca),
    .srcb            (srcb),
    .write_datamem   (write_datamem)
);

// ── reset sequence ───────────────────────────────────────────
initial begin
    reset = 1;
    @(posedge clk); #1;
    @(posedge clk); #1;
    reset = 0;
end



// ── main simulation + output dump ────────────────────────────
integer i;
integer f;

initial begin
    // wait for reset
    @(negedge reset);

    // run 150 cycles - enough for our test program
    repeat(150) @(posedge clk);
    #1; // small delay so final writes settle

    // ── print to console ─────────────────────────────────────
    $display("================================================");
    $display("  FINAL REGISTER FILE");
    $display("================================================");
    for(i = 0; i < 32; i = i + 1) begin
        if(dut.rf.mem[i] !== 32'b0)
            $display("  x%-2d = 0x%08X  (%0d)", i, dut.rf.mem[i], dut.rf.mem[i]);
    end

    $display("");
    $display("  DATA MEMORY (non-zero)");
    $display("================================================");
    for(i = 0; i < 32; i = i + 1) begin
        if(dut.dmem.mem[i] !== 32'b0)
            $display("  mem[%0d] addr=0x%04X = 0x%08X", i, i*4, dut.dmem.mem[i]);
    end

    // ── write rtl_output.txt for Python comparator ───────────
    f = $fopen("rtl_output.txt", "w");
    if(f == 0) begin
        $display("[ERROR] Could not open rtl_output.txt for writing");
    end else begin
        $fdisplay(f, "REGISTERS");
        for(i = 0; i < 32; i = i + 1)
            $fdisplay(f, "x%0d %08X", i, dut.rf.mem[i]);

        $fdisplay(f, "MEMORY");
        for(i = 0; i < 32; i = i + 1) begin
            if(dut.dmem.mem[i] !== 32'b0)
                $fdisplay(f, "m%0d %08X", i, dut.dmem.mem[i]);
        end
        $fclose(f);
        $display("[TB] rtl_output.txt written successfully");
    end

    $display("[TB] Simulation done. Run python3 compare_rtl.py to verify.");
    $finish;
end

// ── cycle counter printed every 10 cycles ────────────────────
integer cycle_count;
initial cycle_count = 0;
always @(posedge clk) begin
    if(!reset) begin
        cycle_count = cycle_count + 1;
        if(cycle_count % 10 == 0)
            $display("[TB] Cycle %0d  PC=0x%08X  bj=%b  stall=%b",
                     cycle_count, next_addr, bj, stall);
    end
end

endmodule