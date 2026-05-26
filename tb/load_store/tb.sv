`timescale 1ns / 1ps
module tb;
    logic clk, rst;
    logic [31:0] write_data, data_add;
    logic mem_write;
    
    // Internal testbench tracking register
    logic [31:0] verified_x6;
    
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
        #400; 
        $display("\n=========================================================");
        $display("ERROR: Timeout reached. Memory access might be failing.");
        $display("=========================================================");
        $stop;
    end
    
    // 4. Live Runtime Debug Logger 
    always @(posedge clk) begin
        if (!rst) begin
            $display("[CYCLE DEBUG] Time: %0tns | PC: 0x%h | Instr: 0x%h | ALU_Out: %d | MemWrite: %b", 
                     $time, top1.pc, top1.instr, data_add, mem_write);
        end
    end

    // 5. Load/Store Validation Logic
    always @(negedge clk) begin
        #1; // 1ns settling window
        
        if (!rst) begin
            // Hierarchically pull x6 from your register file
            verified_x6 = top1.core1.data.r1.register[6]; 
            
            // Success Criteria: 
            // The value 10 was stored to memory and loaded back into x6
            if (verified_x6 == 10) begin
                $display("\n=========================================================");
                $display("SUCCESS: Load/Store Memory Access Verified!");
                $display("  -> Register x6 correctly holds: %d", verified_x6);
                $display("=========================================================");
                $stop;
            end
        end
    end 
endmodule: tb