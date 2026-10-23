`timescale 1ns/1ps
// Create Date:2024/10/19
// Design Name:16bit ripple carry adder with BISR circuit
// Module Name: FullAdder_16bit_BISR

module FullAdder_16bit_BISR (Clk,Rst,En,Test,x,y,cin,Fault_loc,Fault_type,P_F,z_repair); // cout is z[16]
input Clk,Rst,En,Test;
input cin;
input [15:0] x,y;
input [3:0] Fault_loc;
input [5:0] Fault_type; // Use one hot encoding to represent stuck at fault. Totally 10 faults.

output reg [16:0] z_repair;

output P_F;

wire [15:0] x_BISR, y_BISR;
reg  [15:0] x_fault, y_fault;
reg  [15:0] x_FA, y_FA;

reg [15:0]  c_fault, c;
wire [15:1] c_FA;

wire cin_BISR;

//reg [16:0] z_fault;
wire [16:0] z_FA;
reg [16:0] z;
wire [3:0] FA_fault_loc;
SubModule_BISR BISR(.Clk(Clk), .Rst(Rst), .En(En), .Test(Test),
                    .x(x), .y(y), .cin(cin), 
                    .z_FA(z_repair), .x_BISR(x_BISR), .y_BISR(x_BISR), .cin_BISR(cin_BISR),
                    .P_F(P_F), .FA_fault_loc(FA_fault_loc));

// Fault injection machanism          
always @(*)
    begin
            case(Fault_loc)
                4'd0:
                    begin
                        case(Fault_type[5:1])  // x_y_cin_z_cout
                            5'b10000: //x
                                begin
                                    x_FA = {x_BISR[15:1],Fault_type[0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:1],Fault_type[0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = Fault_type[0];
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:1],Fault_type[0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:2],Fault_type[0]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:2],Fault_type[0],x_BISR[0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:2],Fault_type[0],y_BISR[0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:2],Fault_type[0]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:2],Fault_type[0],z_FA[0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:3],Fault_type[0],c_FA[1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:3],Fault_type[0],x_BISR[1:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:3],Fault_type[0],y_BISR[1:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:3],Fault_type[0],c_FA[1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:3],Fault_type[0],z_FA[1:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:4],Fault_type[0],c_FA[2:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:4],Fault_type[0],x_BISR[2:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:4],Fault_type[0],y_BISR[2:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:4],Fault_type[0],c_FA[2:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:4],Fault_type[0],z_FA[2:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:5],Fault_type[0],c_FA[3:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:5],Fault_type[0],x_BISR[3:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:5],Fault_type[0],y_BISR[3:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:5],Fault_type[0],c_FA[3:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:5],Fault_type[0],z_FA[3:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:6],Fault_type[0],c_FA[4:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:6],Fault_type[0],x_BISR[4:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:6],Fault_type[0],y_BISR[4:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:6],Fault_type[0],c_FA[4:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:6],Fault_type[0],z_FA[4:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:7],Fault_type[0],c_FA[5:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:7],Fault_type[0],x_BISR[5:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:7],Fault_type[0],y_BISR[5:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:7],Fault_type[0],c_FA[5:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:7],Fault_type[0],z_FA[5:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:8],Fault_type[0],c_FA[6:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:8],Fault_type[0],x_BISR[6:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:8],Fault_type[0],y_BISR[6:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:8],Fault_type[0],c_FA[6:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:8],Fault_type[0],z_FA[6:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:9],Fault_type[0],c_FA[7:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:9],Fault_type[0],x_BISR[7:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:9],Fault_type[0],y_BISR[7:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:9],Fault_type[0],c_FA[7:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:9],Fault_type[0],z_FA[7:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:10],Fault_type[0],c_FA[8:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:10],Fault_type[0],x_BISR[8:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:10],Fault_type[0],y_BISR[8:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:10],Fault_type[0],c_FA[8:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:10],Fault_type[0],z_FA[8:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:11],Fault_type[0],c_FA[9:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:11],Fault_type[0],x_BISR[9:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:11],Fault_type[0],y_BISR[9:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:11],Fault_type[0],c_FA[9:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:11],Fault_type[0],z_FA[9:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:12],Fault_type[0],c_FA[10:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:12],Fault_type[0],x_BISR[10:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:12],Fault_type[0],y_BISR[10:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:12],Fault_type[0],c_FA[10:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:12],Fault_type[0],z_FA[10:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:13],Fault_type[0],c_FA[11:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:13],Fault_type[0],x_BISR[11:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:13],Fault_type[0],y_BISR[11:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:13],Fault_type[0],c_FA[11:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:13],Fault_type[0],z_FA[11:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:14],Fault_type[0],c_FA[12:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15:14],Fault_type[0],x_BISR[12:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15:14],Fault_type[0],y_BISR[12:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15:14],Fault_type[0],c_FA[12:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:14],Fault_type[0],z_FA[12:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15],Fault_type[0],c_FA[13:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {x_BISR[15],Fault_type[0],x_BISR[13:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {y_BISR[15],Fault_type[0],y_BISR[13:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {c_FA[15],Fault_type[0],c_FA[13:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16:15],Fault_type[0],z_FA[13:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {Fault_type[0],c_FA[14:1]};
                                    z = z_FA;
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
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
                                    x_FA = {Fault_type[0],x_BISR[14:0]};
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b01000: //y
                                begin
                                    x_FA = x_BISR;
                                    y_FA = {Fault_type[0],y_BISR[14:0]};
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = z_FA;
                                end
                            5'b00100: //cin
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = {Fault_type[0],c_FA[14:1]};
                                    z = z_FA;
                                end
                            5'b00010: //z
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {z_FA[16],Fault_type[0],z_FA[14:0]};
                                end
                            5'b00001: //cout
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;
                                    z = {Fault_type[0],z_FA[15:0]};
                                end
                            default: //  no fault
                                begin
                                    x_FA = x_BISR;
                                    y_FA = y_BISR;
                                    c[0] = cin_BISR;
                                    c[15:1] = c_FA;   
                                    z = z_FA;
                                end
                        endcase
                    end
                default: // fault location default
                    begin
                        x_FA = 16'b0;
                        y_FA = 16'b0;
                        c = 16'b0;   
                        z = 17'b0;
                    end
            endcase
    end

// 16bit full adder
// reg [16:0] z_repair;
reg [15:0] c_repair;
SubModule_FullAdder FA0(.cin(c_repair[0]), .x(x_FA[0]), .y(y_FA[0]), .cout(c_FA[1]), .z(z_FA[0]));
SubModule_FullAdder FA1(.cin(c_repair[1]), .x(x_FA[1]), .y(y_FA[1]), .cout(c_FA[2]), .z(z_FA[1]));
SubModule_FullAdder FA2(.cin(c_repair[2]), .x(x_FA[2]), .y(y_FA[2]), .cout(c_FA[3]), .z(z_FA[2]));
SubModule_FullAdder FA3(.cin(c_repair[3]), .x(x_FA[3]), .y(y_FA[3]), .cout(c_FA[4]), .z(z_FA[3]));
SubModule_FullAdder FA4(.cin(c_repair[4]), .x(x_FA[4]), .y(y_FA[4]), .cout(c_FA[5]), .z(z_FA[4]));
SubModule_FullAdder FA5(.cin(c_repair[5]), .x(x_FA[5]), .y(y_FA[5]), .cout(c_FA[6]), .z(z_FA[5]));
SubModule_FullAdder FA6(.cin(c_repair[6]), .x(x_FA[6]), .y(y_FA[6]), .cout(c_FA[7]), .z(z_FA[6]));
SubModule_FullAdder FA7(.cin(c_repair[7]), .x(x_FA[7]), .y(y_FA[7]), .cout(c_FA[8]), .z(z_FA[7]));
SubModule_FullAdder FA8(.cin(c_repair[8]), .x(x_FA[8]), .y(y_FA[8]), .cout(c_FA[9]), .z(z_FA[8]));
SubModule_FullAdder FA9(.cin(c_repair[9]), .x(x_FA[9]), .y(y_FA[9]), .cout(c_FA[10]), .z(z_FA[9]));
SubModule_FullAdder FA10(.cin(c_repair[10]), .x(x_FA[10]), .y(y_FA[10]), .cout(c_FA[11]), .z(z_FA[10]));
SubModule_FullAdder FA11(.cin(c_repair[11]), .x(x_FA[11]), .y(y_FA[11]), .cout(c_FA[12]), .z(z_FA[11]));
SubModule_FullAdder FA12(.cin(c_repair[12]), .x(x_FA[12]), .y(y_FA[12]), .cout(c_FA[13]), .z(z_FA[12]));
SubModule_FullAdder FA13(.cin(c_repair[13]), .x(x_FA[13]), .y(y_FA[13]), .cout(c_FA[14]), .z(z_FA[13]));
SubModule_FullAdder FA14(.cin(c_repair[14]), .x(x_FA[14]), .y(y_FA[14]), .cout(c_FA[15]), .z(z_FA[14]));
SubModule_FullAdder FA15(.cin(c_repair[15]), .x(x_FA[15]), .y(y_FA[15]), .cout(z_FA[16]), .z(z_FA[15]));

// sapre full adder spare
reg x_spare,y_spare,cin_spare;
wire z_spare,cout_spare;
SubModule_FullAdder FA_spare(.cin(cin_spare), .x(x_spare), .y(y_spare), .cout(cout_spare), .z(z_spare));
always @(*)
begin
    if(P_F)  // failure use spare full adder
        begin
            case(FA_fault_loc)
                4'd0: 
                    begin
                        x_spare = x_BISR[0];
                        y_spare = y_BISR[0];
                        cin_spare = c[0];
                        z_repair = {z[16:1],z_spare};
                        c_repair = {c[15:2],cout_spare,c[0]};
                    end
                4'd1:
                    begin
                        x_spare = x_BISR[1];
                        y_spare = y_BISR[1];
                        cin_spare = c[1];
                        z_repair = {z[16:2],z_spare,z[0]};
                        c_repair = {c[15:3],cout_spare,c[1:0]};
                    end 
                4'd2:
                    begin
                        x_spare = x_BISR[2];
                        y_spare = y_BISR[2];
                        cin_spare = c[2];
                        z_repair = {z[16:3],z_spare,z[1:0]};
                        c_repair = {c[15:4],cout_spare,c[2:0]};
                    end 
                4'd3:
                    begin
                        x_spare = x_BISR[3];
                        y_spare = y_BISR[3];
                        cin_spare = c[3];
                        z_repair = {z[16:4],z_spare,z[2:0]};
                        c_repair = {c[15:5],cout_spare,c[3:0]};
                    end
                4'd4:
                    begin
                        x_spare = x_BISR[4];
                        y_spare = y_BISR[4];
                        cin_spare = c[4];
                        z_repair = {z[16:5],z_spare,z[3:0]};
                        c_repair = {c[15:6],cout_spare,c[4:0]};
                    end
                4'd5:
                    begin
                        x_spare = x_BISR[5];
                        y_spare = y_BISR[5];
                        cin_spare = c[5];
                        z_repair = {z[16:6],z_spare,z[4:0]};
                        c_repair = {c[15:7],cout_spare,c[5:0]};
                    end
                4'd6:
                    begin
                        x_spare = x_BISR[6];
                        y_spare = y_BISR[6];
                        cin_spare = c[6];
                        z_repair = {z[16:7],z_spare,z[5:0]};
                        c_repair = {c[15:8],cout_spare,c[6:0]};
                    end
                4'd7:
                    begin
                        x_spare = x_BISR[7];
                        y_spare = y_BISR[7];
                        cin_spare = c[7];
                        z_repair = {z[16:8],z_spare,z[6:0]};
                        c_repair = {c[15:9],cout_spare,c[7:0]};
                    end
                4'd8:
                    begin
                        x_spare = x_BISR[8];
                        y_spare = y_BISR[8];
                        cin_spare = c[8];
                        z_repair = {z[16:9],z_spare,z[7:0]};
                        c_repair = {c[15:10],cout_spare,c[8:0]};
                    end
                4'd9:
                    begin
                        x_spare = x_BISR[9];
                        y_spare = y_BISR[9];
                        cin_spare = c[9];
                        z_repair = {z[16:10],z_spare,z[8:0]};
                        c_repair = {c[15:11],cout_spare,c[9:0]};
                    end
                4'd10:
                    begin
                        x_spare = x_BISR[10];
                        y_spare = y_BISR[10];
                        cin_spare = c[10];
                        z_repair = {z[16:11],z_spare,z[9:0]};
                        c_repair = {c[15:12],cout_spare,c[10:0]};
                    end
                4'd11:
                    begin
                        x_spare = x_BISR[11];
                        y_spare = y_BISR[11];
                        cin_spare = c[11];
                        z_repair = {z[16:12],z_spare,z[10:0]};
                        c_repair = {c[15:13],cout_spare,c[11:0]};
                    end
                4'd12:
                    begin
                        x_spare = x_BISR[12];
                        y_spare = y_BISR[12];
                        cin_spare = c[12];
                        z_repair = {z[16:13],z_spare,z[11:0]};
                        c_repair = {c[15:14],cout_spare,c[12:0]};
                    end
                4'd13:
                    begin
                        x_spare = x_BISR[13];
                        y_spare = y_BISR[13];
                        cin_spare = c[13];
                        z_repair = {z[16:14],z_spare,z[12:0]};
                        c_repair = {c[15],cout_spare,c[13:0]};
                    end
                4'd14:
                    begin
                        x_spare = x_BISR[14];
                        y_spare = y_BISR[14];
                        cin_spare = c[14];
                        z_repair = {z[16:15],z_spare,z[13:0]};
                        c_repair = {cout_spare,c[14:1]};
                    end
                4'd15:
                    begin
                        x_spare = x_BISR[15];
                        y_spare = y_BISR[15];
                        cin_spare = c[15];
                        z_repair = {cout_spare,z_spare,z[14:0]};
                        c_repair = c;
                    end
                default:
                    begin
                        x_spare = 1'b0;
                        y_spare = 1'b0;
                        cin_spare = 1'b0;
                        z_repair = z;
                        c_repair = c;
                    end
            endcase
        end
    else  // pass
        begin
            x_spare = 1'b0;
            y_spare = 1'b0;
            cin_spare = 1'b0;
            z_repair = z;
            c_repair = c;
        end    
end
endmodule



module SubModule_BISR (Clk,Rst,En,Test,x,y,cin,z_FA,x_BISR,y_BISR,cin_BISR,P_F,FA_fault_loc);
input Clk, Rst, En, Test;
input [15:0] x, y;
input cin;
input [16:0] z_FA;

output reg [15:0] x_BISR,y_BISR;
output reg cin_BISR;
output reg P_F;
output reg [3:0] FA_fault_loc;

reg [16:0] z_correct,z_compare;

always @(posedge Clk or posedge Rst) 
begin
    if(Rst)
        begin
            cin_BISR <= 1'b0;
            x_BISR <= 16'b0;
            y_BISR <= 16'b0;
            z_correct <= 16'b0;
        end
    else
        begin
            if(Test) // test mode
                begin
                    if(En)  // Use embedded pattern
                        begin
                            case(cin_BISR)
                                1'b0: 
                                    begin
                                        x_BISR <= 16'b1111_1111_1111_1111;
                                        y_BISR <= 16'b1111_1111_1111_1111;
                                        cin_BISR <= 1'b1;
                                        z_correct <= 17'b0; // maybe wrong
                                    end
                                1'b1:
                                    begin
                                        x_BISR <= 16'b0;
                                        y_BISR <= 16'b0;
                                        cin_BISR <= 1'b0;
                                        z_correct <= 17'b1111_1111_1111_1111_1; // maybe wrong
                                    end
                                default: 
                                    begin
                                        x_BISR <= 16'b0;
                                        y_BISR <= 16'b0;
                                        cin_BISR <= 1'b0;
                                        z_correct <= 17'b1111_1111_1111_1111_1;
                                    end
                            endcase
                        end
                    else    // don't change x_FA、y_FA
                        begin
                            x_BISR <= x_BISR;
                            y_BISR <= y_BISR;
                            cin_BISR <= cin_BISR;
                            z_correct <= z_correct;
                        end
                end
            else // normal mode
                begin
                    cin_BISR <= cin;
                    x_BISR <= x;
                    y_BISR <= y;
                end
        end
end

always @(posedge Clk or posedge Rst) 
begin
    if(Rst)
        begin
            P_F <= 0;
            z_compare <= 17'b0;
            FA_fault_loc <= 4'b0;
        end
    else
        begin
            z_compare <= z_FA;
            if(Test)
                begin
                    if(z_compare != z_correct) 
                        begin
                            P_F <= 1'b1;
                            casez (z_compare ^ z_correct)
                                17'b????_????_????_????_1: FA_fault_loc <= 4'd0;
                                17'b????_????_????_???1_0: FA_fault_loc <= 4'd1;
                                17'b????_????_????_??10_0: FA_fault_loc <= 4'd2;
                                17'b????_????_????_?100_0: FA_fault_loc <= 4'd3;
                                17'b????_????_????_1000_0: FA_fault_loc <= 4'd4;
                                17'b????_????_???1_0000_0: FA_fault_loc <= 4'd5;
                                17'b????_????_??10_0000_0: FA_fault_loc <= 4'd6;
                                17'b????_????_?100_0000_0: FA_fault_loc <= 4'd7;
                                17'b????_????_1000_0000_0: FA_fault_loc <= 4'd8;
                                17'b????_???1_0000_0000_0: FA_fault_loc <= 4'd9;
                                17'b????_??10_0000_0000_0: FA_fault_loc <= 4'd10;
                                17'b????_?100_0000_0000_0: FA_fault_loc <= 4'd11;
                                17'b????_1000_0000_0000_0: FA_fault_loc <= 4'd12;
                                17'b???1_0000_0000_0000_0: FA_fault_loc <= 4'd13;
                                17'b??10_0000_0000_0000_0: FA_fault_loc <= 4'd14;
                                17'b?100_0000_0000_0000_0: FA_fault_loc <= 4'd15;
                                17'b1000_0000_0000_0000_0: FA_fault_loc <= 4'd15;
                                default: FA_fault_loc <= FA_fault_loc;
                            endcase
                        end
                    else 
                        begin
                            P_F <= P_F;
                            FA_fault_loc <= FA_fault_loc;
                        end
                end
            else 
                begin
                    P_F <= P_F;
                    FA_fault_loc <= FA_fault_loc;
                end
        end
end

endmodule


module SubModule_FullAdder(cin,x,y,cout,z);
input cin,x,y;
output cout,z;

assign z=cin^x^y;
assign cout= x&y + (x+y)&cin; // G+PCin
endmodule

