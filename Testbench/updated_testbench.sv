`include "../DESIGN/TOP_MODULE.v"

module Testbench;

    // Inputs to the Unit Under Test (UUT)
    reg clk;               // Clock signal
    reg reset;             // Reset signal
    reg [4:0] prog_addr;   // Program address to fetch instruction

    // Outputs from the Unit Under Test (UUT)
    wire [31:0] Out_value; // 32-bit output value from the UUT

    // Declare expected output and instruction
    reg [31:0] expected_value;
    reg [31:0] instruction;

    // Register file to simulate the register values
    reg [31:0] regfile [0:31];

    // Instantiate the Unit Under Test (UUT)
    CA_PROJECT uut (
        .clk(clk), 
        .reset(reset), 
        .Out_value(Out_value)
    );
    
    // Instantiate program memory
    PROGRAM_MEMORY prog_mem (
        .clk(clk),
        .reset(reset),
        .prog_addr(prog_addr),
        .instruction(instruction)
    );
    
    // Clock generation block
    initial begin 
        clk = 1'b1;             // Initialize clock signal to high (1)
        forever #5 clk = ~clk;  // Toggle the clock signal every 5 time units
    end

    // Task to check the output against the expected value
    task check_output;
        input [31:0] expected;
        input [31:0] actual;
        begin
            if (expected !== actual) begin
                $display("Error at time %t: Expected = %h, Actual = %h", $time, expected, actual);
            end else begin
                $display("Success at time %t: Output matches expected value = %h", $time, actual);
            end
        end
    endtask

    // Task to decode and execute the instruction
    task execute_instruction;
        input [31:0] instr;  // The instruction passed to the task
        reg [6:0] opcode;
        reg [4:0] rd, rs1, rs2;
        reg [2:0] func3;
        reg [6:0] func7;
        begin
            opcode = instr[6:0];      // Extract opcode from instruction
            rd = instr[11:7];         // Extract destination register
            func3 = instr[14:12];     // Extract func3 field
            rs1 = instr[19:15];       // Extract source register 1
            rs2 = instr[24:20];       // Extract source register 2
            func7 = instr[31:25];     // Extract func7 field

            case(opcode)
                7'b0110011: begin // R-type instructions (ADD, SUB, AND, OR, XOR)
                    case(func3)
                        3'b000: begin // ADD or SUB
                            if (func7 == 7'b0000000) begin
                                expected_value = regfile[rs1] + regfile[rs2]; // ADD
                                $display("Executing ADD R%d, R%d, R%d", rd, rs1, rs2);
                            end else if (func7 == 7'b0100000) begin
                                expected_value = regfile[rs1] - regfile[rs2]; // SUB
                                $display("Executing SUB R%d, R%d, R%d", rd, rs1, rs2);
                            end
                        end
                        3'b110: begin // AND
                            expected_value = regfile[rs1] & regfile[rs2];
                            $display("Executing AND R%d, R%d, R%d", rd, rs1, rs2);
                        end
                        3'b111: begin // OR
                            expected_value = regfile[rs1] | regfile[rs2];
                            $display("Executing OR R%d, R%d, R%d", rd, rs1, rs2);
                        end
                        3'b100: begin // XOR
                            expected_value = regfile[rs1] ^ regfile[rs2];
                            $display("Executing XOR R%d, R%d, R%d", rd, rs1, rs2);
                        end
                        default: $display("Unknown instruction at time %t", $time);
                    endcase
                end

                default: $display("Unsupported instruction at time %t", $time);
            endcase
        end
    endtask

    // Testbench initialization and stimulus block
    initial begin
        // Initialize Inputs
        reset = 1;              // Assert the reset signal (active high)
        prog_addr = 0;           // Start program address at 0

        // Initialize register file with test values
        regfile[8] = 32'd1;     // R8 = 1
        regfile[9] = 32'd4;     // R9 = 4
        regfile[1] = 32'd0;     // R1 (destination) initialized to 0
        regfile[2] = 32'd0;     // R2 (destination) initialized to 0

        #15;                    // Wait for 15 time units
        reset = 0;              // Deassert the reset signal

        // Begin fetching and executing instructions from program memory
        repeat (10) begin
            #40;                // Wait for the instruction to be fetched
            execute_instruction(instruction); // Decode and execute the instruction
            check_output(expected_value, Out_value); // Compare actual and expected output
            prog_addr = prog_addr + 1; // Move to the next instruction
        end

        // End the simulation
        $finish;
    end

endmodule
