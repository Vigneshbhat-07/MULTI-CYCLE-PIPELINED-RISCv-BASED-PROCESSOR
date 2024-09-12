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
