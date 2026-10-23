`timescale 1ns/1ps

module circuit(
	input [0:3] x, 	// x1 to x4
	input fault,
	output F	// output
);

	wire [0:3] x_b;	// complement of x1 to x4
	wire n1, n2, n3, n4, n5, n6, n7, n8; // output of logic gate
	wire a; // for fault activating

	not inv0(x_b[0], x[0]);
	not inv1(x_b[1], x[1]);
	not inv2(x_b[2], x[2]);
	not inv3(x_b[3], x[3]);

	and and0(n1, x[0], x_b[1], x_b[2], x_b[3]);
	and and1(n2, x_b[0], x_b[1], x[2], x_b[3]);
	and and2(n3, x[0], x[1], x_b[2], x[3]);
	and and3(n4, x_b[0], x[1], x_b[2], x_b[3]);
	and and4(n5, x_b[0], x[1], x[2], x[3]);
	and and5(n6, x[0], x[1], x_b[2], x[3]);

	or or0(n7, n1, n2);
	or or1(n8, n3, n4, n5, n6);
	assign a = fault? 1'b0 : n8; // SA0

	or or2(F, n7, a);

endmodule
