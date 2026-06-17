`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 02:23:57
// Design Name: 
// Module Name: normal_back_tb
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


module normal_back_tb;
    logic clk;
    logic rst;
    logic write;
    logic [3:0] data_in;
    logic [7:0] count;
    logic wave;
    logic busy;
    
    normal_back #(.N(4)) normal_back1(
        .clk(clk),
        .rst(rst),
        .write(write),
        .data_in(data_in),
        .count(count),
        .wave(wave),
        .busy(busy)
    );
    
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d wave=%b busy=%b counter=%b counter_1=%b write=%b ",$time,wave,busy,
        normal_back.counter,normal_back.counter_1,write  
    );
    end
    
    initial begin
    rst=1;
    #10;
    rst=0;
    
    @(posedge clk);
    write=1'b1;
    data_in=4'b1100;
    count=8'b0000_0100;
    @(posedge clk);
    write=0;
    #200;
    
//    @(posedge clk);
//    write=1;
//    data_in=4'b0000;
//    @(posedge clk);
//    write=0;
//    #200;
    
//    @(posedge clk);
//    data_in=8'b1111;
//    count=8'b1111;
//    #300;
    
    $finish;
    end
endmodule:normal_back_tb
