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
