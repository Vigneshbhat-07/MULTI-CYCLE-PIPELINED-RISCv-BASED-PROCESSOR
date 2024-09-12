`timescale 1ns / 1ps

module Testbench;

    // Inputs to the Unit Under Test (UUT)
    reg clk;            // Clock signal
    reg reset;          // Reset signal

    // Outputs from the Unit Under Test (UUT)
    wire [31:0] Out_value; // 32-bit output value from UUT

    // Instantiate the Unit Under Test (UUT)
    CA_PROJECT uut (
        .clk(clk), 
        .reset(reset), 
        .Out_value(Out_value)
    );

    // Clock generation block
    // This block generates a clock signal with a period of 10 ns (frequency of 100 MHz)
    initial begin 
        clk = 1'b1;         // Initialize clock to high
        forever #5 clk = ~clk; // Toggle clock every 5 ns
    end

    // Testbench initialization and stimulus
    initial begin
        // Initialize Inputs
        reset = 1;         // Assert reset signal
        #15;               // Wait for 15 ns
        reset = 0;         // Deassert reset signal

        // Wait for 300 ns to observe the behavior of the UUT after reset
        #300;

        // End the simulation
        $finish;
    end

endmodule

