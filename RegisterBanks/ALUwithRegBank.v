module FlagsRegister(clk, reset, update, Z_in, C_in, V_in, S_in, Z, C, V, S);

  input clk, reset, update, Z_in, C_in, V_in, S_in;
  output reg Z,C,V,S;
  
  always @(posedge clk or posedge reset) begin
    if (reset) begin
      Z <= 0;
      C <= 0;
      V <= 0;
      S <= 0;
    end else if (update) begin
      Z <= Z_in;
      C <= C_in;
      V <= V_in;
      S <= S_in;
    end
  end
endmodule

/////////////////////////////////////////////////////////////

module ALU(a, b, opcode, out, Z, C, V, S);
  input [7:0] a, b;
  input [3:0] opcode;
  output reg [7:0] out;
  output Z, C, V, S;
  
  reg [7:0] result;
  wire carry_out;

  always @(a or b or opcode) begin
    case(opcode)
      4'b0000 : result = a;              
      4'b0001 : result = a - 1;         
      4'b0010 : result = a + 1;          
      4'b0011 : result = b;              
      4'b0100 : result = b - 1;          
      4'b0101 : result = b + 1;          
      4'b0110 : result = a + b;          
      4'b0111 : result = a - b;          
      4'b1000 : result = a & b;          
      4'b1001 : result = ~(a & b);      
      4'b1010 : result = a | b;          
      4'b1011 : result = ~(a | b);       
      4'b1100 : result = a ^ b;         
      4'b1101 : result = ~(a ^ b);         
      4'b1110 : result = ~a;             
      4'b1111 : result = ~b;             
      default: result = 8'b00000000;   
    endcase
  end
  
  assign out = result;
  
  assign Z = (result == 8'b0);
  assign C = carry_out; 
  assign V = (a[7] & b[7] & ~result[7]) | (~a[7] & ~b[7] & result[7]);
  assign carry_out = (opcode == 4'b0110) ? (a + b > 8'b11111111) :
                     (opcode == 4'b0111) ? (a - b < 8'b0) : 0; 
endmodule
