`include "../DESIGN/TOP_MODULE.v"

module Testbench;

    // Inputs to the Unit Under Test (UUT)
    reg clk;              // Clock signal
    reg reset;            // Reset signal

    // Outputs from the Unit Under Test (UUT)
    wire [31:0] Out_value; // 32-bit output value from the UUT

    // Instantiate the Unit Under Test (UUT)
    CA_PROJECT uut (
        .clk(clk), 
        .reset(reset), 
        .Out_value(Out_value)
    );
    
    // Clock generation block
    initial begin 
        clk = 1'b1;             // Initialize clock signal to high (1)
        forever #5 clk = ~clk;  // Toggle the clock signal every 5 time units
    end

    // Testbench initialization and stimulus block
    initial begin
        // Initialize Inputs
        reset = 1;              // Assert the reset signal (active high)
        #15;                    // Wait for 15 time units
        reset = 0;              // Deassert the reset signal

        #200;                   // Wait for 200 more time units to observe behavior
        
        // End the simulation
        $finish;
    end

endmodule
