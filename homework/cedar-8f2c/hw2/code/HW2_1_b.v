`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/23 14:59:58
// Design Name: 
// Module Name: HW2_1_a
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


module HW2_1_b(En, clk, rst, x, signature);
input En, clk, rst;
input [1:4] x;
output [3:0] signature;
wire F;
CUT_fault CUT1(x, F);
LFSR LFSR1(En, clk, rst, F, signature);
endmodule

