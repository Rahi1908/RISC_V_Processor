`timescale 1ns / 1ps
module instruction_memory (
    input  [31:0] readAddr,
    output [31:0] inst
);

    reg [7:0] insts [127:0];

    // LITTLE-ENDIAN FETCH: Lowest address byte maps to the LSB (bits 7:0)
    assign inst = (readAddr >= 128) ? 32'b0 :
                  {insts[readAddr+3], insts[readAddr+2], insts[readAddr+1], insts[readAddr]};

    initial begin
        
        insts[0]  = 8'h13; insts[1]  = 8'h04; insts[2]  = 8'h30; insts[3]  = 8'h0A; // Inst 0
        insts[4]  = 8'h13; insts[5]  = 8'h01; insts[6]  = 8'hC1; insts[7]  = 8'hFF; // Inst 1
        insts[8]  = 8'h23; insts[9]  = 8'h20; insts[10] = 8'h81; insts[11] = 8'h00; // Inst 2
        insts[12] = 8'h33; insts[13] = 8'h04; insts[14] = 8'h00; insts[15] = 8'h00; // Inst 3
        insts[16] = 8'h93; insts[17] = 8'h02; insts[18] = 8'h00; insts[19] = 8'h00; // Inst 4
        insts[20] = 8'h13; insts[21] = 8'hA3; insts[22] = 8'h72; insts[23] = 8'h00; // Inst 5
        insts[24] = 8'h63; insts[25] = 8'h06; insts[26] = 8'h03; insts[27] = 8'h00; // Inst 6
        insts[28] = 8'h93; insts[29] = 8'h82; insts[30] = 8'h12; insts[31] = 8'h00; // Inst 7
        insts[32] = 8'hE3; insts[33] = 8'h0A; insts[34] = 8'h00; insts[35] = 8'hFE; // Inst 8
        insts[36] = 8'h13; insts[37] = 8'h63; insts[38] = 8'hA3; insts[39] = 8'h00; // Inst 9
        insts[40] = 8'h03; insts[41] = 8'h24; insts[42] = 8'h01; insts[43] = 8'h00; // Inst 10
        insts[44] = 8'h13; insts[45] = 8'h01; insts[46] = 8'h41; insts[47] = 8'h00; // Inst 11
        
        // Padding out the rest of the memory space with zeroes
        insts[48] = 8'h00; insts[49] = 8'h00; insts[50] = 8'h00; insts[51] = 8'h00;
        insts[52] = 8'h00; insts[53] = 8'h00; insts[54] = 8'h00; insts[55] = 8'h00;
        insts[56] = 8'h00; insts[57] = 8'h00; insts[58] = 8'h00; insts[59] = 8'h00;
        insts[60] = 8'h00; insts[61] = 8'h00; insts[62] = 8'h00; insts[63] = 8'h00;
        insts[64] = 8'h00; insts[65] = 8'h00; insts[66] = 8'h00; insts[67] = 8'h00;
        insts[68] = 8'h00; insts[69] = 8'h00; insts[70] = 8'h00; insts[71] = 8'h00;
        insts[72] = 8'h00; insts[73] = 8'h00; insts[74] = 8'h00; insts[75] = 8'h00;
        insts[76] = 8'h00; insts[77] = 8'h00; insts[78] = 8'h00; insts[79] = 8'h00;
        insts[80] = 8'h00; insts[81] = 8'h00; insts[82] = 8'h00; insts[83] = 8'h00;
        insts[84] = 8'h00; insts[85] = 8'h00; insts[86] = 8'h00; insts[87] = 8'h00;
        insts[88] = 8'h00; insts[89] = 8'h00; insts[90] = 8'h00; insts[91] = 8'h00;
        insts[92] = 8'h00; insts[93] = 8'h00; insts[94] = 8'h00; insts[95] = 8'h00;
        insts[96] = 8'h00; insts[97] = 8'h00; insts[98] = 8'h00; insts[99] = 8'h00;
        insts[100] = 8'h00; insts[101] = 8'h00; insts[102] = 8'h00; insts[103] = 8'h00;
        insts[104] = 8'h00; insts[105] = 8'h00; insts[106] = 8'h00; insts[107] = 8'h00;
        insts[108] = 8'h00; insts[109] = 8'h00; insts[110] = 8'h00; insts[111] = 8'h00;
        insts[112] = 8'h00; insts[113] = 8'h00; insts[114] = 8'h00; insts[115] = 8'h00;
        insts[116] = 8'h00; insts[117] = 8'h00; insts[118] = 8'h00; insts[119] = 8'h00;
        insts[120] = 8'h00; insts[121] = 8'h00; insts[122] = 8'h00; insts[123] = 8'h00;
        insts[124] = 8'h00; insts[125] = 8'h00; insts[126] = 8'h00; insts[127] = 8'h00;
    end

endmodule