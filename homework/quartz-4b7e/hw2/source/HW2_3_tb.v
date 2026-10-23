`timescale 1ns/1ps

module tb();

reg A, B, C, D, E;
wire F;
reg [1:0] ctrl_A, ctrl_B, ctrl_C, ctrl_D, ctrl_E, ctrl_F, ctrl_G, ctrl_H, ctrl_I, ctrl_J, ctrl_K, ctrl_L, ctrl_M; 

circuit u0(.F(F), .A(A), .B(B), .C(C), .D(D), .E(E), 
		.ctrl_A(ctrl_A), .ctrl_B(ctrl_B), .ctrl_C(ctrl_C), .ctrl_D(ctrl_D), .ctrl_E(ctrl_E), .ctrl_F(ctrl_F), 
		.ctrl_G(ctrl_G), .ctrl_H(ctrl_H), .ctrl_I(ctrl_I), .ctrl_J(ctrl_J), .ctrl_K(ctrl_K), .ctrl_L(ctrl_L), .ctrl_M(ctrl_M));

initial begin

$fsdbDumpfile("HW2_3.fsdb");
$fsdbDumpvars(0, tb);

// initialization for test pattern {A, B, C, D, E} = {1, 0, 1, 0 ,1}
#0 	ctrl_A = 2'd0; ctrl_B = 2'd0; ctrl_C = 2'd0; ctrl_D = 2'd0; ctrl_E = 2'd0; ctrl_F = 2'd0; ctrl_G = 2'd0;
	ctrl_H = 2'd0; ctrl_I = 2'd0; ctrl_J = 2'd0; ctrl_K = 2'd0; ctrl_L = 2'd0; ctrl_M = 2'd0;
	A = 1'b1; B = 1'b0; C = 1'b1; D = 1'b0; E = 1'b1;

// single stuck at 0
#10	ctrl_A = 2'd1;
#10	ctrl_A = 2'd0; ctrl_B = 2'd1;
#10	ctrl_B = 2'd0; ctrl_C = 2'd1;
#10	ctrl_C = 2'd0; ctrl_D = 2'd1;
#10	ctrl_D = 2'd0; ctrl_E = 2'd1;
#10	ctrl_E = 2'd0; ctrl_F = 2'd1;
#10	ctrl_F = 2'd0; ctrl_G = 2'd1;
#10	ctrl_G = 2'd0; ctrl_H = 2'd1;
#10	ctrl_H = 2'd0; ctrl_I = 2'd1;
#10	ctrl_I = 2'd0; ctrl_J = 2'd1;
#10	ctrl_J = 2'd0; ctrl_K = 2'd1;
#10	ctrl_K = 2'd0; ctrl_L = 2'd1;
#10	ctrl_L = 2'd0; ctrl_M = 2'd1;
#10	ctrl_M = 2'd0;

// single stuck at 1
#10	ctrl_A = 2'd2;
#10	ctrl_A = 2'd0; ctrl_B = 2'd2;
#10	ctrl_B = 2'd0; ctrl_C = 2'd2;
#10	ctrl_C = 2'd0; ctrl_D = 2'd2;
#10	ctrl_D = 2'd0; ctrl_E = 2'd2;
#10	ctrl_E = 2'd0; ctrl_F = 2'd2;
#10	ctrl_F = 2'd0; ctrl_G = 2'd2;
#10	ctrl_G = 2'd0; ctrl_H = 2'd2;
#10	ctrl_H = 2'd0; ctrl_I = 2'd2;
#10	ctrl_I = 2'd0; ctrl_J = 2'd2;
#10	ctrl_J = 2'd0; ctrl_K = 2'd2;
#10	ctrl_K = 2'd0; ctrl_L = 2'd2;
#10	ctrl_L = 2'd0; ctrl_M = 2'd2;
#10	ctrl_M = 2'd0;


// initialization for test pattern {A, B, C, D, E} = {1, 0, 0, 1 ,0}
#30 	ctrl_A = 2'd0; ctrl_B = 2'd0; ctrl_C = 2'd0; ctrl_D = 2'd0; ctrl_E = 2'd0; ctrl_F = 2'd0; ctrl_G = 2'd0;
	ctrl_H = 2'd0; ctrl_I = 2'd0; ctrl_J = 2'd0; ctrl_K = 2'd0; ctrl_L = 2'd0; ctrl_M = 2'd0;
	A = 1'b1; B = 1'b0; C = 1'b0; D = 1'b1; E = 1'b0;

// single stuck at 0
#10	ctrl_A = 2'd1;
#10	ctrl_A = 2'd0; ctrl_B = 2'd1;
#10	ctrl_B = 2'd0; ctrl_C = 2'd1;
#10	ctrl_C = 2'd0; ctrl_D = 2'd1;
#10	ctrl_D = 2'd0; ctrl_E = 2'd1;
#10	ctrl_E = 2'd0; ctrl_F = 2'd1;
#10	ctrl_F = 2'd0; ctrl_G = 2'd1;
#10	ctrl_G = 2'd0; ctrl_H = 2'd1;
#10	ctrl_H = 2'd0; ctrl_I = 2'd1;
#10	ctrl_I = 2'd0; ctrl_J = 2'd1;
#10	ctrl_J = 2'd0; ctrl_K = 2'd1;
#10	ctrl_K = 2'd0; ctrl_L = 2'd1;
#10	ctrl_L = 2'd0; ctrl_M = 2'd1;
#10	ctrl_M = 2'd0;

// single stuck at 1
#10	ctrl_A = 2'd2;
#10	ctrl_A = 2'd0; ctrl_B = 2'd2;
#10	ctrl_B = 2'd0; ctrl_C = 2'd2;
#10	ctrl_C = 2'd0; ctrl_D = 2'd2;
#10	ctrl_D = 2'd0; ctrl_E = 2'd2;
#10	ctrl_E = 2'd0; ctrl_F = 2'd2;
#10	ctrl_F = 2'd0; ctrl_G = 2'd2;
#10	ctrl_G = 2'd0; ctrl_H = 2'd2;
#10	ctrl_H = 2'd0; ctrl_I = 2'd2;
#10	ctrl_I = 2'd0; ctrl_J = 2'd2;
#10	ctrl_J = 2'd0; ctrl_K = 2'd2;
#10	ctrl_K = 2'd0; ctrl_L = 2'd2;
#10	ctrl_L = 2'd0; ctrl_M = 2'd2;
#10	ctrl_M = 2'd0;


// initialization for test pattern {A, B, C, D, E} = {0, 0, 0, 1 ,0}
#30 	ctrl_A = 2'd0; ctrl_B = 2'd0; ctrl_C = 2'd0; ctrl_D = 2'd0; ctrl_E = 2'd0; ctrl_F = 2'd0; ctrl_G = 2'd0;
	ctrl_H = 2'd0; ctrl_I = 2'd0; ctrl_J = 2'd0; ctrl_K = 2'd0; ctrl_L = 2'd0; ctrl_M = 2'd0;
	A = 1'b0; B = 1'b0; C = 1'b0; D = 1'b1; E = 1'b0;

// single stuck at 0
#10	ctrl_A = 2'd1;
#10	ctrl_A = 2'd0; ctrl_B = 2'd1;
#10	ctrl_B = 2'd0; ctrl_C = 2'd1;
#10	ctrl_C = 2'd0; ctrl_D = 2'd1;
#10	ctrl_D = 2'd0; ctrl_E = 2'd1;
#10	ctrl_E = 2'd0; ctrl_F = 2'd1;
#10	ctrl_F = 2'd0; ctrl_G = 2'd1;
#10	ctrl_G = 2'd0; ctrl_H = 2'd1;
#10	ctrl_H = 2'd0; ctrl_I = 2'd1;
#10	ctrl_I = 2'd0; ctrl_J = 2'd1;
#10	ctrl_J = 2'd0; ctrl_K = 2'd1;
#10	ctrl_K = 2'd0; ctrl_L = 2'd1;
#10	ctrl_L = 2'd0; ctrl_M = 2'd1;
#10	ctrl_M = 2'd0;

// single stuck at 1
#10	ctrl_A = 2'd2;
#10	ctrl_A = 2'd0; ctrl_B = 2'd2;
#10	ctrl_B = 2'd0; ctrl_C = 2'd2;
#10	ctrl_C = 2'd0; ctrl_D = 2'd2;
#10	ctrl_D = 2'd0; ctrl_E = 2'd2;
#10	ctrl_E = 2'd0; ctrl_F = 2'd2;
#10	ctrl_F = 2'd0; ctrl_G = 2'd2;
#10	ctrl_G = 2'd0; ctrl_H = 2'd2;
#10	ctrl_H = 2'd0; ctrl_I = 2'd2;
#10	ctrl_I = 2'd0; ctrl_J = 2'd2;
#10	ctrl_J = 2'd0; ctrl_K = 2'd2;
#10	ctrl_K = 2'd0; ctrl_L = 2'd2;
#10	ctrl_L = 2'd0; ctrl_M = 2'd2;
#10	ctrl_M = 2'd0;


// initialization for test pattern {A, B, C, D, E} = {1, 0, 1,0 ,0}
#30 	ctrl_A = 2'd0; ctrl_B = 2'd0; ctrl_C = 2'd0; ctrl_D = 2'd0; ctrl_E = 2'd0; ctrl_F = 2'd0; ctrl_G = 2'd0;
	ctrl_H = 2'd0; ctrl_I = 2'd0; ctrl_J = 2'd0; ctrl_K = 2'd0; ctrl_L = 2'd0; ctrl_M = 2'd0;
	A = 1'b1; B = 1'b0; C = 1'b1; D = 1'b0; E = 1'b0;

// single stuck at 0
#10	ctrl_A = 2'd1;
#10	ctrl_A = 2'd0; ctrl_B = 2'd1;
#10	ctrl_B = 2'd0; ctrl_C = 2'd1;
#10	ctrl_C = 2'd0; ctrl_D = 2'd1;
#10	ctrl_D = 2'd0; ctrl_E = 2'd1;
#10	ctrl_E = 2'd0; ctrl_F = 2'd1;
#10	ctrl_F = 2'd0; ctrl_G = 2'd1;
#10	ctrl_G = 2'd0; ctrl_H = 2'd1;
#10	ctrl_H = 2'd0; ctrl_I = 2'd1;
#10	ctrl_I = 2'd0; ctrl_J = 2'd1;
#10	ctrl_J = 2'd0; ctrl_K = 2'd1;
#10	ctrl_K = 2'd0; ctrl_L = 2'd1;
#10	ctrl_L = 2'd0; ctrl_M = 2'd1;
#10	ctrl_M = 2'd0;

// single stuck at 1
#10	ctrl_A = 2'd2;
#10	ctrl_A = 2'd0; ctrl_B = 2'd2;
#10	ctrl_B = 2'd0; ctrl_C = 2'd2;
#10	ctrl_C = 2'd0; ctrl_D = 2'd2;
#10	ctrl_D = 2'd0; ctrl_E = 2'd2;
#10	ctrl_E = 2'd0; ctrl_F = 2'd2;
#10	ctrl_F = 2'd0; ctrl_G = 2'd2;
#10	ctrl_G = 2'd0; ctrl_H = 2'd2;
#10	ctrl_H = 2'd0; ctrl_I = 2'd2;
#10	ctrl_I = 2'd0; ctrl_J = 2'd2;
#10	ctrl_J = 2'd0; ctrl_K = 2'd2;
#10	ctrl_K = 2'd0; ctrl_L = 2'd2;
#10	ctrl_L = 2'd0; ctrl_M = 2'd2;
#10	ctrl_M = 2'd0;

#30	A = 1'b0; B = 1'b0; C = 1'b0; D = 1'b0; E = 1'b0;
#600	$finish;

end

endmodule
