`timescale 1ns / 1ps 
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 01:33:32
// Design Name: 
// Module Name: normal_back
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


module normal_back #(parameter N=4)(
    input logic clk,
    input logic rst,
    input logic write,
    input logic [N-1:0] data_in,
    input logic [3:0] count,
    output logic wave,
    output logic busy
    );
    logic [N-1:0] mem;
    logic [3:0] mem_1;
    logic [N-1:0] counter;
    logic [3:0] counter_1;
    
    logic write_pending;
    typedef enum logic [1:0] {idle,counting,pulse} state_t;
    state_t state;
    
    always_ff @ (posedge clk)
        begin
        if(rst)
            begin
            mem<='0;
            mem_1<='0;
            counter<='0;
            counter_1<='0;
            busy<=1'b0;
            wave<=1'b0;
            end
        else
            begin
            if(write)
                begin
                    mem<=data_in;
                    mem_1<=count;
                    if(data_in != '0)
                        begin
                        write_pending<=1'b1;
                        end  
                end
            case(state)
                idle:
                    begin
                        wave<=1'b0;
                        if(write_pending)
                            begin
                            counter<=mem;
                            counter_1<='0;
                            busy<=1'b1;
                            write_pending<=1'b0;
                            state<=counting;
                            end
                        else
                            begin
                            busy<=1'b0;
                            end
                    end
                counting:
                    begin
                        busy<=1'b1;
                        if(counter == '0)
                            begin
                                wave<=1'b1;
                                if(mem_1==4'b0)
                                    begin
                                        state<=idle;
                                    end
                                else
                                    begin
                                        state<=pulse;
                                    end
                            end  
                        else
                            begin
                                counter<=counter-1'b1;
                            end
                    end
                    
                    pulse:
                        begin
                            wave<=1'b1;
                            busy<=1'b1;
                            if(counter_1==mem_1)
                                begin
                                    counter_1<='0;
                                    wave<=1'b0;
                                    busy<=1'b0;
                                    state<=idle;
                                    mem<='0;
                                    mem_1<='0;
                                end
                            else
                                begin
                                    counter_1<=counter_1+1'b1;
                                end
                        end
                   default:state<=idle;
                   endcase
                end
        end                                             
     
endmodule:normal_back
