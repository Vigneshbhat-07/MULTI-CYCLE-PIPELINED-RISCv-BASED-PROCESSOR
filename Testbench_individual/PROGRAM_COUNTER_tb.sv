`timescale 1ns/1ps

module PROGRAM_COUNTER_tb;

  // Testbench Signals
  reg clk;
  reg reset;
  reg [6:0] OPCODE;
  wire [4:0] prog_addr;

  // Instantiate the PROGRAM_COUNTER module
  PROGRAM_COUNTER uut (
    .clk(clk),
    .reset(reset),
    .OPCODE(OPCODE),
    .prog_addr(prog_addr)
  );

  // Clock generation: Toggle every 5ns for a period of 10ns
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    reset = 1;  // Start with reset active
    OPCODE = 7'b0000000;

    // Monitor the values of the signals
    $monitor("Time = %0t | Reset = %b | OPCODE = %b | Program Counter = %0d", $time, reset, OPCODE, prog_addr);

    // Hold reset for a few cycles and then release it
    #10 reset = 0;  // Deactivate reset

    // Normal Operation: Increment program counter
    #10 OPCODE = 7'b0000000;  // Expect prog_addr to increment from 0 to 1
    #10 OPCODE = 7'b0000000;  // Expect prog_addr to increment from 1 to 2
    #10 OPCODE = 7'b0000000;  // Expect prog_addr to increment from 2 to 3

    // HALT Operation: Hold program counter at current value
    #10 OPCODE = 7'b1010101;  // Expect prog_addr to hold at 3
    #10 OPCODE = 7'b1010101;  // Expect prog_addr to hold at 3

    // Resume Normal Operation: Increment program counter again
    #10 OPCODE = 7'b0000000;  // Expect prog_addr to increment from 3 to 4
    #10 OPCODE = 7'b0000000;  // Expect prog_addr to increment from 4 to 5

    // Apply reset again
    #10 reset = 1;  // Reset should set prog_addr back to 0
    #10 reset = 0;  // Deactivate reset

    // Verify normal operation after reset
    #10 OPCODE = 7'b0000000;  // Expect prog_addr to increment from 0 to 1
    #10 OPCODE = 7'b0000000;  // Expect prog_addr to increment from 1 to 2

    // Stop the simulation
    #10 $finish;
  end

endmodule
