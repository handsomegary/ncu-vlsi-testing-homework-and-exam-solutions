`timescale 1ns/1ps

module hw3_1_tb();

reg clk, reset;
reg [0:3] x[15:0];
reg [0:3] counter;

wire F1, F2; // F1: fault-free; F2: faulty
wire [0:3] D, D_faulty;

main fault_free(clk, reset, 1'b0, x[counter], F1, D);
main faulty(clk, reset, 1'b1, x[counter], F2, D_faulty);

initial begin
	clk = 1'b0;
	forever begin
		#10 clk = ~clk;
	end
end

always@(posedge clk or posedge reset)begin
	if(reset) 
		counter <= 4'd0;
	else
		counter <= counter + 4'd1;
end

initial begin
	x[0]<=4'b0001;
	x[1]<=4'b1100;
	x[2]<=4'b0110;
	x[3]<=4'b0011;
	x[4]<=4'b1101;
	x[5]<=4'b1010;
	x[6]<=4'b0101;
	x[7]<=4'b1110;
	x[8]<=4'b0111;
	x[9]<=4'b1111;
	x[10]<=4'b1011;
	x[11]<=4'b1001;
	x[12]<=4'b1000;
	x[13]<=4'b0100;
	x[14]<=4'b0010;
	x[15]<=4'b0000;
end

initial begin
	$fsdbDumpfile("HW3_1.fsdb");
	$fsdbDumpvars(0, hw3_1_tb);

	#0
	reset = 1'b0;
	counter = 4'd0;	

	#5
	reset = 1'b1; // reset DFF first
	
	#10
	reset = 1'b0;

	#5
	#400 $finish;
	
end

endmodule
