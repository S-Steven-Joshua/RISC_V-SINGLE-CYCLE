`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 24.06.2026 13:27:50
// Design Name: 
// Module Name: bridge_tb
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


module bridge_tb;

    logic clk;
    logic rst;
    logic [31:0] addr;
    logic [31:0] data;
    logic memwrite;
    logic dmem_write;

    logic [31:0] pr_data;
    logic wave;
    logic wave1;
    logic wave2;

    bridge bridge1(
        .clk(clk),
        .rst(rst),
        .addr(addr),
        .data(data),
        .memwrite(memwrite),
        .dmem_write(dmem_write),
        .pr_data(pr_data),
        .wave(wave),
        .wave1(wave1),
        .wave2(wave2)
    );

    // Clock
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Monitor
    initial begin
        $monitor(
        "t=%0t addr=%h data=%h memwrite=%b dmem_write=%b wave=%b wave1=%b wave2=%b",
        $time, addr, data, memwrite, dmem_write,
        wave, wave1, wave2
        );
    end

    task automatic cpu_write(
        input [31:0] a,
        input [31:0] d
    );
    begin
        @(negedge clk);
        addr     <= a;
        data     <= d;
        memwrite <= 1'b1;

        @(negedge clk);
        memwrite <= 1'b0;
    end
    endtask

    initial begin

        rst      = 1'b1;
        addr     = 32'b0;
        data     = 32'b0;
        memwrite = 1'b0;

        #20;
        rst = 1'b0;

        // Back-to-back writes
        cpu_write(32'h4000_0000, 32'h0000_0041); // UART
        cpu_write(32'h4000_0008, 32'h000A_0003); // PWM
        cpu_write(32'h4000_000C, 32'h1C0A_000A); // TIMER

        cpu_write(32'h4000_0000, 32'h0000_0042); // UART
        cpu_write(32'h4000_0008, 32'h000F_0005); // PWM
        cpu_write(32'h4000_000C, 32'h0000_0010); // TIMER

        // Normal memory write
        cpu_write(32'h0000_0100, 32'hDEAD_BEEF);

        repeat(300) @(posedge clk);

        $finish;
    end

endmodule