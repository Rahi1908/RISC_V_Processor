`timescale 1ns / 1ps

module controlpath(
input flush,
input [11:0] imm,
input reset,
input [6:0] ins,
input [2:0] funct3,
input [6:0] funct7,
output reg RegWrite,MemWrite,Jump,Branch,ALUSrc,
output reg [1:0] ResultSrc,
output reg [2:0] imsrc,
output reg [3:0] alucontrol,
output reg w,hw,b
    );
    
    always @ (*)
    begin
        if(reset | flush) 
        begin
            w=1;
            hw=0;
            b=0;
            Branch = 0;
            Jump = 0;
            RegWrite = 0;
            MemWrite = 0;
            ALUSrc = 0;
            ResultSrc = 2'b00;
            imsrc = 3'b000;
            alucontrol = 4'd0;
        end
        else 
        begin
            case(ins)
            
             7'b0110011 : begin // R type
                            Branch = 0;
                            Jump = 0;
                            RegWrite = 1;
                            MemWrite = 0;
                            ALUSrc = 0;
                            ResultSrc = 2'b00;
                            imsrc = 3'b000;
                            w = 1;hw=0;b=0;
    
                            case(funct3)
                            
                            3'b000 : begin // add / sub
                                        if(funct7 == 7'd0)
                                            alucontrol = 4'd0; // add
                                        else
                                            alucontrol = 4'd1; // sub
                                     end
    
                            3'b100 : alucontrol = 4'd5; // xor
                           
                            3'b110 : alucontrol = 4'd3; // or
                            
                            3'b111 : alucontrol = 4'd4; // and
                            
                            3'b001 : alucontrol = 4'd2; // sll
                            
                            3'b101 : begin // srl / sra
                                        if(funct7 == 7'd0) 
                                            alucontrol = 4'd7; // srl
                                        else 
                                            alucontrol = 4'd8; // sra
                                    end
                            
                            3'b010 : alucontrol = 4'd9; // slt
                            
                            3'b011 : alucontrol = 4'd6; // sltu
                            
                            endcase
                        end
                        
               7'b0010011 : begin  // I type
    
                                w = 1;hw=0;b=0;
                                Branch = 0;
                                Jump = 0;
                                RegWrite = 1;
                                MemWrite = 0;
                                ALUSrc = 1;
                                ResultSrc = 2'b00;
                                imsrc = 3'b101;
                                
                                case(funct3)
                                3'b000 : alucontrol = 4'd0; // addi
                                3'b100 : alucontrol = 4'd5; // xori
                                3'b110 : alucontrol = 4'd3; // ori
                                3'b111 : alucontrol = 4'd4; // andi
                                3'b001 : alucontrol = 4'd2; // slli
                                3'b101 : begin // srli / srai
                                            if(imm[11:5] == 7'd0) 
                                                alucontrol = 4'd7; // srli
                                            else 
                                                alucontrol = 4'd8; // srai
                                         end
                                3'b010 : alucontrol = 4'd9; // slti
                                3'b011 : alucontrol = 4'd6; // sltiu
                                endcase
                            end
                            
                 7'b0000011 : begin// load (I type)
                                Branch = 0;
                                Jump = 0;
                                RegWrite = 1;
                                MemWrite = 0;
                                ALUSrc = 1;
                                ResultSrc = 2'b01;
                                imsrc = 3'b000;
                                alucontrol = 4'd0;
                                
                                case(funct3)
                                3'b000 : begin
                                            b=1;hw=0;w=0; // lb
                                         end
    
                                3'b001 : begin
                                            hw=1;w=0;b=0; // lh 
                                         end
    
                                3'b010 : begin
                                            w=1;hw=0;b=0; // lw
                                         end
                                
                                3'b100 : begin
                                            b=1;hw=0;w=0; // lbu
                                         end
    
                                3'b101 : begin
                                            hw=1;b=0;w=0; // lhu
                                         end
                                endcase
                            end
                            
               7'b0100011 : begin //store (S type)
                                Branch = 0;
                                Jump = 0;
                                RegWrite = 0;
                                MemWrite = 1;
                                ALUSrc = 1;
                                ResultSrc = 2'b00;
                                imsrc = 3'b010;
                                alucontrol = 4'd0;
                                
                                case(funct3) 
                                3'b000 : begin
                                            b=1;hw=0;w=0; // sb
                                         end
    
                                3'b001 : begin
                                            hw=1;b=0;w=0; //sh
                                         end
                                
                                3'b010 : begin
                                            w=1;hw=0;b=0; //sw
                                         end
                                endcase
                             end
                             
                  7'b1100011 : begin // (B Type)
                                    w=1;b=0;hw=0;
                                    Branch = 1;
                                    Jump = 0;
                                    RegWrite = 0;
                                    MemWrite = 0;
                                    ALUSrc = 0;
                                    ResultSrc = 2'b00;
                                    imsrc = 3'b011;
                                    alucontrol = 4'd0;
                                end
                                
                  7'b1101111 : begin //(J Type)
                                    w=1;hw=0;b=0;
                                    Branch = 0;
                                    Jump = 1;
                                    RegWrite = 1;
                                    MemWrite = 0;
                                    ALUSrc = 1;
                                    ResultSrc = 2'b10;
                                    imsrc = 3'b100;
                                    alucontrol = 4'd0;
                                end
                                
                  default : begin
                                w=1;hw=0;b=0;
                                Branch = 0;
                                Jump = 0;
                                RegWrite = 0;
                                MemWrite = 0;
                                ALUSrc = 0;
                                ResultSrc = 2'b00;
                                imsrc = 3'b000;
                                alucontrol = 4'd0;
                            end
                        
            endcase
        end
    end
endmodule