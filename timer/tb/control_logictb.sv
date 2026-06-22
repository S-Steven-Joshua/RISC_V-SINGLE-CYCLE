`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 20:15:33
// Design Name: 
// Module Name: control_logictb
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


module control_logictb;
//    logic clk;
//    logic rst;
    logic [31:0] data_word;
    logic write;
    logic master_busy;
//    logic [3:0] bit_4;
//    logic [7:0] bit_8;
//    logic [11:0] bit_12;
    logic [15:0] bit_16;
    logic [7:0] counter_value;
    logic [5:0] control_word;
    //logic [1:0] size_sel;
    
    control_logic control_logic1(
//        .clk(clk),
//        .rst(rst),
        .data_word(data_word),
        .write(write),
        .master_busy(master_busy),
//        .bit_4(bit_4),
//        .bit_8(bit_8),
//        .bit_12(bit_12),
        .bit_16(bit_16),
        .counter_value(counter_value),
        .control_word(control_word)
        //.size_sel(size_sel)
    );
//    initial begin
//    clk=0;
//    forever #5 clk=~clk;
//    end
    initial begin
    $monitor("Time=%d write=%b data_in=%h bit_16=%b counter_value=%b control_word=%b",
        $time,write,data_word,bit_16,counter_value,control_word);
    end
    
    initial begin
    data_word = '0;
    write     = 0;

    #20;

    // 4-bit normal forward
    write     = 1;
    data_word = 32'h04640007;
    #20;
    write     = 0;
    #20;

    // 8-bit normal reverse
    write     = 1;
    data_word = 32'h082F002F;
    #20;
    write     = 0;
    #20;

    // 12-bit auto forward
    write     = 1;
    data_word = 32'h15000200;
    #20;
    write     = 0;
    #20;

    // 16-bit auto reverse
    write     = 1;
    data_word = 32'h1900C350;
    #20;
    write     = 0;
    #20;

    // 4-bit square forward
    write     = 1;
    data_word = 32'h2600000B;
    #20;
    write     = 0;
    #20;

    // 4-bit square reverse
    write     = 1;
    data_word = 32'h2200000A;
    #20;
    write     = 0;
    #20;

    #100;
    $finish;
end
endmodule:control_logictb
