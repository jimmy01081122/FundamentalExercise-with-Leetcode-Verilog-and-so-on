`timescale 1ns/1ps

`include "add.v"
`default_nettype none

module tb_add;
reg clk;
reg rst_n;
reg [3:0] a;
reg [3:0] b;
wire [4:0] c;
add adder (
    .i_a (a),
    .i_b (b),
    .o_c (c), 
    .i_rst_n (rst_n),
    .i_clk (clk)
);

localparam CLK_PERIOD = 4;
always #(CLK_PERIOD/2) clk=~clk;

initial begin
    $dumpfile("tb_add.vcd");
    $dumpvars(0, tb_add);
end

initial begin
// 1. Initialize everything
    clk = 0;
    rst_n = 0;
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
`default_nettype wire