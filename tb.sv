`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:37:17 09/03/2024
// Design Name:   CA_PROJECT
// Module Name:   /home/ise/Projects/CA_project/CA_project/Testbench.v
// Project Name:  CA_project
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: CA_PROJECT
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module Testbench;

  // Inputs
  reg clk;
  reg reset;

  // Outputs
  wire [31:0] Out_value;

  // Instantiate the Unit Under Test (UUT)
  CA_PROJECT uut (
    .clk(clk), 
    .reset(reset), 
    .Out_value(Out_value)
  );

    initial begin 
    clk = 1'b1;
    forever #5 clk = ~clk;
    end

  initial begin
    // Initialize Inputs
    reset = 1;
    #15;
    reset = 0;
    // Wait 100 ns for global reset to finish
    #300;

    // Add stimulus here
    $finish;
  end

endmodule

 
