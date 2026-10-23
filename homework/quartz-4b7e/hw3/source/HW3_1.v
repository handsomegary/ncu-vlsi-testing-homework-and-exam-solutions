`timescale 1ns/1ps

module main(
	input clk, reset, fault,
	input [0:3] x,
	output F,
	output [0:3] D	// signature
);
	
wire q; // LFSR output

circuit circuit_0(x, fault, F);
LFSR LFSR_0(F, clk, reset, q, D);

endmodule
