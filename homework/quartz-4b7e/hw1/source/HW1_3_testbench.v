`timescale 1ns/1ps

module tb();

	reg A, B, C;
	wire out1, out2;
	ckt u1(A, B, C, out1, out2);

	initial begin

	$fsdbDumpfile("HW1_3.fsdb");
	$fsdbDumpvars(0, tb);

	#0	A = 1'b0;
		B = 1'b0;
		C = 1'b0;


	#10	A = 1'b1;
		B = 1'b0;
		C = 1'b0;


	#10	A = 1'b0;
		B = 1'b1;
		C = 1'b0;

	#10	A = 1'b1;
		B = 1'b1;
		C = 1'b1;

	#10	A = 1'b0;
		B = 1'b0;
		C = 1'b1;

	#10	$finish;

	end

endmodule


