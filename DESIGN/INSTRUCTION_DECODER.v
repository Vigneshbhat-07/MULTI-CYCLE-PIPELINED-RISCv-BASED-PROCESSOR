		// Module for instruction decoding
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
			
			// Decode instruction on clock edge
			always@(posedge clk)
			begin
				FUNC7 <= instruction[31:25];				// Extract FUNC7 bits
				RS2 <= instruction[24:20];					// Extract RS2 bits
				RS1 <= instruction[19:15];					// Extract RS1 bits
				FUNC3 <= instruction[14:12];				// Extract FUNC3 bits
				INP <= instruction[31:12];					// Extract Immediate value
				RD_reg <= instruction[11:7];				// Extract RD bits
			end
			
			// Decode OPCODE
			always @ (*) 
			begin
				OPCODE = instruction[6:0];					// Extract OPCODE
			end
			
			// Assign RD on clock edge
			always @(posedge clk)
			begin
				RD <= RD_reg;
			end		
		
		endmodule
