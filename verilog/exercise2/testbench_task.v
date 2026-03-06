`timescale 1ns/1ps

`include "task.v"
`default_nettype none // Enforce explicit declaration of all nets and variables

module tb_task;
reg clk;
reg rst_n;
reg [3:0] a;
reg [3:0] b;
wire [4:0] result_add;
wire [4:0] result_sub;

TRY dut (
    .i_a (a),
    .i_b (b),
    .i_clk (clk),
    .i_rst_n (rst_n),
    .o_result_add (result_add),
    .o_result_sub (result_sub)
);


localparam CLK_PERIOD = 4;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_task.vcd");
    $dumpvars();
end

initial begin
// 1. Initialize everything
    clk = 0;
    a = 0;
    b = 0;
        // 2. Release Reset
    repeat(5) @(posedge clk);
    rst_n = 1;

    // 3. Drive Stimulus on Negedge to avoid race conditions
    repeat(10) @(negedge clk) begin
        a = $unsigned($random) ; // Keep it 1-bit for now
        b = $unsigned($random) ;
    end

    #(CLK_PERIOD * 5);
    $finish;
    $finish(2);
end

endmodule
`default_nettype none