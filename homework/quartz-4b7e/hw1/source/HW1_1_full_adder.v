`timescale 1ns/1ps

module full_adder(
	input in1, in2, Cin,
	output Sum, Cout
);

	wire w1, w2, w3;
	
	xor u0(w1, in1, in2);
	xor u1(Sum, Cin, w1);
	and u2(w2, w1, Cin);
	and u3(w3, in1, in2);
	or  u4(Cout, w2, w3);

endmodule


