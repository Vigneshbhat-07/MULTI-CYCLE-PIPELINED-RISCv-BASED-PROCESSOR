		// Module for program memory
		module PROGRAM_MEMORY(input clk,
				      input reset,
				      input [4:0]prog_addr,
				      output reg[31:0]instruction
				     );
							  
			reg [31:0] PROG_MEM [0:31];				// 32 X 32 PROG_MEM BLOCK
			
			always @(posedge clk)
			begin
				if(reset)
					instruction <= 32'b0;			// Reset instruction on reset signal
			
				else
					instruction <= PROG_MEM[prog_addr];	// Fetch instruction from memory using the program address									
			end
			
			// Preload the program memory with instructions
			always @(posedge clk)
			begin
//					 			 U - TYPE FORMAT
//								-----------------
//				|31 ------------------------------------------- 12|11 ----- 7|6 -------- 0|
//				|                 IMMEDIATE VALUE                 |    RD    |   OPCODE   |
				
				PROG_MEM[0] <= 32'b0000000_00000_00000_001_01000_1111111;      // LOAD_IMM	LOAD_IMM R8, #1
				PROG_MEM[1] <= 32'b0000000_00000_00000_100_01001_1111111;      // LOAD_IMM	LOAD_IMM R9, #4
				
//					 			  R - TYPE FORMAT
//                            					 -----------------
//				|31 ------- 25|24 ----- 20|19 ----- 15|14 ----- 12|11 ----- 7|6 -------- 0|
//				|    FUNC7    |    RS2    |    RS1    |   FUNC3   |    RD    |   OPCODE   |
				
				PROG_MEM[2] <= 32'b0000000_00000_00000_000_00000_0000000;		// NOP			   													
			
				PROG_MEM[3] <= 32'b0000000_01001_01000_000_00001_0110011;   		// ADD	ADD R1, R8, R9 
				PROG_MEM[4] <= 32'b0100000_01001_01000_000_00010_0110011;		// SUB	SUB R2, R8, R9
				PROG_MEM[5] <= 32'b0000000_01001_01000_110_00011_0110011;		// AND  AND R3, R8, R9
				PROG_MEM[6] <= 32'b0000000_01001_01000_111_00100_0110011;		// OR	 OR R4, R8, R9
				PROG_MEM[7] <= 32'b0000000_01001_01000_100_00101_0110011;		// XOR	XOR R5, R8, R9
			
				PROG_MEM[8] <= 32'b0000000_00000_00000_000_00000_1010101;		// HALT
				PROG_MEM[9] <= 32'b0000000_00000_00000_000_00000_1010101;		// HALT
		
			end
			
		endmodule
