`timescale 1ns / 1ps

///////////fields of IR
`define oper_type IR[31:27]
`define rdst      IR[26:22]
`define rsrc1     IR[21:17]
`define imm_mode  IR[16]
`define rsrc2     IR[15:11]
`define isrc      IR[15:0]

////////////////arithmetic operation
`define movsgpr        5'b00000
`define mov            5'b00001
`define add            5'b00010
`define sub            5'b00011
`define mul            5'b00100

////////////////logical operations : and or xor xnor nand nor not
`define ror            5'b00101
`define rand           5'b00110
`define rxor           5'b00111
`define rxnor          5'b01000
`define rnand          5'b01001
`define rnor           5'b01010
`define rnot           5'b01011

module top();

reg [31:0] IR;           // Instruction register
                          // Fields: <---  oper  --><--   rdest --><--   rsrc1 --><--modesel--><--  immediate_date      -->

reg [15:0] GPR [31:0];    // General purpose registers: GPR[0] ....... GPR[31]
reg [15:0] SGPR;          // Special purpose register for MSB of multiplication
reg [31:0] mul_res;

always @(*) begin
    case (`oper_type)

        // Move contents of SGPR to DST REG
        `movsgpr: begin
            GPR[`rdst] = SGPR;
        end

        // MOV Instruction
        `mov: begin
            if (`imm_mode)
                GPR[`rdst] = `isrc;
            else
                GPR[`rdst] = GPR[`rsrc1];
        end

        // ADDITION
        `add: begin
            if (`imm_mode)
                GPR[`rdst] = GPR[`rsrc1] + `isrc;
            else
                GPR[`rdst] = GPR[`rsrc1] + GPR[`rsrc2];
        end

        // SUBTRACTION
        `sub: begin
            if (`imm_mode)
                GPR[`rdst] = GPR[`rsrc1] - `isrc;
            else
                GPR[`rdst] = GPR[`rsrc1] - GPR[`rsrc2];
        end

        // MULTIPLICATION
        `mul: begin
            if (`imm_mode)
                mul_res = GPR[`rsrc1] * `isrc;
            else
                mul_res = GPR[`rsrc1] * GPR[`rsrc2];
                
            GPR[`rdst] = mul_res[15:0];
            SGPR = mul_res[31:16];
        end

        // BITWISE OR
        `ror: begin
            if (`imm_mode)
                GPR[`rdst] = GPR[`rsrc1] | `isrc;
            else
                GPR[`rdst] = GPR[`rsrc1] | GPR[`rsrc2];
        end

        // BITWISE AND
        `rand: begin
            if (`imm_mode)
                GPR[`rdst] = GPR[`rsrc1] & `isrc;
            else
                GPR[`rdst] = GPR[`rsrc1] & GPR[`rsrc2];
        end

        // BITWISE XOR
        `rxor: begin
            if (`imm_mode)
                GPR[`rdst] = GPR[`rsrc1] ^ `isrc;
            else
                GPR[`rdst] = GPR[`rsrc1] ^ GPR[`rsrc2];
        end

        // BITWISE XNOR
        `rxnor: begin
            if (`imm_mode)
                GPR[`rdst] = GPR[`rsrc1] ~^ `isrc;
            else
                GPR[`rdst] = GPR[`rsrc1] ~^ GPR[`rsrc2];
        end

        // BITWISE NAND
        `rnand: begin
            if (`imm_mode)
                GPR[`rdst] = ~(GPR[`rsrc1] & `isrc);
            else
                GPR[`rdst] = ~(GPR[`rsrc1] & GPR[`rsrc2]);
        end

        // BITWISE NOR
        `rnor: begin
            if (`imm_mode)
                GPR[`rdst] = ~(GPR[`rsrc1] | `isrc);
            else
                GPR[`rdst] = ~(GPR[`rsrc1] | GPR[`rsrc2]);
        end

        // BITWISE NOT
        `rnot: begin
            if (`imm_mode)
                GPR[`rdst] = ~(`isrc);
            else
                GPR[`rdst] = ~(GPR[`rsrc1]);
        end

        default: begin
            GPR[`rdst] = 16'b0; // Default behavior
        end

    endcase
end

endmodule
