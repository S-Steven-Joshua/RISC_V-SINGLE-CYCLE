`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 01:16:10
// Design Name: 
// Module Name: square_back_tb
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


module square_back_tb;
    logic clk;
    logic rst;
    logic write;
    logic [3:0] data_in;
    logic pready_p;
    logic wave;
    
    square_back #(.N(4))square_back1(
        .clk(clk),
        .rst(rst),
        .write(write),
        .data_in(data_in),
        .pready_p(pready_p),
        .wave(wave)
    );
    
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d write=%b data_in=%b wave=%b count=%b",$time,write,data_in,wave,square_back.counter);
    end
    
    initial begin
    rst=1;
    data_in='0;
    write=0;
    #10;
    rst=0;
    @(posedge clk);
    write=1;
    data_in=4'b0110;
    @(posedge clk);
    write=0;
    #300;
    
    @(posedge clk);
    write=1;
    data_in=4'b0000;
    @(posedge clk);
    write=0;
    
    #200;
    $finish;
    end
endmodule
