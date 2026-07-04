`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 17:50:28
// Design Name: 
// Module Name: scl_generator_tb
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


module scl_generator_tb;
    logic clk;
    logic rst;
    logic scl;
    logic scl_rise;
    logic scl_fall;
    
    scl_generator #(.count(10),.value(2)) scl_generator1(
                                                          .clk(clk),
                                                          .rst(rst),
                                                          .scl(scl),
                                                          .scl_fall(scl_fall),
                                                          .scl_rise(scl_rise)
                                                          );
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    @(posedge clk);
    rst=1;
    scl=0;
    scl_rise=0;
    scl_fall=0;
    @(posedge clk);
    rst=0;
    #10;
    end
endmodule:scl_generator_tb
