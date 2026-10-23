`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/10/20 20:26:59
// Design Name: 
// Module Name: HW1_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module HW1_tb();
    
    reg Clk, Rst, En, Test;
	reg [15:0] x, y;
	reg cin;
	reg [3:0] Fault_loc;
	reg [5:0] Fault_type;
	
	wire P_F;
	wire [16:0] z;
	

	FullAdder_16bit_BIST UUT(Clk,Rst,En,Test,x,y,cin,Fault_loc,Fault_type,P_F,z);

	initial 
	   begin
	       Clk = 1'b1;	
	       forever 
	           begin
	           #5 Clk = ~Clk;
	           end
        end

	initial begin

	//$fsdbDumpfile("HW1_1.fsdb");
	//$fsdbDumpvars(0, tb);

	Rst = 1'b1;
	cin = 1'b0;
	Test = 1'b0;
	En = 1'b0;
	x = 16'b0000_0000_0000_0000;
	y = 16'b0000_0000_0000_0000;
	Fault_loc = 4'd0;
	Fault_type = 6'b0;
	
	#10	Rst = 1'b0;
		x = 16'd300;
		y = 16'd59;
		cin = 1'b0;
	
	#10	x = 16'd15;
		y = 16'd20;
		cin = 1'b1;
	
	#10	x = 16'd1300;
		y = 16'd56;
		cin = 1'b1;

	#10	
	   Fault_loc = 4'd4;
	   Fault_type = 6'b010000;

	#10	Test = 1'b1;
	#10	En =1'b1;
	#50 En = 1'b0;
	#120	
	   Rst = 1'b1;
	   x = 16'bzzzz_zzzz_zzzz_zzzz;
	   y = 16'bzzzz_zzzz_zzzz_zzzz;
	   cin = 1'bz;
	
	#20	$finish;	

	end



endmodule
