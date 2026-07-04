`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2026 12:56:14
// Design Name: 
// Module Name: i2c_slave
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


module i2c_slave #(parameter address=7'd32)(
    input logic clk,
    input logic rst,
    input logic scl,
    input logic scl_rise,
    input logic scl_fall,
    input logic [7:0] data_in,
    inout logic sda,
    output logic [7:0] data_out_slave
    );

    logic [2:0] add_counter_slave;
    logic [7:0] rx;
    logic sda_drive_low_slave;
    logic [2:0] write_counter_slave;
    logic [2:0] read_counter_slave;
    logic [7:0] mem;
    typedef enum logic [3:0] {idle,read_add,add_ack_send,read_state_slave,write_state_slave,write_ack,master_ack,stop} state_t;
    state_t state;
    
    logic [7:0] rx_temp;
    always_comb
    begin
        rx_temp={rx[6:0],sda};
    end
    always_ff @ (posedge clk)
    begin
        if(rst)
        begin
            add_counter_slave<='0;
            rx<='0;
            state<=idle;
            data_out_slave<='0;
            sda_drive_low_slave<=1'b0;
            write_counter_slave<='0;
            read_counter_slave<='0;
            mem<='0;
        end
        else
        begin
            case(state)
            idle:
            begin
                if(scl && !sda)
                begin
                    state<=read_add;
                    add_counter_slave<='0;
                    write_counter_slave<='0;
                    read_counter_slave<='0;
                    mem<='0;
                end
                else
                begin
                    state<=idle;
                end
            end
            read_add:
            begin
                if(scl_rise)
                begin
                    rx<={rx[6:0],sda};
                    if(add_counter_slave == 3'b111)
                    begin
                        if(rx_temp[7:1] == address)
                        begin
                        state<=add_ack_send;
                        end
                        else
                        begin
                            state<=idle;
                        end
                    end
                    else
                    begin
                        add_counter_slave<=add_counter_slave+1'b1;
                    end
                end
                else
                begin
                    state<=read_add;
                end
            end
            add_ack_send:
            begin
                $display("SLAVE drives ACK at %0t", $time);
                sda_drive_low_slave<=1'b1;
                if(scl_rise)
                begin
                    sda_drive_low_slave<=1'b0;
                    if(!rx[0])
                    begin
                        state<=read_state_slave;
                    end
                    else
                    begin
                        state<=write_state_slave;
                        mem<=data_in;
                    end
                end
            end
            read_state_slave:
            begin
                
                if(scl_rise)
                begin
                    data_out_slave<={data_out_slave[6:0],sda};
                    if(read_counter_slave == 3'b111)
                    begin
                        state<=write_ack;
                    end
                    else
                    begin
                        read_counter_slave<=read_counter_slave+1'b1;
                    end
                end
                else
                begin
                    state<=read_state_slave;
                end
            end
            write_state_slave:
            begin
                if(scl_fall)
                begin
                    if(mem[7])
                    begin
                        sda_drive_low_slave<=1'b0;
                    end
                    else
                    begin
                        sda_drive_low_slave<=1'b1;
                    end
                end
                else if(scl_rise)
                begin
                    mem<=mem<<1;
                    if(write_counter_slave==3'b111)
                    begin
                        state<=master_ack;
                    end
                    else
                    begin
                        write_counter_slave<=write_counter_slave+1'b1;
                    end
                end
                else
                begin
                    state<=write_state_slave;
                end
            end
            master_ack: //for master ack to say recieved data single byte read from master
            begin
                if(scl_rise)
                begin
                    if(sda)
                    begin
                        state<=stop;
                    end
                end
                else
                begin
                    state<=master_ack;
                end
            end
            write_ack:
            begin
                if(scl_fall)
                begin
                    sda_drive_low_slave<=1'b1;
                    state<=stop;
                end
                else
                begin
                    state<=write_ack;
                end
            end
            stop:
            begin
                if(scl_rise)
                begin
                    state<=idle;
                end
                else
                begin
                    state<=stop;
                end
            end
            default:state<=idle;
            endcase
        end
    end
    assign sda=sda_drive_low_slave ? 1'b0 : 1'bz;
endmodule
