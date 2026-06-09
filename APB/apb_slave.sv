`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 17:46:17
// Design Name: 
// Module Name: apb_slave
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


module apb_slave(
    input  logic        clk,
    input  logic        prstn,
    input  logic        psel,
    input  logic        trans,
    input  logic        pready_p, // Input from the external peripheral
    input  logic        penable,
    input  logic        pwrite,
    input  logic [31:0] pwdata,
    output logic [31:0] p_data,
    output logic        pready    
);
    always_ff @ (posedge clk)
    begin
        if(!prstn)
        p_data<=32'b0;
        else if(pready_p && penable && pwrite && psel && trans)
            begin
            p_data<=pwdata;
            end
    end
    assign pready=pready_p;
endmodule: apb_slave

