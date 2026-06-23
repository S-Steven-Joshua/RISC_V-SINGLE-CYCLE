`timescale 1ns / 1ps   
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 00:28:08
// Design Name: 
// Module Name: master_tb
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


module master_tb;
    logic clk;
    logic rst;
    logic [31:0] paddr;
    logic [31:0] data_p;
    logic apb_write;
    logic [31:0] pr_data;
    logic wave;
    logic wave1;
    logic wave2;
    
    master master1(
                   .clk(clk),
                   .rst(rst),
                   .paddr(paddr),
                   .data_p(data_p),
                   .apb_write(apb_write),
                   .pr_data(pr_data),
                   .wave(wave),
                   .wave1(wave1),
                   .wave2(wave2)
                );
    initial begin
    clk=0;
    forever #5 clk=~clk;
    end
    
    initial begin
    $monitor(
    "T=%0t TX=%h RX=%h READY=%b CLR=%b CNT=%0d OUT=%h",
    $time,
    master.apb_slave_uart1.uart_soc1.uart_tx1.data_in,
    master.apb_slave_uart1.uart_soc1.uart_rx1.data_out,
    master.apb_slave_uart1.uart_soc1.ready,
    master.apb_slave_uart1.uart_soc1.rdy_clear,
    master.apb_slave_uart1.uart_soc1.deserializer1.counter,
    master.apb_slave_uart1.uart_soc1.deserializer1.data_out
    );
end


   
   initial begin
   rst=1;
   paddr='0;
   data_p='0;
   apb_write='0;
   #20;
   rst=0;
   
   @(posedge clk);
   paddr=32'h4000_0000;
   data_p=32'hdead_beef;
   apb_write=1;
   @(posedge clk);
   apb_write=0;
   #1000;
   @(posedge clk);
   paddr=32'h4000_0008;
   data_p=32'h000A_0003;
   apb_write=1;
   @(posedge clk);
   apb_write=0;
   #300;
   @(posedge clk);
   paddr=32'h4000_0008;
   data_p=32'h0000_0000;
   apb_write=1;
   @(posedge clk);
   apb_write=0;
   #300;
   @(posedge clk);
   paddr=32'h4000_000C;
   data_p=32'h1C0A000A;
   apb_write=1;
   @(posedge clk);
   apb_write=0;
   #200;
   @(posedge clk);
   paddr=32'h4000_0013;
   data_p=32'h06000003;
   apb_write=1;
   @(posedge clk);
   apb_write=0;
   #200;
   @(posedge clk);
   paddr=32'h4000_0013;
   data_p=32'h06000000;
   apb_write=1;
   @(posedge clk);
   apb_write=0;
   #200;
   $finish;
   end
endmodule:master_tb
