`timescale 1ns/1ps

module main(
	input Reset, clk, En, test, carry_in,
	input [15:0] x, y,
	output [15:0] Sum,
	output pf, FA_Cout
);
	
	wire FA_Cin;
	wire [15:0] FA_x, FA_y;

	BIST bist(Reset, clk, En, test, carry_in, FA_Cout, x, y, Sum, pf, FA_Cin, FA_x, FA_y);
	RCA rca(FA_x, FA_y, FA_Cin, test, Sum, FA_Cout);

endmodule


