`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/11/23 20:55:04
// Design Name: 
// Module Name: Sub_module
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


module CUT(x, F);
input [1:4] x;
output F;
wire a, b;
assign a = (x[1] & x[2] & ~x[3] & x[4]) | (~x[1] & x[2] & ~x[3] & ~x[4]) | (~x[1] & x[2] & x[3] & x[4]) | (x[1] & x[2] & ~x[3] & x[4]);
assign b = (x[1] & ~x[2] & ~x[3] & ~x[4]) | (~x[1] & ~x[2] & x[3] & ~x[4]);
assign F = a | b;
endmodule

module CUT_fault(x, F);
input [1:4] x;
output F;
wire a;
//assign a = (x[1] & x[2] & ~x[3] & x[4]) | (~x[1] & x[2] & ~x[3] & ~x[4]) | (~x[1] & x[2] & x[3] & x[4]) | (x[1] & x[2] & ~x[3] & x[4]);
assign b = (x[1] & ~x[2] & ~x[3] & ~x[4]) | (~x[1] & ~x[2] & x[3] & ~x[4]);
assign F = b;
endmodule

module LFSR(En, clk, rst, m, signature);
input En, clk, rst;
input m;
output reg [3:0] signature;

always @(posedge clk or posedge rst)
begin
    if(rst) signature <= 4'b0;
    else
        begin
            if(En)
                begin
                    signature[0] <= m ^ signature[3];
                    signature[1] <= signature[0] ^ signature[3];
                    signature[2] <= signature[1];
                    signature[3] <= signature[2];
                end
            else
                begin
                    signature <= signature;
                end
        end
end
endmodule
