`timescale 1ns/1ps

module LOAD_BLOCK_tb;

  // Testbench Signals
  reg clk;                          // Clock signal
  reg [6:0] OPCODE;                 // Opcode from instruction decoder
  reg [19:0] INP;                   // 20-bit immediate value
  reg [31:0] ALU_OUT;               // 32-bit ALU output
  wire wr_en_RF;                    // Write enable signal for the register file
  wire [31:0] Data_In_RF;           // 32-bit data to be written to the register file

  // Instantiate the LOAD_BLOCK module
  LOAD_BLOCK uut (
    .clk(clk),
    .OPCODE(OPCODE),
    .INP(INP),
    .ALU_OUT(ALU_OUT),
    .wr_en_RF(wr_en_RF),
    .Data_In_RF(Data_In_RF)
  );

  // Clock generation: Toggle every 5ns for a period of 10ns
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    OPCODE = 7'b0000000;     // Start with NO_OPERATION
    INP = 20'b0;
    ALU_OUT = 32'b0;

    // Monitor the values of the signals
    $monitor("Time = %0t | OPCODE = %b | INP = %h | ALU_OUT = %h | wr_en_RF = %b | Data_In_RF = %h",
             $time, OPCODE, INP, ALU_OUT, wr_en_RF, Data_In_RF);

    // Initial Reset/No Operation: Expect wr_en_RF = 0 and Data_In_RF = 0
    #10;

    // Test LOAD_IMMEDIATE Operation
    INP = 20'hAAAAA;         // 20-bit immediate value
    OPCODE = 7'b1111111;     // Set LOAD_IMMEDIATE opcode
    #10;                     // Expect Data_In_RF = 0x000AAAAA and wr_en_RF = 1

    // Test NO_OPERATION
    OPCODE = 7'b0000000;     // Set NO_OPERATION opcode
    #10;                     // Expect Data_In_RF unchanged and wr_en_RF = 0

    // Test ALU_OPERATION
    ALU_OUT = 32'hABCD_1234; // ALU Output value
    OPCODE = 7'b0110011;     // Set ALU_OPERATION opcode
    #10;                     // Expect Data_In_RF = ALU_OUT and wr_en_RF = 1

    // Test unknown opcode
    OPCODE = 7'b1010101;     // Set an unsupported opcode
    #10;                     // Expect Data_In_RF = ALU_OUT and wr_en_RF = 0

    // Test another LOAD_IMMEDIATE with a different value
    INP = 20'h12345;         // 20-bit immediate value
    OPCODE = 7'b1111111;     // Set LOAD_IMMEDIATE opcode
    #10;                     // Expect Data_In_RF = 0x00012345 and wr_en_RF = 1

    // Stop the simulation
    $finish;
  end

endmodule
