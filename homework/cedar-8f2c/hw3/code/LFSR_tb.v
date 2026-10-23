`timescale 1ns / 1ps

module LFSR_tb();
reg clk,rst_n; 
reg en;
wire [5:0] out;
integer sum = 0; //accumulate output value
integer i;
integer PASS = 0;
LFSR dut (.clk(clk),.rst_n(rst_n),.en(en),.out(out));

//CLOCK SETTING
initial clk=1;
always #2.5 clk=~clk;

//SIMULATION
initial begin
    //RESET
    rst_n=1; en = 0;
    #2.5 rst_n = 0;
    //START
    #5 rst_n = 1; en = 1;
    for (i = 0; i < 63; i = i + 1) begin
        @(negedge clk);
        sum = sum + out;
    end
    en = 0;
    check();
    #10 $finish;
end

task check();
    if(sum == 2016) begin
        $display("PASS");
        PASS = 1; //Vivado users can observe in waveform
    end
    else begin
        $display("Fail");
        PASS = 0; //Vivado users can observe in waveform
    end
endtask

//Vivado users should comment this part, thanks.
//initial
//begin
//    $fsdbDumpfile("LFSR.fsdb");
//    $fsdbDumpvars;
//    $fsdbDumpMDA();
//end
/////////////////////////////////////////
endmodule