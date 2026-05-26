`timescale 1ns / 1ps

module tb;
    logic clk, rst;
    logic [31:0] write_data, data_add;
    logic mem_write;
    
    // Internal testbench tracking registers
    logic [31:0] verified_x4;
    
    // Instantiate your Top-Level CPU design
    top top1(
        .clk(clk), 
        .rst(rst), 
        .write_data(write_data), 
        .data_add(data_add), 
        .mem_write(mem_write)
    );
    
    // 1. Clock Generation Loop (10ns Period -> 100MHz)
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
      
    // 2. Synchronous Reset Sequence
    initial begin
        rst <= 1; 
        #22; 
        rst <= 0;
    end
    
    // 3. Watchdog Timeout Safety Loop
    initial begin
        #300; 
        $display("\n=========================================================");
        $display("ERROR: Timeout reached without matching addition criteria.");
        $display("=========================================================");
        $stop;
    end
    
    // 4. Live Runtime Debug Logger 
    always @(posedge clk) begin
        if (!rst) begin
            $display("[CYCLE DEBUG] Time: %0tns | PC: 0x%h | Instr: 0x%h | ALU_Out (Address): %d | MemWrite: %b", 
                     $time, top1.pc, top1.instr, data_add, mem_write);
        end
    end

    // 5. Addition Validation Logic
    always @(negedge clk) begin
        #1; // 1ns settling window to clear event-queue races inside XSIM
        
        if (!rst) begin
            // Hierarchically pull the value of register x4 straight from the verified register file array
            verified_x4 = top1.core1.data.r1.register[4]; 
            
            // Checks if the calculation (10 + 20 = 30) is complete
            if (verified_x4 == 30) begin
                $display("\n=========================================================");
                $display("SUCCESS: Simple Addition (10 + 20 = 30) Verified!");
                $display("Register x4 successfully contains: %d", verified_x4);
                $display("=========================================================");
                $stop;
            end
        end
    end 
endmodule: tb
