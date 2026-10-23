`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/23 19:21:13
// Design Name: 
// Module Name: HW2_1_a_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module HW2_1_b_tb();
    reg Clk, Rst, En;
	reg [1:4] x;
	wire [3:0] signature;
	
	HW2_1_b UUT(En, Clk, Rst, x, signature);

	initial 
	   begin
	       Clk = 1'b1;	
	       forever 
	           begin
	           #5 Clk = ~Clk;
	           end
        end

	initial begin

	Rst = 1'b1;
	En = 1'b0;
	x = 4'b0001; //pattern 1	
		
	#10	
	   Rst = 1'b0;
	   En = 1'b1; 
	   x = 4'b1100; //pattern 2
	
	#10	x = 4'b0110; //pattern 3

	#10	x = 4'b0011; //pattern 4
	
	#10	x = 4'b1101; //pattern 5

    #10	x = 4'b1010; //pattern 6
    
    #10	x = 4'b0101; //pattern 7
    
    #10	x = 4'b1110; //pattern 8

    #10	x = 4'b0111; //pattern 9
    
    #10	x = 4'b1111; //pattern 10    
    
    #10	x = 4'b1011; //pattern 11
    
    #10	x = 4'b1001; //pattern 12
    
    #10	x = 4'b1000; //pattern 13
    
    #10	x = 4'b0100; //pattern 14
    
    #10	x = 4'b0010; //pattern 15
	#20	En = 1'b0;
	
	#50	$finish;	

	end
endmodule
