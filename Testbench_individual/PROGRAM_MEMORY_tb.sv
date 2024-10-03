`timescale 1ns/1ps

module PROGRAM_MEMORY_tb;

  // Testbench Signals
  reg clk;
  reg reset;
  reg [4:0] prog_addr;
  wire [31:0] instruction;
  
  // Instantiate the PROGRAM_MEMORY module
  PROGRAM_MEMORY uut (
    .clk(clk),
    .reset(reset),
    .prog_addr(prog_addr),
    .instruction(instruction)
  );

  // Clock generation: Toggle every 5ns to get a period of 10ns
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    reset = 1;  // Start with reset active
    prog_addr = 0;
    
    // Monitor the values of the signals
    $monitor("Time = %0t | Reset = %b | Prog Addr = %0d | Instruction = %b", $time, reset, prog_addr, instruction);

    // Hold reset for a few cycles
    #10 reset = 0;  // Deactivate reset

    // Test program addresses one by one
    #10 prog_addr = 0;  // Expect: 0000000_00000_00000_001_01000_1111111
    #10 prog_addr = 1;  // Expect: 0000000_00000_00000_100_01001_1111111
    #10 prog_addr = 2;  // Expect: 0000000_00000_00000_000_00000_0000000
    #10 prog_addr = 3;  // Expect: 0000000_01001_01000_000_00001_0110011
    #10 prog_addr = 4;  // Expect: 0100000_01001_01000_000_00010_0110011
    #10 prog_addr = 5;  // Expect: 0000000_01001_01000_110_00011_0110011
    #10 prog_addr = 6;  // Expect: 0000000_01001_01000_111_00100_0110011
    #10 prog_addr = 7;  // Expect: 0000000_01001_01000_100_00101_0110011
    #10 prog_addr = 8;  // Expect: 0000000_00000_00000_000_00000_1010101
    #10 prog_addr = 9;  // Expect: 0000000_00000_00000_000_00000_1010101

    // Stop the simulation
    #10 $finish;
  end

endmodule
