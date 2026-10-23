`timescale 1ns/1ps

module ckt(
	input A, B, C,
	output out1, out2
);

	wire w1, w2, w3;

	xor u0(w1, B, C);
	xor u1(out1, A, w1);
	and u2(w2, A, w1);
	and u3(w3, B, C);
	or  u4(out2, w2, w3);

endmodule


