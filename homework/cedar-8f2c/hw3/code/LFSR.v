`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/12/16 09:36:09
// Design Name: 
// Module Name: HW3
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



module LFSR(clk, rst_n, en, out);
input en, clk, rst_n;
output reg [5:0] out;

always @(posedge clk or negedge rst_n)
begin
    if(!rst_n) out <= 5'b00001;
    else
        begin
            if(en)
                begin
                    out[0] <= out[4] ^ out[5];
                    out[1] <= out[0];
                    out[2] <= out[1];
                    out[3] <= out[2];
                    out[4] <= out[3];
                    out[5] <= out[4];
                end
            else
                begin
                    out <= out;
                end
        end
end
endmodule