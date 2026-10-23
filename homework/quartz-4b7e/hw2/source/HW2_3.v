`timescale 1ns/1ps

module circuit(
	output F,
	input A, B, C, D, E,
	input[1:0] ctrl_A, ctrl_B, ctrl_C, ctrl_D, ctrl_E, ctrl_F, ctrl_G, ctrl_H, ctrl_I, ctrl_J, ctrl_K, ctrl_L, ctrl_M // control signal for simulating faults
);

wire G, H, I, J, K, L, M; //wire in circuit
wire A_fault, B_fault, C_fault, D_fault, E_fault, F_fault, G_fault, H_fault, I_fault, J_fault, K_fault, L_fault, M_fault; // wire with faults

// use MUX to simulate single faults on each line
MUX  m0(.in(A), .control(ctrl_A), .out(A_fault));
MUX  m1(.in(B), .control(ctrl_B), .out(B_fault));
MUX  m2(.in(C), .control(ctrl_C), .out(C_fault));
MUX  m3(.in(D), .control(ctrl_D), .out(D_fault));
MUX  m4(.in(E), .control(ctrl_E), .out(E_fault));
MUX  m5(.in(G), .control(ctrl_G), .out(G_fault));
MUX  m6(.in(H), .control(ctrl_H), .out(H_fault));
MUX  m7(.in(I), .control(ctrl_I), .out(I_fault));
MUX  m8(.in(J), .control(ctrl_J), .out(J_fault));
MUX  m9(.in(K), .control(ctrl_K), .out(K_fault));
MUX m10(.in(L), .control(ctrl_L), .out(L_fault));
MUX m11(.in(M), .control(ctrl_M), .out(M_fault));
MUX m12(.in(F_fault), .control(ctrl_F), .out(F));

// main circuit
nor u0(L, A_fault, J_fault);
and u1(I, B_fault, G_fault);
nor u2(G, C_fault, D_fault);
not u3(H, E_fault);
and u4(M, H_fault, K_fault);
buf u5(J, I_fault);
buf u6(K, I_fault);
or  u7(F_fault, L_fault, M_fault);

endmodule
