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
