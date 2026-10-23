`timescale 1ns/1ps

module LFSR(
	input in, clk, reset,
	output q,
	output [0:3] D
);

	wire n1, n2;
	
	///// feedback loop /////
	xor xor1(n1, in, D[3]);
	xor xor2(n2, D[0], D[3]);
	
	
	///// shift register /////
	DFF dff0(n1, clk, reset, D[0]);
	DFF dff1(n2, clk, reset, D[1]);
	DFF dff2(D[1], clk, reset, D[2]);
	DFF dff3(D[2], clk, reset, D[3]);

	assign q = D[3];

endmodule

module DFF(
	input in, clk, reset,
	output reg out
);

	always@(posedge clk or posedge reset)begin

		if(reset)begin
			out <= 1'b0;
		end

		else begin
			out <= in;
		end

	end
	
endmodule
