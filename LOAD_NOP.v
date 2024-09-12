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
