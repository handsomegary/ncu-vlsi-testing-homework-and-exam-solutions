`timescale 1ns/1ps

module fault_free();

reg A, B, C, D, E;
wire F;

circuit u0(.A(A), .B(B), .C(C), .D(D), .E(E), .F(F));

initial begin

$fsdbDumpfile("HW2_3_fault_free.fsdb");
$fsdbDumpvars(0, fault_free);

#0	A = 1; B = 0; C = 1; D = 0; E = 1;
#10	A = 1; B = 0; C = 0; D = 1; E = 0;
#10	A = 0; B = 0; C = 0; D = 1; E = 0;
#10	A = 1; B = 0; C = 1; D = 0; E = 0;
#10	A = 0; B = 0; C = 0; D = 0; E = 0;

end

endmodule
