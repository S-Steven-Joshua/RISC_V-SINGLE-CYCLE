`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.06.2026 18:44:33
// Design Name: 
// Module Name: auto_back
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


module auto_back #(parameter N=4)(
    input logic clk,
    input logic rst,
    input logic write,
    input logic [N-1:0] data_in,
    output logic pready_p,
    output logic wave
    );
    
    logic [N-1:0] mem;
    logic [N-1:0] counter;
    logic write_pending;
    logic running;
    
    assign pready_p=1'b1;
    
    typedef enum logic [1:0] {idle,counting} state_t;
    state_t state;
    always_ff @ (posedge clk)
    begin
        if(rst)
        begin
            //busy<=1'b0;
            wave<=1'b0;
            mem<='0;
            counter<='0;
            running<=1'b0;
            write_pending<=1'b0;
            state<=idle;
        end
        else
            begin
                if(write)
                    begin
                    mem<=data_in;
                    if(data_in != '0)
                        begin
                        write_pending<=1'b1;
                        running<=1'b1;
                        end
                    else
                        begin
                        write_pending<=1'b0;
                        running<=1'b0;
                        end
                    end
                case(state)
                    idle:
                        begin
                            wave<=1'b0;
                            if(write_pending)
                                begin
                                counter<=mem;
                                write_pending<=1'b0;
                                //busy<=1'b1;
                                state<=counting;
                                end
                            else
                                begin
                                //busy<=1'b0;
                                end              
                        end
                    counting:
                        begin
                            //busy<=1'b1;
                                if(!running)
                                    begin
                                    state<=idle;
                                    //busy<=1'b0;
                                    wave<=1'b0;
                                    end
                                else if(counter == '0)
                                    begin
                                    wave<=1'b1;
                                    counter<=mem;  
                                    end
                                else
                                    begin
                                    counter<=counter-1'b1;
                                    wave<=1'b0;
                                    end       
                            end
                        default:state<=idle;
                        endcase
                end
        end
                                
endmodule:auto_back
