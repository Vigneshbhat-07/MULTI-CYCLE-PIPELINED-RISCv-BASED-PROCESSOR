		// Module for register file (32 x 32 registers)
		module REGISTER_FILE(input clk,
									input [4:0]RS1,
									input [4:0]RS2,
									input [4:0]RD, 
									input wr_en_RF,
									input [31:0]Data_In_RF,
									output reg [31:0]OP1,
									output reg [31:0]OP2
									);
									
			reg [31:0] Register_Set [0:31]; 				// 32 X 32 Register_Set block
			
			// Assign operands on any change of input signals
			always @(*)
			begin
				OP1 <= Register_Set[RS1];					// Fetch OP1 from Register_Set based on RS1
				OP2 <= Register_Set[RS2];					// Fetch OP2 from Register_Set based on RS2
			end
			
			// Write data to RD location in register file on clock edge
			always @(posedge clk)
			begin
				if(wr_en_RF)
					Register_Set[RD] <= Data_In_RF;		// Write data to Register_Set at RD location

				else
					Register_Set[RD] <= Register_Set[RD];	
			end
							 
		endmodule
