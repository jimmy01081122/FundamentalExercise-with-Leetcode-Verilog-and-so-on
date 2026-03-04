`timescale 1ns/1ps

module add (
    input [3:0]i_a,
    input [3:0]i_b,
    input i_clk,
    input i_rst_n,
    output [4:0]o_c
);
    reg [3:0]i_a_r;
    reg [3:0]i_b_r;
    reg [4:0]o_c_r;
    assign o_c = o_c_r;
    always @ (posedge i_clk or negedge i_rst_n) begin
        if (!i_rst_n) begin 
            i_a_r <= 0;
            i_b_r <= 0;
            o_c_r <= 0;
        end else begin 
            i_a_r <= i_a;
            i_b_r <= i_b;
            $display("here interupt");
            o_c_r <= i_a_r + i_b_r;
        end
    end
endmodule