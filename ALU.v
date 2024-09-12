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
