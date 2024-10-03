`timescale 1ns/1ps

module REGISTER_FILE_tb;

  // Testbench Signals
  reg clk;
  reg [4:0] RS1, RS2, RD;           // Register addresses for source and destination
  reg wr_en_RF;                     // Write enable signal
  reg [31:0] Data_In_RF;            // Data to write to the register file
  wire [31:0] OP1, OP2;             // Outputs representing values at RS1 and RS2

  // Instantiate the REGISTER_FILE module
  REGISTER_FILE uut (
    .clk(clk),
    .RS1(RS1),
    .RS2(RS2),
    .RD(RD),
    .wr_en_RF(wr_en_RF),
    .Data_In_RF(Data_In_RF),
    .OP1(OP1),
    .OP2(OP2)
  );

  // Clock generation: Toggle every 5ns for a period of 10ns
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    RS1 = 0;
    RS2 = 0;
    RD = 0;
    wr_en_RF = 0;
    Data_In_RF = 32'b0;

    // Monitor the values of the signals
    $monitor("Time = %0t | RS1 = %d | RS2 = %d | RD = %d | wr_en_RF = %b | Data_In_RF = %h | OP1 = %h | OP2 = %h", 
             $time, RS1, RS2, RD, wr_en_RF, Data_In_RF, OP1, OP2);

    // Initial Reset: No operation
    #10;

    // Write to register R1
    wr_en_RF = 1;
    RD = 5'd1;              // Destination register R1
    Data_In_RF = 32'hAAAA_AAAA;  // Data to write
    #10;

    // Write to register R2
    RD = 5'd2;              // Destination register R2
    Data_In_RF = 32'hBBBB_BBBB;  // Data to write
    #10;

    // Write to register R3
    RD = 5'd3;              // Destination register R3
    Data_In_RF = 32'hCCCC_CCCC;  // Data to write
    #10;

    // Disable write and verify no changes occur
    wr_en_RF = 0;
    RD = 5'd4;              // Set RD to another register
    Data_In_RF = 32'hDDDD_DDDD;  // New data
    #10;                    // No data should be written to R4 since wr_en_RF is low

    // Read from registers R1 and R2
    RS1 = 5'd1;             // Read from R1 (Expect: 0xAAAA_AAAA)
    RS2 = 5'd2;             // Read from R2 (Expect: 0xBBBB_BBBB)
    #10;

    // Read from registers R2 and R3
    RS1 = 5'd2;             // Read from R2 (Expect: 0xBBBB_BBBB)
    RS2 = 5'd3;             // Read from R3 (Expect: 0xCCCC_CCCC)
    #10;

    // Attempt to write to register R0 (should have no effect)
    wr_en_RF = 1;
    RD = 5'd0;              // Destination register R0 (special case)
    Data_In_RF = 32'hEEEE_EEEE;  // New data
    #10;                    // No data should be written to R0

    // Read from R0 and R3 to verify no changes to R0
    RS1 = 5'd0;             // Read from R0 (Expect: 0x0000_0000, as R0 should always hold zero)
    RS2 = 5'd3;             // Read from R3 (Expect: 0xCCCC_CCCC)
    #10;

    // Write to R4 and read back
    wr_en_RF = 1;
    RD = 5'd4;              // Destination register R4
    Data_In_RF = 32'hDDDD_DDDD;  // Data to write
    #10;

    RS1 = 5'd4;             // Read from R4 (Expect: 0xDDDD_DDDD)
    RS2 = 5'd1;             // Read from R1 (Expect: 0xAAAA_AAAA)
    #10;

    // Stop the simulation
    $finish;
  end

endmodule
