`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 18:03:16
// Design Name: 
// Module Name: control_logic
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


module control_logic(
    input logic clk,
    input logic rst,
    input logic [31:0] data_word,
    input logic write,
    output logic master_busy,
    output logic [3:0] bit_4,
    output logic [7:0] bit_8,
    output logic [11:0] bit_12,
    output logic [15:0] bit_16,
    output logic [7:0] counter_value,
    output logic [5:0] control_word,//(direction,mode)
    output logic [1:0] size_sel
    );
    //control word 6-square back 5-square 4-auto back 3-auto 2-normal back 1-normal
    //data_word [31:0]
    //in that [15:0] is the data or counter value
    //next counter value for normal mode [23:16]
    //[25:24] is the selection of the mode 3 mode=> normal,auto,quare(00,01,10)
    //[26] is for the forward or backword, 1 for forward 0 for backword
    //[28:27] is for selection of size//00-
    //rest bits for the time being no use
    
    logic [31:0] mem;
    logic [1:0] mode;
    logic direction;
    logic [1:0] size;
    
    always_ff @ (posedge clk)
        begin
        if(rst)
            begin
            direction<='0;
            mode<='0;
            size<='0;
            mem<=32'b0;
            bit_4<='0;
            bit_8<='0;
            bit_12<='0;
            bit_16<='0;
            counter_value<='0;
            control_word<='0;
            size_sel<='0;
            end
        else
            begin
            if(write)
                begin
                mem<=data_word;
                mode<=data_word[25:24];
                direction<=data_word[26];
                size<=mem[28:27];
                end
            else
                begin
                mode<=mem[25:24];
                direction<=mem[26];
                size<=mem[28:27];
                end
            case(mode)
                2'b00: 
                begin
                //normal mode
                    case(size)
                        2'b00:
                        begin
                            if(direction)
                                begin
                                    control_word<=6'b000_001;//normal mode forward direction 4 bit
                                    bit_4<=mem[3:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b00;
                                end
                            else
                                begin
                                    control_word<=6'b000_010;//normal mode reverse direction 4 bit
                                    bit_4<=mem[3:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b00;
                                end
                        end
                        2'b01:
                        begin
                                if(direction)
                                begin
                                    control_word<=6'b000_001;//normal mode forward direction 8 bit
                                    bit_8<=mem[7:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b01;
                                end
                            else
                                begin
                                    control_word<=6'b000_010;//normal mode reverse direction 8 bit
                                    bit_8<=mem[7:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b01;
                                end
                        end
                        2'b10:
                        begin
                            if(direction)
                                begin
                                    control_word<=6'b000_001;//normal mode forward direction 12 bit
                                    bit_12<=mem[11:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b10;
                                end
                            else
                                begin
                                    control_word<=6'b000_010;//normal mode reverse direction 12 bit
                                    bit_12<=mem[11:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b10;
                                end
                        end
                        2'b11:
                        begin
                                if(direction)
                                begin
                                    control_word<=6'b000_001;//normal mode forward direction 16 bit
                                    bit_16<=mem[15:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b11;
                                end
                            else
                                begin
                                    control_word<=6'b000_010;//normal mode reverse direction 16 bit
                                    bit_16<=mem[15:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b11;
                                end
                        end
                    default:
                    begin
                            bit_4<='0;
                            bit_8<='0;
                            bit_12<='0;
                            bit_16<='0;
                            counter_value<='0;
                            control_word<='0;
                            size_sel<='0;
                    end
                    endcase
                end

                2'b01:
                begin
                    //auto mode
                        case(size)
                        2'b00: 
                        begin
                            if(direction)
                                begin
                                    control_word<=6'b000_100;//auto mode forward direction 4 bit
                                    bit_4<=mem[3:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b00;
                                end
                            else
                                begin
                                    control_word<=6'b001_000;//auto mode reverse direction 4 bit
                                    bit_4<=mem[3:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b00;
                                end
                        end
                        2'b01:
                        begin
                                if(direction)
                                begin
                                    control_word<=6'b000_100;//auto mode forward direction 8 bit
                                    bit_8<=mem[7:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b01;
                                end
                            else
                                begin
                                    control_word<=6'b001_000;//auto mode reverse direction 8 bit
                                    bit_8<=mem[7:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b01;
                                end
                        end
                        2'b10:
                        begin
                            if(direction)
                                begin
                                    control_word<=6'b000_100;//auto mode forward direction 12 bit
                                    bit_12<=mem[11:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b10;
                                end
                            else
                                begin
                                    control_word<=6'b001_000;//auto mode reverse direction 12 bit
                                    bit_12<=mem[11:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b10;
                                end
                        end
                        2'b11:
                        begin
                                if(direction)
                                begin
                                    control_word<=6'b000_100;//auto mode forward direction 16 bit
                                    bit_16<=mem[15:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b11;
                                end
                            else
                                begin
                                    control_word<=6'b001_000;//auto mode reverse direction 16 bit
                                    bit_16<=mem[15:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b11;
                                end
                        end
                    default:
                    begin
                            bit_4<='0;
                            bit_8<='0;
                            bit_12<='0;
                            bit_16<='0;
                            counter_value<='0;
                            control_word<='0;
                            size_sel<='0;
                    end
                    endcase
                end

                2'b10:
                begin
                    //square
                        case(size)
                        2'b00: 
                        begin
                            if(direction)
                                begin
                                    control_word<=6'b010_000;//normal mode forward direction 4 bit
                                    bit_4<=mem[3:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b00;
                                end
                            else
                                begin
                                    control_word<=6'b100_000;//normal mode reverse direction 4 bit
                                    bit_4<=mem[3:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b00;
                                end
                        end
                        2'b01:
                        begin
                                if(direction)
                                begin
                                    control_word<=6'b010_000;//square mode forward direction 8 bit
                                    bit_8<=mem[7:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b01;
                                end
                            else
                                begin
                                    control_word<=6'b100_000;//square mode reverse direction 8 bit
                                    bit_8<=mem[7:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b01;
                                end
                        end
                        2'b10:
                        begin
                            if(direction)
                                begin
                                    control_word<=6'b010_000;//square mode forward direction 12 bit
                                    bit_12<=mem[11:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b10;
                                end
                            else
                                begin
                                    control_word<=6'b100_000;//square mode reverse direction 12 bit
                                    bit_12<=mem[11:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b10;
                                end
                        end
                        2'b11:
                        begin
                                if(direction)
                                begin
                                    control_word<=6'b010_000;//square mode forward direction 16 bit
                                    bit_16<=mem[15:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b11;
                                end
                            else
                                begin
                                    control_word<=6'b100_000;//square mode reverse direction 16 bit
                                    bit_16<=mem[15:0];
                                    counter_value<=mem[23:16];
                                    size_sel<=2'b11;
                                end
                        end
                    default:
                    begin
                            bit_4<='0;
                            bit_8<='0;
                            bit_12<='0;
                            bit_16<='0;
                            counter_value<='0;
                            control_word<='0;
                            size_sel<='0;
                    end
                    endcase
                end
                default:
                begin
                    bit_4<='0;
                    bit_8<='0;
                    bit_12<='0;
                    bit_16<='0;
                    counter_value<='0;
                    control_word<='0;
                    size_sel<='0;
                end
            endcase
            end
        end
          
endmodule:control_logic
