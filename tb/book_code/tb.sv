`timescale 1ns / 1ps

module tb;
    logic clk, rst;
    logic [31:0] write_data, data_add;
    logic mem_write;
    
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
        #1000; 
        $display("\n=================================================");
        $display("ERROR: Timeout reached without matching final benchmark criteria.");
        $display("=================================================");
        $stop;
    end
    
    // 4. Live Runtime Debug Logger 
    always @(posedge clk) begin
        if (!rst) begin
            $display("[CYCLE DEBUG] Time: %0tns | PC: 0x%h | Instr: 0x%h | ALU_Out (Address): %d | MemWrite: %b", 
                     $time, top1.pc, top1.instr, data_add, mem_write);
        end
    end

    // 5. Benchmark Self-Checking Verification Logic
    always @(negedge clk) begin
        if (mem_write) begin
            // Hierarchically pull the exact integer value of register x2 straight from your verified register file array
            logic [31:0] verified_x2;
            
            // FIXED: Added [2] index to resolve Vivado's unpacked-to-packed elaboration type error
            verified_x2 = top1.core1.data.r1.register[2]; 
            
            $display(">> [STORE DETECTED] CPU targets Memory Address %d | Internal Register x2 contains: %d", data_add, verified_x2);
            
            // Checks for the official benchmark criteria: Value 25 stored at address 100
            if (data_add == 100 && verified_x2 == 25) begin
                $display("\n=========================================================");
                $display("SUCCESS: Benchmark program completed successfully!");
                $display("Value 25 was cleanly stored at address 100.");
                $display("=========================================================");
                $stop;
            end
        end
    end 
endmodule: tb
