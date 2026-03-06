
/*
module TRY (
    input [3:0] i_a,
    input [3:0] i_b,
    input i_clk,
    input i_rst_n,
    output [4:0] o_result_add,
    output [4:0] o_result_sub
);
    function  [4:0] add;
        input [3:0] a;
        input [3:0] b;
        reg [4:0] sum; // 5 bits to hold the carry

        begin
            sum = a + b; // Perform addition
            add = sum; // Return all 5 bits as the result
        end
    endfunction

    task  alu;
        input [3:0] i_a;
        input [3:0] i_b;
        output [4:0] o_result_add; // 5 bits to hold the carry
        output [4:0] o_result_sub;
        
        reg [4:0] result_add_r; // 5 bits to hold the carry
        reg [4:0] result_sub_r; // 5 bits to hold the borrow

        assign o_result_add = result_add_r;
        assign o_result_sub = result_sub_r;
        begin
            add_func(i_a, i_b, result_add_r); // Call the function to perform addition
            result_sub_r <= i_a - i_b; // Perform subtraction
        end
    endtask



    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            a_reg <= 4'b0;
            b_reg <= 4'b0;
        end else begin
            a_reg <= i_a;
            b_reg <= i_b;
            // result_reg <= add(a_reg, b_reg);
        end
    end
    // assign o_result = result_reg; // Assign the registered result to the output
    assign o_result_add = alu(.i_a(a_reg), .i_b(b_reg)).o_result_add; // Directly assign the function result to the output
    assign o_result_sub = alu(.i_a(a_reg), .i_b(b_reg)).o_result_sub; // Directly assign the function result to the output
endmodule
*/ 

// === error recording === // 
// jimmychang@zhangjunmindeMacBook-Air exercise2 % iverilog -o a.out testbench_task.v
// ./task.v:21: error: Task body with multiple statements requires SystemVerilog.
// ./task.v:1: error: Task body with multiple statements requires SystemVerilog.
// ./task.v:51: syntax error
// ./task.v:51: error: Syntax error in continuous assignment
// ./task.v:52: syntax error
// ./task.v:52: error: Syntax error in continuous assignment

// === Explanation === //
// You cannot "Instantiate" a Task like a Module
// Lines 51 and 52 are your biggest errors. You are trying to call a task using port-mapping syntax (alu(.i_a(...))) and assign it to a wire.

// You cannot use assign inside a Task
// A task is a procedural block.

// Multiple Statements" Error
// In Verilog-2001, a task or function body can only contain one statement. 
// If you want more than one (like your assignments and function calls), you must wrap them in a begin ... end block.

// about <= using in task
// In a task, you can use non-blocking assignments (<=) to update registers. 
// However, you cannot use non-blocking assignments to drive outputs directly from a task. 
// Instead, you should assign the outputs to registers within the task and then use those registers to drive the outputs

// task drive_data;
//     input [3:0] data;
//     begin
//         @(negedge clk); // Wait for falling edge
//         a <= data;      // Use non-blocking to safely drive the DUT
//     end
// endtask
module TRY (
    input [3:0] i_a,
    input [3:0] i_b,
    input i_clk,
    input i_rst_n,
    output reg [4:0] o_result_add, // Note: output is now a reg
    output reg [4:0] o_result_sub
);
    reg [3:0] a_reg, b_reg;

    // Function: Must be combinational, returns ONE value
    function [4:0] add_func;
        input [3:0] a;
        input [3:0] b;
        begin
            add_func = a + b;
        end
    endfunction

    // Task: Can have multiple outputs, called procedurally
    task alu_task;
        input [3:0] a_in;
        input [3:0] b_in;
        output [4:0] out_add;
        output [4:0] out_sub;

        // reg [4:0] out_add_r; // Register to hold the addition result
        // reg [4:0] out_sub_r; // Register to hold the subtraction result
        // You cannot use assign inside a Task
        // assign out_add = out_add_r; // Connect output to register
        // assign out_sub = out_sub_r; // Connect output to register
        begin
            out_add = add_func(a_in, b_in); // Calling function inside task
            out_sub = a_in - b_in;
        end
    endtask

    always @(posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin
            a_reg <= 0;
            b_reg <= 0;
            o_result_add <= 0;
            o_result_sub <= 0;
        end else begin
            // Stage 1: Register inputs
            a_reg <= i_a;
            b_reg <= i_b;
            
            // Stage 2: Call task to calculate results for the NEXT cycle
            // Tasks use blocking (=) but since we are assigning to 
            // the output regs, the timing works out for the pipeline.
            alu_task(a_reg, b_reg, o_result_add, o_result_sub);
        end
    end
endmodule