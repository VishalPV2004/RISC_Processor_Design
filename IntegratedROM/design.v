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
//------------------------------------------------->logic for condition flag
reg sign = 0, zero = 0, overflow = 0, carry = 0;
reg [16:0] temp_sum;
 
always@(*)
begin
 
//------------------------------------------------->sign bit
if(`oper_type == `mul)
  sign = SGPR[15];
else
  sign = GPR[`rdst][15];
 
//------------------------------------------------->carry bit
 
if(`oper_type == `add)
   begin
      if(`imm_mode)
         begin
         temp_sum = GPR[`rsrc1] + `isrc;
         carry    = temp_sum[16]; 
         end
      else
         begin
         temp_sum = GPR[`rsrc1] + GPR[`rsrc2];
         carry    = temp_sum[16]; 
         end   end
   else
    begin
        carry  = 1'b0;
    end
 
//-------------------------------------------------> zero bit
if(`oper_type == `mul)
  zero =  ~((|SGPR[15:0]) | (|GPR[`rdst]));
else
  zero =  ~(|GPR[`rdst]); 
 
 
//------------------------------------------------->overflow bit
 
if(`oper_type == `add)
     begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & ~IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & GPR[`rsrc2][15] & ~GPR[`rdst][15]));
     end
  else if(`oper_type == `sub)
    begin
       if(`imm_mode)
         overflow = ( (~GPR[`rsrc1][15] & IR[15] & GPR[`rdst][15] ) | (GPR[`rsrc1][15] & ~IR[15] & ~GPR[`rdst][15]) );
       else
         overflow = ( (~GPR[`rsrc1][15] & GPR[`rsrc2][15] & GPR[`rdst][15]) | (GPR[`rsrc1][15] & ~GPR[`rsrc2][15] & ~GPR[`rdst][15]));
    end 
  else
     begin
     overflow = 1'b0;
     end
 
end
 
//Feeding program to processor
initial begin
$readmemb("data.mem",inst_mem);
end
 

reg [2:0] count = 0;
integer PC = 0;
 
always@(posedge clk)
begin
  if(sys_rst)
   begin
     count <= 0;
     PC    <= 0;
   end
   else 
   begin
     if(count < 4)
     begin
     count <= count + 1;
     end
     else
     begin
     count <= 0;
     PC    <= PC + 1;
     end
 end
end

always@(*)
begin
if(sys_rst == 1'b1)
IR = 0;
else
begin
IR = inst_mem[PC];
decode_inst();
decode_condflag();
end
end
  
 
endmodule