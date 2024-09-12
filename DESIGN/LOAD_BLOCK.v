// Module for handling all load operations
module LOAD_BLOCK(
    input clk,                      // Clock signal
    input [6:0] OPCODE,             // 7-bit opcode from instruction decoder
    input [19:0] INP,               // 20-bit input data (immediate value)
    input [31:0] ALU_OUT,           // 32-bit output from ALU
    output reg wr_en_RF,            // Write enable signal for the register file
    output reg [31:0] Data_In_RF    // 32-bit data to be written to the register file
);

    // Internal registers for holding input and opcode values
    reg [19:0] INP_reg;             // Register to hold input value
    reg [6:0] OPCODE_reg, OPCODE_reg2; // Registers to hold opcode values for state holding

    // Sequential logic to capture the input value on the rising edge of the clock
    always @(posedge clk) begin
        INP_reg <= INP;  // Store the input value on each clock edge
    end

    // Sequential logic to capture the opcode value on the rising edge of the clock
    always @(posedge clk) begin
        OPCODE_reg2 <= OPCODE;  // Store the current opcode value
        OPCODE_reg <= OPCODE_reg2;  // Store the previous opcode value for comparison
    end

    // Combinational logic to determine the output based on the opcode
    always @(*) begin
        // Handling for LOAD_IMMEDIATE operation
        if (OPCODE_reg == 7'b1111111) begin
            Data_In_RF = {12'b0, INP_reg}; // Pad the 20-bit input with 12 zeros to make it 32-bit
            wr_en_RF = 1'b1;               // Enable write to the register file
        end
        // Handling for NO_OPERATION
        else if (OPCODE_reg == 7'b0000000) begin
            Data_In_RF = Data_In_RF;       // Keep the data unchanged
            wr_en_RF = 1'b0;               // Disable write to the register file
        end
        // Handling for ALU_OPERATION
        else if (OPCODE_reg == 7'b0110011) begin
            Data_In_RF = ALU_OUT;          // Pass the ALU output to the register file
            wr_en_RF = 1'b1;               // Enable write to the register file
        end
        // Default case (for unknown or unsupported opcodes)
        else begin
            Data_In_RF = ALU_OUT;          // Pass the ALU output to the register file
            wr_en_RF = 1'b0;               // Disable write to the register file
        end
    end

endmodule
