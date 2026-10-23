`timescale 1ns/1ps

module tb();

	reg [15:0] x, y;
	reg Cin, test, clk, Reset, En;
	wire [15:0] Sum;
	wire Cout, pf;

	main u0(Reset, clk, En, test, Cin, x, y, Sum, pf, Cout);

	initial begin

	clk = 1'b1;	
		
	forever begin
	#10 clk = ~clk;
	end

	end

	initial begin

	$fsdbDumpfile("HW1_1.fsdb");
	$fsdbDumpvars(0, tb);

	Reset = 1'b1;
	Cin = 1'b0;
	test = 1'b0;
	En = 1'b0;
	x = 16'b0000_0000_0000_0000;
	y = 16'b0000_0000_0000_0000;
	
	#20	Reset = 1'b0;
		x = 16'd300;
		y = 16'd 59;
		Cin = 1'b0;
	
	#20	x = 16'd15;
		y = 16'd20;
		Cin = 1'b1;
	
	#20	x = 16'd1300;
		y = 16'd56;
		Cin = 1'b1;

	#20	x = 16'd50;
		y = 16'd100;
		Cin = 1'b0;

	#20	test = 1'b1;
		En =1'b1;
	
	#240	Reset = 1'b1;
		En = 1'b0;
		x = 16'bzzzz_zzzz_zzzz_zzzz;
		y = 16'bzzzz_zzzz_zzzz_zzzz;
		Cin = 1'bz;
	
	#20	$finish;	

	end

endmodule
