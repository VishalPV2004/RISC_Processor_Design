module Test_ALU_Flags;

  reg [7:0] a, b;
  reg [3:0] opcode;
  reg clk, reset, update;
  wire [7:0] out;  
  wire Z, C, V, S;
  wire Z_out, C_out, V_out, S_out;  

  ALU alu(.a(a), .b(b), .opcode(opcode), .out(out), .Z(Z), .C(C), .V(V), .S(S));

  FlagsRegister flags(.clk(clk), .reset(reset), .update(update),
                      .Z_in(Z), .C_in(C), .V_in(V), .S_in(S), 
                      .Z(Z_out), .C(C_out), .V(V_out), .S(S_out));

  always #5 clk = ~clk;

  initial begin
    clk = 0; reset = 1; update = 0; a = 0; b = 0; opcode = 0;

    #10 reset = 0;

    a = 8'b00000000; b = 8'b00000000; opcode = 4'b0110; update = 1;
    #10 update = 0;
    $display("ADD: Out=%b, Z=%b, C=%b, V=%b, S=%b", out, Z_out, C_out, V_out, S_out);

    a = 8'b00000101; b = 8'b00000011; opcode = 4'b0111; update = 1;
    #10 update = 0;
    $display("SUB: Out=%b, Z=%b, C=%b, V=%b, S=%b", out, Z_out, C_out, V_out, S_out);

    a = 8'b10101010; b = 8'b11001100; opcode = 4'b1000; update = 1;
    #10 update = 0;
    $display("AND: Out=%b, Z=%b, C=%b, V=%b, S=%b", out, Z_out, C_out, V_out, S_out);

    #20 $finish;
  end


endmodule

