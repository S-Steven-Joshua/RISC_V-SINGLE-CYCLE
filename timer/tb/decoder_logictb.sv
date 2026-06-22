`timescale 1ns / 1ps  
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 11:55:37
// Design Name: 
// Module Name: decoder_logictb
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


module decoder_logictb;
    logic clk;
    logic rst;
    logic [15:0] bit_16;
    logic [7:0] counter_value;
    logic [5:0] control_word;
    logic ready;
    logic wave1;
    logic wave2;
    
    decoder_logic decoder_logic1(
        .clk(clk),
        .rst(rst),
        .bit_16(bit_16),
        .counter_value(counter_value),
        .control_word(control_word),
        .ready(ready),
        .wave1(wave1),
        .wave2(wave2)
    );
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor("Time=%d rst=%d bit=%d counter_value=%d control_word=%b ready=%b wave1=%b wave2=%b normal_counter=%b normal_i_counter=%b sqaure_counter=%b  ",
        $time,rst,bit_16,counter_value,control_word,ready,wave1,wave2,decoder_logic.normal_time.counter,decoder_logic.normal_time.counter_1,decoder_logic.square_time.counter);
    end
    
    initial begin
    rst=1;
    bit_16='0;
    counter_value='0;
    control_word='0;
    #20;
    rst=0;
    #10;
    
    bit_16=16'b0000_0000_0000_1000;
    counter_value=8'b0000_1011;
    control_word=6'b000_001;
    #300;
    bit_16=16'b0000_0000_0000_1000;
    counter_value=8'b0000_1011;
    control_word=6'b010_000;
    #300;
    bit_16=16'b0000_0000_0000_0000;
    counter_value=8'b0000_1011;
    control_word=6'b010_000;
    #100;
    $finish;
    end
endmodule:decoder_logictb
