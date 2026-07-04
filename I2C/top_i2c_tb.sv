`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04.07.2026 09:47:05
// Design Name: 
// Module Name: top_i2c_tb
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


module top_i2c_tb;
    logic clk;
    logic rst;
    logic write;
    logic [31:0] data_in;
    logic busy;
    logic scl;
    wire sda;
    pullup(sda);
    logic [7:0] data_slave;
    logic [7:0] data_master;
    logic [7:0] data_in_slave;
    
    i2c_top i2c_top1(.clk(clk),
                     .rst(rst),
                     .write(write),
                     .data_in(data_in),
                     .busy(busy),
                     .scl(scl),
                     .sda(sda),
                     .data_slave(data_slave),
                     .data_master(data_master),
                     .data_in_slave(data_in_slave)
                     );
    
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
always @(posedge clk) begin
    #1;
        $display("cnt=%0d tx=%8b sda_drive_low=%b sda=%b master_state=%b recieved_address=%b slave_state=%b",
                 i2c_top.i2c_master1.add_counter,
                 i2c_top.i2c_master1.tx,
                 i2c_top.i2c_master1.sda_drive_low,
                 sda,
                 i2c_top.i2c_master1.state,
                 i2c_top.i2c_slave1.rx,
                 i2c_top.i2c_slave1.state
                 );
end
    
    initial begin
    @(posedge clk);
    rst=1;
    write=0;
    data_in=0;
    @(posedge clk);
    rst=0;
    
    @(posedge clk);
    write=1;
    data_in=32'h403C0000;
    @(posedge clk);
    write=0;
    data_in='0;
    
   
    //$finish;
    end
endmodule:top_i2c_tb
