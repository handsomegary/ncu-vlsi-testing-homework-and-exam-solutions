`timescale 1ns/1ps
// Create Date:2024/10/19
// Design Name:16bit ripple carry adder with BIST circuit
// Module Name: FullAdder_16bit_BIST

module FullAdder_16bit_BIST (Clk,Rst,En,Test,x,y,cin,Fault_loc,Fault_type,P_F,z); // cout is z[16]
input Clk,Rst,En,Test;
input cin;
input [15:0] x,y;
input [3:0] Fault_loc;
input [5:0] Fault_type; // Use one hot encoding to represent stuck at fault. Totally 10 faults.

output reg [16:0] z;
output P_F;

wire [15:0] x_BIST, y_BIST;
//reg  [15:0] x_fault, y_fault;
reg  [15:0] x_FA, y_FA;

reg [15:0]  c;
wire [15:1] c_FA;

wire cin_BIST;

//reg [16:0] z_fault;
wire [16:0] z_FA;
SubModule_BIST BIST(.Clk(Clk), .Rst(Rst), .En(En), .Test(Test),
                    .x(x), .y(y), .cin(cin), 
                    .z_FA(z), .x_BIST(x_BIST), .y_BIST(y_BIST), .cin_BIST(cin_BIST),
                    .P_F(P_F));

// Fault injection machanism          
always @(*)
    begin
            case(Fault_loc)
                4'd0:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:1],Fault_type[0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:1],Fault_type[0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = Fault_type[0];
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:1],Fault_type[0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:2],Fault_type[0]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd1:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:2],Fault_type[0],x_BIST[0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:2],Fault_type[0],y_BIST[0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:2],Fault_type[0]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:2],Fault_type[0],z_FA[0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:3],Fault_type[0],c_FA[1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd2:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:3],Fault_type[0],x_BIST[1:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:3],Fault_type[0],y_BIST[1:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:3],Fault_type[0],c_FA[1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:3],Fault_type[0],z_FA[1:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:4],Fault_type[0],c_FA[2:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd3:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:4],Fault_type[0],x_BIST[2:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:4],Fault_type[0],y_BIST[2:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:4],Fault_type[0],c_FA[2:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:4],Fault_type[0],z_FA[2:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:5],Fault_type[0],c_FA[3:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd4:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:5],Fault_type[0],x_BIST[3:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:5],Fault_type[0],y_BIST[3:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:5],Fault_type[0],c_FA[3:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:5],Fault_type[0],z_FA[3:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:6],Fault_type[0],c_FA[4:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd5:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:6],Fault_type[0],x_BIST[4:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:6],Fault_type[0],y_BIST[4:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:6],Fault_type[0],c_FA[4:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:6],Fault_type[0],z_FA[4:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:7],Fault_type[0],c_FA[5:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd6:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:7],Fault_type[0],x_BIST[5:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:7],Fault_type[0],y_BIST[5:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:7],Fault_type[0],c_FA[5:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:7],Fault_type[0],z_FA[5:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:8],Fault_type[0],c_FA[6:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd7:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:8],Fault_type[0],x_BIST[6:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:8],Fault_type[0],y_BIST[6:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:8],Fault_type[0],c_FA[6:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:8],Fault_type[0],z_FA[6:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:9],Fault_type[0],c_FA[7:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd8:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:9],Fault_type[0],x_BIST[7:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:9],Fault_type[0],y_BIST[7:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:9],Fault_type[0],c_FA[7:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:9],Fault_type[0],z_FA[7:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:10],Fault_type[0],c_FA[8:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd9:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:10],Fault_type[0],x_BIST[8:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:10],Fault_type[0],y_BIST[8:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:10],Fault_type[0],c_FA[8:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:10],Fault_type[0],z_FA[8:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:11],Fault_type[0],c_FA[9:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd10:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:11],Fault_type[0],x_BIST[9:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:11],Fault_type[0],y_BIST[9:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:11],Fault_type[0],c_FA[9:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:11],Fault_type[0],z_FA[9:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:12],Fault_type[0],c_FA[10:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd11:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:12],Fault_type[0],x_BIST[10:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:12],Fault_type[0],y_BIST[10:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:12],Fault_type[0],c_FA[10:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:12],Fault_type[0],z_FA[10:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:13],Fault_type[0],c_FA[11:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd12:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:13],Fault_type[0],x_BIST[11:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:13],Fault_type[0],y_BIST[11:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:13],Fault_type[0],c_FA[11:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:13],Fault_type[0],z_FA[11:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:14],Fault_type[0],c_FA[12:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd13:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15:14],Fault_type[0],x_BIST[12:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15:14],Fault_type[0],y_BIST[12:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15:14],Fault_type[0],c_FA[12:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:14],Fault_type[0],z_FA[12:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15],Fault_type[0],c_FA[13:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd14:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BIST[15],Fault_type[0],x_BIST[13:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {y_BIST[15],Fault_type[0],y_BIST[13:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {c_FA[15],Fault_type[0],c_FA[13:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:15],Fault_type[0],z_FA[13:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {Fault_type[0],c_FA[14:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                4'd15:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {Fault_type[0],x_BIST[14:0]};
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BIST;
                                    y_FA = {Fault_type[0],y_BIST[14:0]};
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = {Fault_type[0],c_FA[14:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16],Fault_type[0],z_FA[14:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;
                                    z = {Fault_type[0],z_FA[15:0]};
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BIST;
                                    y_FA = y_BIST;
                                    c[0] = cin_BIST;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                default:  // fault location default
                    begin
                        x_FA = 16'b0;
                        y_FA = 16'b0;
                        c = 16'b0;   
                        z = 17'b0;
                    end
            endcase
    end

// 16bit full adder
SubModule_FullAdder FA0(.cin(c[0]), .x(x_FA[0]), .y(y_FA[0]), .cout(c_FA[1]), .z(z_FA[0]));
SubModule_FullAdder FA1(.cin(c[1]), .x(x_FA[1]), .y(y_FA[1]), .cout(c_FA[2]), .z(z_FA[1]));
SubModule_FullAdder FA2(.cin(c[2]), .x(x_FA[2]), .y(y_FA[2]), .cout(c_FA[3]), .z(z_FA[2]));
SubModule_FullAdder FA3(.cin(c[3]), .x(x_FA[3]), .y(y_FA[3]), .cout(c_FA[4]), .z(z_FA[3]));
SubModule_FullAdder FA4(.cin(c[4]), .x(x_FA[4]), .y(y_FA[4]), .cout(c_FA[5]), .z(z_FA[4]));
SubModule_FullAdder FA5(.cin(c[5]), .x(x_FA[5]), .y(y_FA[5]), .cout(c_FA[6]), .z(z_FA[5]));
SubModule_FullAdder FA6(.cin(c[6]), .x(x_FA[6]), .y(y_FA[6]), .cout(c_FA[7]), .z(z_FA[6]));
SubModule_FullAdder FA7(.cin(c[7]), .x(x_FA[7]), .y(y_FA[7]), .cout(c_FA[8]), .z(z_FA[7]));
SubModule_FullAdder FA8(.cin(c[8]), .x(x_FA[8]), .y(y_FA[8]), .cout(c_FA[9]), .z(z_FA[8]));
SubModule_FullAdder FA9(.cin(c[9]), .x(x_FA[9]), .y(y_FA[9]), .cout(c_FA[10]), .z(z_FA[9]));
SubModule_FullAdder FA10(.cin(c[10]), .x(x_FA[10]), .y(y_FA[10]), .cout(c_FA[11]), .z(z_FA[10]));
SubModule_FullAdder FA11(.cin(c[11]), .x(x_FA[11]), .y(y_FA[11]), .cout(c_FA[12]), .z(z_FA[11]));
SubModule_FullAdder FA12(.cin(c[12]), .x(x_FA[12]), .y(y_FA[12]), .cout(c_FA[13]), .z(z_FA[12]));
SubModule_FullAdder FA13(.cin(c[13]), .x(x_FA[13]), .y(y_FA[13]), .cout(c_FA[14]), .z(z_FA[13]));
SubModule_FullAdder FA14(.cin(c[14]), .x(x_FA[14]), .y(y_FA[14]), .cout(c_FA[15]), .z(z_FA[14]));
SubModule_FullAdder FA15(.cin(c[15]), .x(x_FA[15]), .y(y_FA[15]), .cout(z_FA[16]), .z(z_FA[15]));
    
endmodule



module SubModule_BIST (Clk,Rst,En,Test,x,y,cin,z_FA,x_BIST,y_BIST,cin_BIST,P_F);
input Clk, Rst, En, Test;
input [15:0] x, y;
input cin;
input [16:0] z_FA;

output reg [15:0] x_BIST,y_BIST;
output reg cin_BIST;
output reg P_F;
reg [16:0] z_correct,z_compare;
reg [1:0] PatternCycle;
reg [1:0] CorrectCycle;
always @(posedge Clk or posedge Rst) 
begin
    if(Rst)
        begin
            cin_BIST <= 1'b0;
            x_BIST <= 16'b0;
            y_BIST <= 16'b0;
            z_correct <= 16'b0;
            PatternCycle <= 1'b0;
            CorrectCycle <= 2'b0;
        end
    else
        begin
            if(Test) // test mode
                begin
                    if(En)  // Use embedded pattern
                        begin
                            case(cin_BIST)
                                1'b0: 
                                    begin
                                        x_BIST <= 16'b1111_1111_1111_1111;
                                        y_BIST <= 16'b1111_1111_1111_1111;
                                        cin_BIST <= 1'b1;
                                        z_correct <= 17'b0; 
                                    end
                                1'b1:
                                    begin
                                        x_BIST <= 16'b0;
                                        y_BIST <= 16'b0;
                                        cin_BIST <= 1'b0;
                                        z_correct <= 17'b1111_1111_1111_1111_1; // maybe wrong
                                    end
                                default: 
                                    begin
                                        x_BIST <= 16'b0;
                                        y_BIST <= 16'b0;
                                        cin_BIST <= 1'b0;
                                        z_correct <= 17'b0;
                                    end
                            endcase
                            // let the c_compare get the right vlaue form embedded pattern not the testbench vlaue
                            if(PatternCycle < 2'b10) PatternCycle <= PatternCycle + 1'b1;
                            else PatternCycle <= PatternCycle;
                        end
                    else    // En is off, don't change x_FA、y_FA 
                        begin
                            x_BIST <= x_BIST;
                            y_BIST <= y_BIST;
                            cin_BIST <= cin_BIST;
                            if(CorrectCycle < 2'b10)
                                begin
                                    CorrectCycle <= CorrectCycle + 1'b1;
                                    case(z_correct)
                                        17'b0: z_correct <= 17'b1111_1111_1111_1111_1;
                                        17'b1111_1111_1111_1111_1: z_correct <= 17'b0;
                                        default: z_correct <= 17'b0;
                                    endcase
                                end
                            else
                                begin
                                    CorrectCycle <= CorrectCycle;
                                    z_correct <= z_correct;
                                end 
                          
                            PatternCycle <= PatternCycle;
                        end
                end
            else // normal mode
                begin
                    cin_BIST <= cin;
                    x_BIST <= x;
                    y_BIST <= y;
                end
        end
end
//determine pass or failure
always @(posedge Clk or posedge Rst) 
begin
    if(Rst)
        begin
            P_F <= 0;
            z_compare <= 17'b0;
        end
    else
        begin
            z_compare <= z_FA;
            if(PatternCycle > 2'b01)
                begin 
                    if(z_compare != z_correct) P_F <= 1'b1;
                    else P_F <= P_F;
                end
            else 
                begin
                    P_F <= P_F;
                end
        end
end

endmodule


module SubModule_FullAdder(cin,x,y,cout,z);
input cin,x,y;
output cout,z;

assign z=cin^x^y;
assign cout= (x&y) | ((x^y)&cin); // G+PCin
endmodule

