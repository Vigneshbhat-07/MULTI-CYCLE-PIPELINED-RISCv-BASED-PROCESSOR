`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:56:21 09/03/2024 
// Design Name: 
// Module Name:    CA_project 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module CA_PROJECT(
    input wire clk,
    input wire reset,
    output wire [31:0] value
);
    wire [4:0] prog_addr_wire, RS1_wire, RS2_wire, RD_wire, RD_out_wire;
    wire [31:0] instruction_wire, OP1_wire, OP2_wire, OUT_wire, Data_In_RF_wire;
    wire [6:0] OPCODE_wire, FUNC7_wire;
    wire [2:0] FUNC3_wire;
    wire [19:0] INP_wire;
    wire wr_en_RF_wire;

    PROGRAM_COUNTER PC (
        .clk(clk),
        .reset(reset),
        .OPCODE(OPCODE_wire),
        .prog_addr(prog_addr_wire)
    );

    PROGRAM_MEMORY PM (
        .clk(clk),
        .reset(reset),
        .prog_addr(prog_addr_wire),
        .instruction(instruction_wire)
    );

    INSTRUCTION_DECODER ID (
        .clk(clk),
        .instruction(instruction_wire),
        .OPCODE(OPCODE_wire),
        .FUNC7(FUNC7_wire),
        .FUNC3(FUNC3_wire),
        .RS1(RS1_wire),
        .RS2(RS2_wire),
        .RD(RD_wire),
        .INP(INP_wire)
    );

    REGISTER_FILE RF (
        .clk(clk),
        .RS1(RS1_wire),
        .RS2(RS2_wire),
        .RD(RD_wire),
        .wr_en_RF(wr_en_RF_wire),
        .Data_In_RF(Data_In_RF_wire),
        .OP1(OP1_wire),
        .OP2(OP2_wire)
    );

    ALU alu1 (
        .clk(clk),
        .OPCODE(OPCODE_wire),
        .FUNC7(FUNC7_wire), 
        .FUNC3(FUNC3_wire),
        .OP1(OP1_wire),
        .OP2(OP2_wire),
        .OUT(OUT_wire)
    );

    LOAD_NOP LN (
        .OPCODE(OPCODE_wire),
        .INP(INP_wire),
        .ALU_OUT(OUT_wire),
        .wr_en_RF(wr_en_RF_wire),
        .Data_In_RF(Data_In_RF_wire)
    );

    assign value = OUT_wire;

endmodule

module PROGRAM_COUNTER(
    input clk,
    input reset,
    input [6:0] OPCODE,
    output reg [4:0] prog_addr
);
    always @(posedge clk) begin
        if (reset)
            prog_addr <= 5'b0;
        else if (OPCODE == 7'b1010101)  // HALT
            prog_addr <= prog_addr;
        else
            prog_addr <= prog_addr + 1'b1;  // Increment program address by 1
    end
endmodule

module PROGRAM_MEMORY(
    input clk,
    input reset,
    input [4:0] prog_addr,
    output wire [31:0] instruction
);
    reg [31:0] PROG_MEM[0:31];

    always @(posedge clk) begin
        if (reset) begin
            PROG_MEM[0] <= {20'd1, 5'b01000, 7'b1111111};
            PROG_MEM[1] <= {20'd4, 5'b01001, 7'b1111111};
            PROG_MEM[2] <= {7'b0, 5'b01001, 5'b01000, 3'b0, 5'b00110, 7'b0110011};
        end else
            PROG_MEM[prog_addr] <= PROG_MEM[prog_addr];
    end

    assign instruction = PROG_MEM[prog_addr];
endmodule

module INSTRUCTION_DECODER(
    input clk,
    input [31:0] instruction,
    output reg [6:0] OPCODE,
    output reg [6:0] FUNC7,
    output reg [2:0] FUNC3,
    output reg [4:0] RS1,
    output reg [4:0] RS2,
    output reg [4:0] RD,
    output reg [19:0] INP
);
    always @(posedge clk) begin
        FUNC7 <= instruction[31:25];
        RS2 <= instruction[24:20];
        RS1 <= instruction[19:15];
        FUNC3 <= instruction[14:12];
        RD <= instruction[11:7];
        OPCODE <= instruction[6:0];
        INP <= instruction[31:12];
    end
endmodule

module REGISTER_FILE(
    input clk,
    input [4:0] RS1,
    input [4:0] RS2,
    input [4:0] RD, 
    input wr_en_RF,
    input [31:0] Data_In_RF,
    output reg [31:0] OP1,
    output reg [31:0] OP2
);
    reg [31:0] Register_Set[0:31];

    always @(*) begin
        OP1 <= Register_Set[RS1];  // OP1 is value at RS1 location of Register_Set block
        OP2 <= Register_Set[RS2];  // OP2 is value at RS2 location of Register_Set block
    end

    always @(posedge clk) begin
        if (wr_en_RF)
            Register_Set[RD] <= Data_In_RF;  // Writing into the RD location
        else
            Register_Set[RD] <= Register_Set[RD];
    end
endmodule

module ALU(
    input clk,
    input [6:0] OPCODE,
    input [31:0] OP1,
    input [31:0] OP2,
    input [6:0] FUNC7,
    input [2:0] FUNC3,
    output reg [31:0] OUT
);
    always @(posedge clk) begin
        case ({FUNC7, FUNC3, OPCODE})
            17'b0000000_000_0110011: OUT <= OP1 + OP2;  // ADD
            17'b0100000_000_0110011: OUT <= OP1 - OP2;  // SUB
            17'b0000000_110_0110011: OUT <= OP1 & OP2;  // AND
            17'b0000000_111_0110011: OUT <= OP1 | OP2;  // OR
            17'b0000000_100_0110011: OUT <= OP1 ^ OP2;  // XOR
            default: OUT <= 32'b0;  // NO_OPERATION
        endcase
    end
endmodule

module LOAD_NOP(
    input [6:0] OPCODE,
    input [19:0] INP,
    input [31:0] ALU_OUT,
    output reg wr_en_RF,
    output reg [31:0] Data_In_RF
);
    always @(*) begin
        if (OPCODE == 7'b1111111) begin  // LOAD_IMMEDIATE
            Data_In_RF = {12'b0, INP};
            wr_en_RF = 1'b1;
        end else if (OPCODE == 7'b0000000) begin  // NO_OPERATION
            Data_In_RF = Data_In_RF;
            wr_en_RF = 1'b0;
        end else begin
            Data_In_RF = ALU_OUT;
            wr_en_RF = 1'b1;
        end
    end
endmodule
