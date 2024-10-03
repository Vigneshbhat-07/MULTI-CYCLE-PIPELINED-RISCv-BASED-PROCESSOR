`timescale 1ns/1ps

module ALU_tb;

  // Testbench signals
  reg clk;                          // Clock signal
  reg [6:0] OPCODE;                 // Opcode input for the ALU
  reg [31:0] OP1, OP2;              // Operands for the ALU operations
  reg [6:0] FUNC7;                  // Function 7-bit field
  reg [2:0] FUNC3;                  // Function 3-bit field
  wire [31:0] OUT;                  // Output from the ALU

  // Instantiate the ALU module
  ALU uut (
    .clk(clk),
    .OPCODE(OPCODE),
    .OP1(OP1),
    .OP2(OP2),
    .FUNC7(FUNC7),
    .FUNC3(FUNC3),
    .OUT(OUT)
  );

  // Clock generation: Toggle every 5ns for a period of 10ns
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    OPCODE = 7'b0;
    OP1 = 32'b0;
    OP2 = 32'b0;
    FUNC7 = 7'b0;
    FUNC3 = 3'b0;

    // Monitor the values of the signals
    $monitor("Time = %0t | OPCODE = %b | FUNC7 = %b | FUNC3 = %b | OP1 = %h | OP2 = %h | OUT = %h",
             $time, OPCODE, FUNC7, FUNC3, OP1, OP2, OUT);

    // Test ADD Operation
    OP1 = 32'd10;                     // Set OP1 to 10
    OP2 = 32'd20;                     // Set OP2 to 20
    OPCODE = 7'b0110011;              // R-type ALU operation
    FUNC7 = 7'b0000000;               // FUNC7 for ADD
    FUNC3 = 3'b000;                   // FUNC3 for ADD
    #10;                              // Wait for 10ns, expect OUT = 30 (10 + 20)

    // Test SUB Operation
    FUNC7 = 7'b0100000;               // FUNC7 for SUB
    FUNC3 = 3'b000;                   // FUNC3 for SUB
    #10;                              // Wait for 10ns, expect OUT = -10 (10 - 20)

    // Test AND Operation
    FUNC7 = 7'b0000000;               // FUNC7 for AND
    FUNC3 = 3'b110;                   // FUNC3 for AND
    OP1 = 32'hFF00FF00;               // Set OP1 to 0xFF00FF00
    OP2 = 32'h0FF00FF0;               // Set OP2 to 0x0FF00FF0
    #10;                              // Wait for 10ns, expect OUT = 0x0F000F00 (bitwise AND)

    // Test OR Operation
    FUNC3 = 3'b111;                   // FUNC3 for OR
    #10;                              // Wait for 10ns, expect OUT = 0xFF00FFF0 (bitwise OR)

    // Test XOR Operation
    FUNC3 = 3'b100;                   // FUNC3 for XOR
    #10;                              // Wait for 10ns, expect OUT = 0xF0F00FF0 (bitwise XOR)

    // Test Default Case
    FUNC7 = 7'b1111111;               // Set to an unsupported FUNC7
    FUNC3 = 3'b111;                   // Set to an unsupported FUNC3
    OPCODE = 7'b0000000;              // Unsupported opcode
    #10;                              // Wait for 10ns, expect OUT = 0 (default case)

    // End simulation
    $finish;
  end

endmodule
