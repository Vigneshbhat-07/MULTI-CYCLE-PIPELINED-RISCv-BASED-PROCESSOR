`include "../DESIGN/CA_PROJECT.v"

module CA_PROJECT_tb;

  // Signals for the top-level module
  reg clk;                      // Clock signal
  reg reset;                    // Reset signal
  wire [31:0] Out_value;        // Output value from the ALU

  // Instantiate the CA_PROJECT module (Unit Under Test)
  CA_PROJECT uut (
    .clk(clk),
    .reset(reset),
    .Out_value(Out_value)
  );

  // Clock generation: Toggle every 5ns to create a 10ns period clock
  always #5 clk = ~clk;

  // Initialize and run the test
  initial begin
    // Initialize the signals
    clk = 0;
    reset = 1;                  // Apply reset initially

    // Display header for monitoring
    $display("Time\t\treset\tOut_value");

    // Monitor the key signals
    $monitor("%0t\t%b\t%h", $time, reset, Out_value);

    // Apply reset for 20ns, then release reset
    #15 reset = 0;              // De-assert reset signal after 15ns

    // Wait and observe the behavior for some time
    #100;

    // Finish the simulation
    $finish;
  end

endmodule
