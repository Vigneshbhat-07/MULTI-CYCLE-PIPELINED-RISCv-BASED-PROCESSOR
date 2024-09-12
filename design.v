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
