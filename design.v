    //`timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date:    10:56:21 09/03/2024 
    // Design Name: 
    // Module Name:    CA_project 
    // Project Name: 
    // Target Devices: 
    // Tool versions: 
    // Description: 
    //
    // Dependencies: 
    //
    // Revision: 
    // Revision 0.01 - File Created
    // Additional Comments: 
    //
    //////////////////////////////////////////////////////////////////////////////////

    module CA_PROJECT(input wire clk,
                input wire reset,
                output wire [31:0]Out_value
                );

      wire [4:0] prog_addr_wire,RS1_wire,RS2_wire,RD_wire;
      wire [31:0] instruction_wire,OP1_wire,OP2_wire,OUT_wire,Data_In_RF_wire;
      wire [6:0] OPCODE_wire,FUNC7_wire;
      wire [2:0] FUNC3_wire;
      wire [19:0] INP_wire;
      wire wr_en_RF_wire;

      PROGRAM_COUNTER PC(.clk(clk),
                   .reset(reset),
                   .OPCODE(OPCODE_wire),
                   .prog_addr(prog_addr_wire)
                   );

      PROGRAM_MEMORY PM(.clk(clk),
                  .reset(reset),
                  .prog_addr(prog_addr_wire),
                  .instruction(instruction_wire)
                  );

      INSTRUCTION_DECODER ID(.clk(clk),
                      .instruction(instruction_wire),
                      .OPCODE(OPCODE_wire),
                       .FUNC7(FUNC7_wire),
                       .FUNC3(FUNC3_wire),
                       .RS1(RS1_wire),
                       .RS2(RS2_wire),
                      .RD(RD_wire),
                      .INP(INP_wire)
                       );

      REGISTER_FILE RF(.clk(clk),
                  .RS1(RS1_wire),
                   .RS2(RS2_wire),
                   .RD(RD_wire),
                   .wr_en_RF(wr_en_RF_wire),
                   .Data_In_RF(Data_In_RF_wire),
                   .OP1(OP1_wire),
                   .OP2(OP2_wire)
                   );

      ALU OP(.clk(clk),
           .OPCODE(OPCODE_wire),
           .FUNC7(FUNC7_wire), 
           .FUNC3(FUNC3_wire),
           .OP1(OP1_wire),
           .OP2(OP2_wire),
           .OUT(OUT_wire)
           );

      LOAD_NOP LN(.clk(clk),
               .OPCODE(OPCODE_wire),
              .INP(INP_wire),
              .ALU_OUT(OUT_wire),
              .wr_en_RF(wr_en_RF_wire),
              .Data_In_RF(Data_In_RF_wire)
              );  

      assign Out_value = OUT_wire;

    endmodule


    module PROGRAM_COUNTER(input clk,
                    input reset,
                    input [6:0]OPCODE,
                    output reg[4:0]prog_addr
                   );

      always @(posedge clk)
      begin
        if(reset)
          prog_addr <= 5'b0;

        else if(OPCODE == 7'b1010101)       // HALT
          prog_addr <= prog_addr;

        else
          prog_addr <= prog_addr + 1'b1;   // Increment program address by 1 => points to next instruction
      end

    endmodule


    module PROGRAM_MEMORY(input clk,
                   input reset,
                   input [4:0]prog_addr,
                   output reg[31:0]instruction
                  );

      reg [31:0] PROG_MEM [0:31];              // 32 X 32 PROG_MEM BLOCK

      always @(posedge clk)
      begin
        if(reset)
          instruction <= 32'b0;

        else
          instruction <= PROG_MEM[prog_addr];                    
      end

      always @(posedge clk)
      begin
//                               U - TYPE FORMAT
//                             -----------------
//        |31 ------------------------------------------- 12|11 ----- 7|6 -------- 0|
//        |                 IMMEDIATE VALUE                 |    RD    |   OPCODE   |

        PROG_MEM[0] <= 32'b0000000_00000_00000_001_01000_1111111;          //LOAD_IMM
        PROG_MEM[1] <= 32'b0000000_00000_00000_100_01001_1111111;        //LOAD_IMM

//                              R - TYPE FORMAT
//                                        -----------------
//        |31 ------- 25|24 ----- 20|19 ----- 15|14 ----- 12|11 ----- 7|6 -------- 0|
//        |    FUNC7    |    RS2    |    RS1    |   FUNC3   |    RD    |   OPCODE   |

        PROG_MEM[2] <= 32'b0000000_00000_00000_000_00000_0000000;          //NOP                                

        PROG_MEM[3] <= 32'b0000000_01001_01000_000_00001_0110011;              //ADD
        PROG_MEM[4] <= 32'b0100000_01001_01000_000_00010_0110011;          //SUB
        PROG_MEM[5] <= 32'b0000000_01001_01000_110_00011_0110011;          //AND
        PROG_MEM[6] <= 32'b0000000_01001_01000_111_00100_0110011;          //OR
        PROG_MEM[7] <= 32'b0000000_01001_01000_100_00101_0110011;          //XOR

        PROG_MEM[8] <= 32'b0000000_00000_00000_000_00000_1010101;          //HALT
        PROG_MEM[9] <= 32'b0000000_00000_00000_000_00000_1010101;          //HALT

      end

    endmodule


    module INSTRUCTION_DECODER(input clk,
                      input [31:0]instruction,
                      output reg[6:0]OPCODE,
                      output reg[6:0]FUNC7,
                      output reg[2:0]FUNC3,
                      output reg[4:0]RS1,
                      output reg[4:0]RS2,
                      output reg[4:0]RD,
                      output reg[19:0]INP
                      );
      reg [4:0] RD_reg;

      always@(posedge clk)
      begin
        FUNC7 <= instruction[31:25];
        RS2 <= instruction[24:20];
        RS1 <= instruction[19:15];
        FUNC3 <= instruction[14:12];
        INP <= instruction[31:12];
        RD_reg <= instruction[11:7];
      end

      always @ (*) 
      begin
        OPCODE = instruction[6:0];
      end

      always @(posedge clk)
      begin
        RD <= RD_reg;
      end    

    endmodule


    module REGISTER_FILE(input clk,
                  input [4:0]RS1,
                  input [4:0]RS2,
                  input [4:0]RD, 
                  input wr_en_RF,
                  input [31:0]Data_In_RF,
                  output reg [31:0]OP1,
                  output reg [31:0]OP2
                  );

      reg [31:0] Register_Set [0:31];         // 32 X 32 Register_Set block

      always @(*)
      begin
        OP1 <= Register_Set[RS1];          // OP1 is Operand value at RS1 location of Register_Set block
        OP2 <= Register_Set[RS2];          // OP2 is Operand value at RS2 location of Register_Set block
      end

      always @(posedge clk)
      begin
        if(wr_en_RF)
          Register_Set[RD] <= Data_In_RF;    //Writing data into the RD location of Register_Set block

        else
          Register_Set[RD] <= Register_Set[RD];  
      end

    endmodule


    module ALU(input clk,
            input [6:0]OPCODE,
            input [31:0]OP1,
            input [31:0]OP2,
            input [6:0] FUNC7,
            input [2:0] FUNC3,
            output reg[31:0]OUT
            );

      reg [6:0] OPCODE_reg;

      always @ (posedge clk) 
      begin
        OPCODE_reg <= OPCODE;
      end

      always@(posedge clk)
      begin
        case({FUNC7,FUNC3,OPCODE_reg})
        17'b0000000_000_0110011 : begin                 // ADD
                          OUT <= OP1 + OP2;
                          end

        17'b0100000_000_0110011 : begin            // SUB
                          OUT <= OP1 - OP2;
                          end

        17'b0000000_110_0110011 : begin            // AND
                          OUT <= OP1 & OP2;
                          end

        17'b0000000_111_0110011 : begin            // OR
                          OUT <= OP1 | OP2;
                          end

        17'b0000000_100_0110011 : begin             // XOR
                          OUT <= OP1 ^ OP2;
                          end

                    default: begin             //DEFAULT
                          OUT <= 32'b0;
                          end

        endcase  
      end

    endmodule


    module LOAD_NOP(input clk,
               input [6:0]OPCODE,
               input [19:0]INP,
               input [31:0] ALU_OUT,
               output reg wr_en_RF,
               output reg [31:0]Data_In_RF
               );

      reg [19:0] INP_reg;
      reg [6:0] OPCODE_reg,OPCODE_reg2;

      always @(posedge clk)
      begin
        INP_reg <= INP;
      end

      always @(posedge clk) 
      begin
        OPCODE_reg2 <= OPCODE;
        OPCODE_reg <= OPCODE_reg2;
      end

      always @(*)
      begin
        if(OPCODE_reg == 7'b1111111)                      // LOAD_IMMEDIATE
          begin 
            Data_In_RF = {12'b0,INP_reg};
            wr_en_RF = 1'b1;
          end

        else if(OPCODE_reg == 7'b0000000)            // NO_OPERATION
          begin 
            Data_In_RF = Data_In_RF;
            wr_en_RF = 1'b0;
          end

        else if(OPCODE_reg == 7'b0110011)            // ALU_OPERATION
          begin
            Data_In_RF = ALU_OUT;
            wr_en_RF = 1'b1;
          end

        else                                 // DEFAULT
          begin
            Data_In_RF = ALU_OUT;                
            wr_en_RF = 1'b0;
          end

      end

    endmodule


 
