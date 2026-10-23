`timescale 1ns/1ps

// for simulating faults
module MUX(
	input in,
	input [1:0] control,
	output reg out
);

always@(*)begin

	case(control)
		2'd0: out = in;   // 0 for fault-free
		2'd1: out = 1'b0; // 1 for SA0
		2'd2: out = 1'b1; // 2 for SA1
		3'd3: out = in;   // 3 for fault-free
	endcase
	
end

endmodule
