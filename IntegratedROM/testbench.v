`timescale 1ns / 1ps


module tb;
 
integer i = 0;
 
reg clk = 0,sys_rst = 0;
reg [15:0] din = 0;
wire [15:0] dout;
 
 
top dut(clk, sys_rst, din, dout);
 
always #5 clk = ~clk;
 
initial begin
//////// readdin
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`oper_type = 18;
dut.`rdst  = 8;///gpr[0]
#10;
$display("OP:RDDIN  Din:%0d Rdst:%0d", dut.din, dut.GPR[4]);
end
initial begin
//////// immediate add op
$display("-----------------------------------------------------------------");
dut.IR = 0;
dut.`oper_type = 19;
dut.`rsrc1 = 0;
#10;
$display("OP:SNDDUT Dout:%0d Rsrc1:%0d",dut.GPR[2], dut.dout, dut.GPR[0]);
end
initial begin
sys_rst = 1'b1;
repeat(5) @(posedge clk);
sys_rst = 1'b0;
#800;
$stop;
end
 
endmodule
