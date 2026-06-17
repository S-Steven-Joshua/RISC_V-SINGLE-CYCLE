`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 18.06.2026 00:59:26
// Design Name: 
// Module Name: square_back
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


module square_back #(parameter N=4)(
    input logic clk,
    input logic rst,
    input logic write,
    input logic [N-1:0] data_in,
    output logic wave,
    output logic pready_p
    );
    assign pready_p=1'b1;
    
    logic [N-1:0] mem;
    logic [N-1:0] counter;
    logic write_pending;
    logic running;
    typedef enum logic [1:0] {idle,counting} state_t;
    state_t state;
    
    always_ff @ (posedge clk)
        begin
        if(rst)
            begin
            mem<='0;
            counter<='0;
            write_pending<=1'b0;
            running<=1'b0;
            wave<=1'b0;
            state<=idle;
            end
        else
            begin
            if(write)
                begin
                mem<=data_in;
                if(data_in !='0)
                    begin
                    running<=1'b1;
                    write_pending<=1'b1;
                    end
                else
                    begin
                    running<=1'b0;
                    write_pending<=1'b0;
                    end
                end
                case(state)
                    idle:
                        begin
                        wave<=1'b0;
                        if(write_pending)
                            begin
                            counter<=mem;
                            write_pending<=0;
                            state<=counting;
                            end
                        else
                            begin
                            end
                        end
                    counting:
                        begin
                        wave<=1'b0;
                        if(!running)
                            begin
                            state<=idle;
                            wave<=1'b0;
                            end
                        else if(counter =='0)
                            begin
                            wave<=~wave;
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
        
        
endmodule:square_back
