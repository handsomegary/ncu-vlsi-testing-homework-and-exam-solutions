`timescale 1ns/1ps

module circuit(
        output F,
        input A, B, C, D, E
);

wire G, H, I, J, K, L, M;

 nor u0(L, A, J);
 and u1(I, B, G);
 nor u2(G, C, D);
 not u3(H, E);
 and u4(M, H, K);
 buf u5(J, I);
 buf u6(K, I);
 or  u7(F, L, M);

 endmodule

