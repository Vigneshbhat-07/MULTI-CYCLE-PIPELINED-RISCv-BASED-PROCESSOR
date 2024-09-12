// ALU module to handle basic arithmetic and logic operations
module ALU(
    input clk,
    input [6:0] OPCODE,
    input [31:0] OP1,
    input [31:0] OP2,
    input [6:0] FUNC7,
    input [2:0] FUNC3,
    output reg [31:0] OUT
);
    
    // Perform ALU operations based on OPCODE, FUNC7, and FUNC3
    always @(posedge clk) 
    begin
        case({FUNC7, FUNC3, OPCODE})
            17'b0000000_000_0110011: OUT <= OP1 + OP2; // ADD Operation
            17'b0100000_000_0110011: OUT <= OP1 - OP2; // SUB Operation
            17'b0000000_110_0110011: OUT <= OP1 & OP2; // AND Operation
            17'b0000000_111_0110011: OUT <= OP1 | OP2; // OR Operation
            17'b0000000_100_0110011: OUT <= OP1 ^ OP2; // XOR Operation
            default: OUT <= 32'b0; // Default Case
        endcase
    end
    
endmodule
