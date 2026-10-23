`timescale 1ns/1ps

module RCA(
	input [15:0] in1, in2,
	input Cin, test,
	output [15:0] Sum,
	output Cout
);

	wire [15:0]carry;
	wire temp; // for normal output
	assign Cout = carry[15];

	////////////////////////////// RCA //////////////////////////////
	
	/* single stuck at fault occur in carry of full_adder 7 */
	full_adder fa0 (in1[0],  in2[0],  Cin, Sum[0],  temp);
	assign carry[0] = test? 1'b1:temp;
	//////////////////////////////////////////////////////////

	full_adder fa1 (in1[1],  in2[1],  carry[0],  Sum[1],  carry[1]);
	full_adder fa2 (in1[2],  in2[2],  carry[1],  Sum[2],  carry[2]);
	full_adder fa3 (in1[3],  in2[3],  carry[2],  Sum[3],  carry[3]);
	full_adder fa4 (in1[4],  in2[4],  carry[3],  Sum[4],  carry[4]);
	full_adder fa5 (in1[5],  in2[5],  carry[4],  Sum[5],  carry[5]);
	full_adder fa6 (in1[6],  in2[6],  carry[5],  Sum[6],  carry[6]);
	full_adder fa7 (in1[7],  in2[7],  carry[6],  Sum[7],  carry[7]);
	full_adder fa8 (in1[8],  in2[8],  carry[7],  Sum[8],  carry[8]);
	full_adder fa9 (in1[9],  in2[9],  carry[8],  Sum[9],  carry[9]);
	full_adder fa10(in1[10], in2[10], carry[9],  Sum[10], carry[10]);
	full_adder fa11(in1[11], in2[11], carry[10], Sum[11], carry[11]);
	full_adder fa12(in1[12], in2[12], carry[11], Sum[12], carry[12]);
	full_adder fa13(in1[13], in2[13], carry[12], Sum[13], carry[13]);
	full_adder fa14(in1[14], in2[14], carry[13], Sum[14], carry[14]);
	full_adder fa15(in1[15], in2[15], carry[14], Sum[15], carry[15]);
	/////////////////////////////////////////////////////////////////

endmodule
