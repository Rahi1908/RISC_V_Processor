`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 20.01.2026 20:18:55
// Design Name: 
// Module Name: sign_extend
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


module sign_extend(
input [1:0] ImmSrc,
input [31:0] In,
output reg [31:0] ImmExt
    );
   
   always @ (*)
    begin
     case (ImmSrc)
      2'b00 : ImmExt = { {20{In[31]}} , In [31:20] };    // I-type
      2'b01 : ImmExt = { {20{In[31]}} , In [31:25] , In [11:7] }; // S-type
      2'b10 : ImmExt = { {19{In[31]}} , In[31] , In[7] , In[30:25] , In[11:8] , 1'b0  }; // B-type
      default : ImmExt = 32'b0; // to avoid latches
     endcase
    end 
endmodule
