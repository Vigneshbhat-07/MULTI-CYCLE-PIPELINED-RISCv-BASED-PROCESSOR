# CA_PROJECT: A Custom CPU Design

## Project Overview

This repository contains a Verilog-based implementation of a custom CPU architecture. The project aims to demonstrate basic CPU operations, including instruction fetching, decoding, register manipulation, and ALU computations. The CPU design is modular, making it easy to understand and extend for future enhancements.

## Micro-Architecture Overview

The following image provides an overview of the micro-architecture design for the project:

![Micro Architecture](https://github.com/ZishanManna/CA_PROJECT/blob/main/Documentation/CA_PROJECT%201_MICRO-ARCHITECTURE.jpg)

## Project Structure

### Modules in the Project
1. **PROGRAM_COUNTER**:
   - Controls the program flow by maintaining the current instruction address.
   - Can reset or hold the program counter value based on specific control signals (e.g., HALT).
![PROGRAM_COUNTER](https://github.com/ZishanManna/CA_PROJECT/blob/main/Documentation/counter_image.drawio.png)

2. **PROGRAM_MEMORY**:
   - Stores program instructions in a 32x32 memory block.
   - Fetches the instruction corresponding to the current program counter address.

![PROGRAM_MEMORY](https://github.com/ZishanManna/CA_PROJECT/blob/main/Documentation/memory.png)

3. **INSTRUCTION_DECODER**:
   - Decodes the 32-bit instruction into its component fields.
   - Extracts opcode, function codes, register addresses, and immediate values.
![INSTRUCTION_DECODER](https://github.com/ZishanManna/CA_PROJECT/blob/main/Documentation/instruction_decoder.drawio.png)

4. **REGISTER_FILE**:
   - Consists of 32 registers, each 32 bits wide.
   - Facilitates reading and writing operations based on control signals.
   - Provides operands to the ALU based on the decoded instruction.
![REGISTER_FILE](https://github.com/ZishanManna/CA_PROJECT/blob/main/Documentation/register_file.drawio.png)

5. **ALU (Arithmetic Logic Unit)**:
   - Performs basic arithmetic and logic operations like addition, subtraction, AND, OR, and XOR.
   - The operation is determined based on the function codes (FUNC3 and FUNC7) and the opcode.
![ALU (Arithmetic Logic Unit)](https://github.com/ZishanManna/CA_PROJECT/blob/main/Documentation/alu.drawio.png)

6. **LOAD_BLOCK**:
   - Handles `LOAD_IMM` and other data transfer instructions.
   - Updates register file contents based on the immediate values or ALU outputs.

![LOAD_BLOCK](https://github.com/ZishanManna/CA_PROJECT/blob/main/Documentation/load_block.drawio.png)

7. **CA_PROJECT (Top Module)**:
   - Integrates all submodules to create a complete CPU.
   - Manages the flow of data between the program counter, instruction memory, register file, ALU, and load block.
   - Outputs the result of the current instruction execution.

## Testbench

The project includes a comprehensive testbench (`CA_PROJECT_tb.sv`) that:

- Initializes the program counter and program memory with predefined instructions.
- Executes a series of instructions sequentially.
- Monitors key signals such as `prog_addr`, `instruction`, `OP1`, `OP2`, `OUT_value`, and `Data_In_RF`.
- Provides timing details for tracking internal signals.
- Generates waveform outputs that can be visually inspected for signal accuracy.

The testbench can be easily extended to include more test scenarios by modifying the initial instruction set and observing the outputs.

## Features

- **Modular Design**: Each component (e.g., Program Counter, ALU, Load Block) is implemented as an independent Verilog module, making it easy to maintain and expand.
- **Basic Instruction Set**: Supports a set of basic instructions, including:
  - `LOAD_IMM` – Load an immediate value into a register.
  - `ADD`, `SUB`, `AND`, `OR`, and `XOR` – Standard arithmetic and logic operations.
  - `NOP` (No Operation) – For pipelining or timing adjustment.
  - `HALT` – Stop the CPU's execution.
- **Configurable Memory and Register Set**: The memory and register sizes can be modified as needed to support more complex designs.
- **Easy Debugging**: The testbench and modular architecture facilitate quick debugging, allowing individual modules to be tested independently.

## Getting Started

### How to Use
1. Clone this repository to your local machine:
   ```bash
   git clone https://github.com/ZishanManna/CA_PROJECT.git
   ```
2. Navigate to the project directory:
    ```bash
    cd CA_PROJECT
    ```

3. Compile and run the simulation:
    ```bash
    vlog CA_PROJECT.v CA_PROJECT_tb.sv
    vsim CA_PROJECT_tb
    ```

4. Analyze the simulation results using the waveform viewer to verify the operation of the CPU.

