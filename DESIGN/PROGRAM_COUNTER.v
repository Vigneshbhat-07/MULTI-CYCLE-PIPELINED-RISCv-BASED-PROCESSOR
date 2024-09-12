module PROGRAM_COUNTER(
    input clk,
    input reset,
    input [6:0] OPCODE,
    output reg [4:0] prog_addr
);

    always @(posedge clk or posedge reset) begin
        if (reset)
            prog_addr <= 5'b00000;            // Reset program counter to 0
        else if (OPCODE == 7'b1010101)        // HALT, hold the current program counter
            prog_addr <= prog_addr;
        else
            prog_addr <= prog_addr + 1;       // Increment program counter
    end

endmodule
