`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.05.2026 19:13:35
// Design Name: 
// Module Name: apb_master
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


module apb_master(
    input  logic        clk,
    input  logic        prstn,
    input  logic [31:0] paddr,
    input  logic [31:0] data,    // CPU data
    input  logic        pready,  // Input from slave
    input  logic        apb_write,//from the bridge
    output logic  [1:0] psel,
    output logic        penable,
    output logic        pwrite,
    output logic [31:0] pwdata,
    output logic        trans
);
    typedef enum logic [1:0] {idle, setup, access} state_t;
    state_t state;
    //uart -4000_0000 to 4000_0008 01
    //pwm -4000_00008 to 4000_000C 10
    //timer-4000_0000C to 4000_0014 11
    always_ff @(posedge clk or negedge prstn) begin
        if(!prstn) begin
            psel    <= 1'b0;
            penable <= 1'b0;
            pwrite  <= 1'b0;
            pwdata  <= 32'b0;
            trans   <= 1'b0;
            state   <= idle;
        end else begin
            case(state)
                idle: begin
                    penable <= 1'b0;
                    // Check if CPU is currently targeting the peripheral
                    if((paddr >= 32'h4000_0000) && (paddr < 32'h4000_0008) && apb_write) 
                    begin
                        psel   <= 2'b01;
                        trans  <= 1'b1;
                        pwdata <= data;
                        pwrite <= 1'b1;
                        state  <= setup;
                    end 
                    else if((paddr >= 32'h4000_0008) && (paddr < 32'h4000_000C) && apb_write)//pwm
                    begin
                        psel   <= 2'b10;
                        trans  <= 1'b1;
                        pwdata <= data;
                        pwrite <= 1'b1;
                        state  <= setup;
                    end 
                    else if((paddr >= 32'h4000_000C) && (paddr < 32'h4000_0014) && apb_write)//timer
                    begin
                        psel   <= 2'b11;
                        trans  <= 1'b1;
                        pwdata <= data;
                        pwrite <= 1'b1;
                        state  <= setup;
                    end
                    else 
                    begin
                        psel   <= '0;
                        trans  <= 1'b0;
                        state  <= idle;
                    end
                end
                
                setup: begin
                    penable <= 1'b1;
                    state   <= access;
                end
                
                access: begin
                    //penable<=1'b1;
                    if(pready) begin
                        // Transaction complete! Cleanly shut down the bus
                        psel    <= '0;
                        penable <= 1'b0;
                        trans   <= 1'b0;
                        pwrite  <= 1'b0;
                        state   <= idle; // Always return to idle, no back-to-back allowed
                    end else begin
                        // Slave is not ready yet, freeze all bus lines
                        state   <= access;
                    end
                end
                
                default: state <= idle;
            endcase
        end
    end
endmodule: apb_master

