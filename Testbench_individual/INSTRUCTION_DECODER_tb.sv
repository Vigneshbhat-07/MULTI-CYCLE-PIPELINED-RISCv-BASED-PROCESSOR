`timescale 1ns/1ps

module INSTRUCTION_DECODER_tb;

  // Testbench Signals
  reg clk;
  reg [31:0] instruction;
  wire [6:0] OPCODE;
  wire [6:0] FUNC7;
  wire [2:0] FUNC3;
  wire [4:0] RS1;
  wire [4:0] RS2;
  wire [4:0] RD;
  wire [19:0] INP;

  // Instantiate the INSTRUCTION_DECODER module
  INSTRUCTION_DECODER uut (
    .clk(clk),
    .instruction(instruction),
    .OPCODE(OPCODE),
    .FUNC7(FUNC7),
    .FUNC3(FUNC3),
    .RS1(RS1),
    .RS2(RS2),
    .RD(RD),
    .INP(INP)
  );

  // Clock generation: Toggle every 5ns to get a period of 10ns
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    instruction = 32'b0;  // Initialize instruction to zero
    
    // Monitor the values of the signals
    $monitor("Time = %0t | Instruction = %b | OPCODE = %b | FUNC7 = %b | FUNC3 = %b | RS1 = %b | RS2 = %b | RD = %b | INP = %b", 
             $time, instruction, OPCODE, FUNC7, FUNC3, RS1, RS2, RD, INP);

    // Apply different instructions to the decoder and check outputs
    #10 instruction = 32'b0000000_01001_01000_000_00001_0110011;  // R-Type: ADD R1, R8, R9
    // Expect: FUNC7 = 0000000, RS2 = 01001, RS1 = 01000, FUNC3 = 000, RD = 00001, OPCODE = 0110011, INP = 0000000_01001_01000_0000

    #10 instruction = 32'b0100000_01001_01000_000_00010_0110011;  // R-Type: SUB R2, R8, R9
    // Expect: FUNC7 = 0100000, RS2 = 01001, RS1 = 01000, FUNC3 = 000, RD = 00010, OPCODE = 0110011, INP = 0100000_01001_01000_0000

    #10 instruction = 32'b0000000_00000_00000_001_01000_1111111;  // U-Type: LOAD_IMM R8, #1
    // Expect: FUNC7 = 0000000, RS2 = 00000, RS1 = 00000, FUNC3 = 001, RD = 01000, OPCODE = 1111111, INP = 0000000_00000_00000

    #10 instruction = 32'b0000000_01001_01000_110_00011_0110011;  // R-Type: AND R3, R8, R9
    // Expect: FUNC7 = 0000000, RS2 = 01001, RS1 = 01000, FUNC3 = 110, RD = 00011, OPCODE = 0110011, INP = 0000000_01001_01000_0000

    #10 instruction = 32'b0000000_00000_00000_000_00000_1010101;  // HALT
    // Expect: FUNC7 = 0000000, RS2 = 00000, RS1 = 00000, FUNC3 = 000, RD = 00000, OPCODE = 1010101, INP = 0000000_00000_00000

    // Apply a few more custom instructions to further verify decoding
    #10 instruction = 32'b1000000_01111_01010_101_00101_1101011;  // Custom R-Type instruction
    // Expect: FUNC7 = 1000000, RS2 = 01111, RS1 = 01010, FUNC3 = 101, RD = 00101, OPCODE = 1101011, INP = 1000000_01111_01010_0000

    // Stop the simulation
    #10 $finish;
  end

endmodule
