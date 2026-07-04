`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03.07.2026 17:44:27
// Design Name: 
// Module Name: scl_generator
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

 
module scl_generator #(parameter count=10,value=2) (
    input logic clk,
    input logic rst,
    output logic scl,
    output logic scl_fall,
    output logic scl_rise
    );
    logic [count-1:0] counter;
    
    always_ff @ (posedge clk)
        begin
        if(rst)
            begin
            counter<='0;
            scl<=1;
            scl_fall<=1'b0;
            scl_rise<=1'b0;
            end
        else
            begin
            if(counter==value-1)
                begin
                counter<='0;
                if(scl)
                    begin
                    scl<=0;
                    scl_rise<=1'b0;
                    scl_fall<=1'b1;
                    end
                else
                    begin
                    scl<=1'b1;
                    scl_rise<=1'b1;
                    scl_fall<=1'b0;
                    end
                    
                end
            else
                begin
                counter<=counter+1'b1;
                scl_fall<=1'b0;
                scl_rise<=1'b0;
                end
            end    
        end
endmodule:scl_generator
