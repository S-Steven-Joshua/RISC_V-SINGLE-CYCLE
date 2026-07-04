`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2026 09:41:44
// Design Name: 
// Module Name: i2c_top
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


module i2c_top(
    input logic clk,
    input logic rst,
    input logic write,
    input logic [31:0] data_in,
    input logic [7:0] data_in_slave,//from slave side
    output logic busy,
    output logic scl,
    inout logic sda,
    output logic [7:0] data_master,//recieved from slave 
    output logic [7:0] data_slave// recieved from master
    );

    logic scl_rise;
    logic scl_fall;
    //logic [7:0] data_out;
    //logic [7:0] temp;
    
    scl_generator scl_generator1(.clk(clk),.rst(rst),.scl(scl),.scl_rise(scl_rise),.scl_fall(scl_fall));
    i2c_master i2c_master1(.clk(clk),
                           .rst(rst),
                           .scl(scl),
                           .scl_rise(scl_rise),
                           .scl_fall(scl_fall),
                           .write(write),
                           .data_in(data_in),
                           .busy(busy),
                           .data_out(data_master),
                           .sda(sda));
    i2c_slave #(.address(32)) i2c_slave1(.clk(clk),
                         .rst(rst),
                         .scl(scl),
                         .scl_rise(scl_rise),
                         .scl_fall(scl_fall),
                         .data_in(data_in_slave),
                         .sda(sda),
                         .data_out_slave(data_slave));
        


endmodule:i2c_top
