`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.06.2026 18:37:07
// Design Name: 
// Module Name: top_tb
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


module top_tb;

    logic clk;
    logic prstn;
    logic [31:0] paddr;
    logic [31:0] data;
    logic pready_p;
    logic [31:0] p_data;
    logic pready;

    top top1(
        .clk(clk),
        .prstn(prstn),
        .paddr(paddr),
        .data(data),
        .pready_p(pready_p),
        .p_data(p_data),
        .pready(pready)
    );

    //---------------------------------------
    // Clock
    //---------------------------------------
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    //---------------------------------------
    // Monitor
    //---------------------------------------
    initial begin
        $monitor(
        "t=%0t mstate=%0d psel=%b penable=%b trans=%b pready_p=%b pdata=%h",
        $time,
        top1.apb_master1.state,
        top1.apb_master1.psel,
        top1.apb_master1.penable,
        top1.apb_master1.trans,
        pready_p,
        p_data
        );
    end

    //---------------------------------------
    // APB WRITE TASK
    //---------------------------------------
    task automatic apb_write(
        input [31:0] addr,
        input [31:0] wr_data,
        input integer wait_cycles
    );
    begin

        @(posedge clk);

        paddr    <= addr;
        data     <= wr_data;
        pready_p <= 0;

        repeat(wait_cycles)
            @(posedge clk);

        pready_p <= 1;

        @(posedge clk);

        // Remove request so master returns idle
        paddr    <= 32'h0000_0000;
        data     <= 32'h0000_0000;

        @(posedge clk);

        pready_p <= 0;

    end
    endtask

    //---------------------------------------
    // Stimulus
    //---------------------------------------
    initial begin

        prstn    = 0;
        paddr    = 0;
        data     = 0;
        pready_p = 0;

        //-----------------------------------
        // Reset
        //-----------------------------------
        #20;
        prstn = 1;

        //-----------------------------------
        // TEST 1
        //-----------------------------------
        $display("\n========== TEST1 ==========");
        $display("WRITE DEADBEEF");

        apb_write(
            32'h4000_0000,
            32'hDEADBEEF,
            2
        );

        //-----------------------------------
        // TEST 2
        //-----------------------------------
        $display("\n========== TEST2 ==========");
        $display("WRITE CAFEBABE");

        apb_write(
            32'h4000_0000,
            32'hCAFEBABE,
            2
        );

        //-----------------------------------
        // TEST 3
        //-----------------------------------
        $display("\n========== TEST3 ==========");
        $display("WAIT STATE TEST");

        apb_write(
            32'h4000_0000,
            32'h12345678,
            5
        );

        //-----------------------------------
        // TEST 4
        //-----------------------------------
        $display("\n========== TEST4 ==========");
        $display("SECOND APB ADDRESS");

        apb_write(
            32'h4000_0004,
            32'h5555AAAA,
            2
        );

        //-----------------------------------
        // TEST 5
        //-----------------------------------
        $display("\n========== TEST5 ==========");
        $display("INVALID ADDRESS");

        @(posedge clk);

        paddr    <= 32'h2000_0000;
        data     <= 32'hAAAAAAAA;
        pready_p <= 1;

        repeat(5) @(posedge clk);

        //-----------------------------------
        // End Simulation
        //-----------------------------------
        $display("\n========== DONE ==========");
        #20;
        $finish;

    end

endmodule
