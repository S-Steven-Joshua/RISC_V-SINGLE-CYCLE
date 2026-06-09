`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2026 11:05:40
// Design Name: 
// Module Name: top
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


module top(
    input logic clk,
    input logic prstn,
    input logic [31:0] paddr,
    input logic [31:0] data,
    input logic  pready_p,
    //input logic pwrite,
    output logic [31:0] p_data,
    output logic pready
    );
    
    //logic pready;
    logic psel;
    logic penable;
    logic pwrite;
    logic [31:0] pwdata;
    logic trans;
    
    apb_master apb_master1(
        .clk(clk),
        .prstn(prstn),
        .paddr(paddr),
        .data(data),
        .pready(pready),
        .psel(psel),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .trans(trans)
        );
    apb_slave apb_slave1(
        .clk(clk),
        .prstn(prstn),
        .psel(psel),
        .trans(trans),
        .pready_p(pready_p),
        .penable(penable),
        .pwrite(pwrite),
        .pwdata(pwdata),
        .p_data(p_data),
        .pready(pready)
        ); 
       
endmodule:top
