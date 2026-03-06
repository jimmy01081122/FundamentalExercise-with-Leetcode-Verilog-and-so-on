
module TRY (
    input [3:0] i_a,
    input [3:0] i_b,
    input i_clk,
    input i_rst_n,
    output [4:0] o_result
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

    reg [3:0] a_reg, b_reg; // Registers to hold the inputs
    // reg [4:0] result_reg; // Register to hold the result

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
    assign o_result = add(a_reg, b_reg); // Directly assign the function result to the output
endmodule