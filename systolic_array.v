`include "block.v"
module systolic_array_1d_dct (
    input clk,	// clock
    input rst,	// reset value
    input [31:0] in_north0,
    input [31:0] in_west0,  // basis for PE0
    input [31:0] in_west1,  // basis for PE1
    input [31:0] in_west2,  // basis for PE2
    input [31:0] in_west3,  // basis for PE3

    output [63:0] result0,  // Y0
    output [63:0] result1,  // Y1
    output [63:0] result2,  // Y2
    output [63:0] result3,  // Y3
    output reg done
);

    // Internal wires to propagate data down
    wire [31:0] out_south0, out_south1, out_south2;

    // PE0: input from top, first basis coefficient
    block PE0 (
        .in_north(in_north0),
        .in_west(in_west0),
        .clk(clk), .rst(rst),
        .out_south(out_south0),
        .result(result0)
    );

    // PE1: input from PE0, second basis coefficient
    block PE1 (
        .in_north(out_south0),
        .in_west(in_west1),
        .clk(clk), .rst(rst),
        .out_south(out_south1),
        .result(result1)
    );

    // PE2: input from PE1
    block PE2 (
        .in_north(out_south1),
        .in_west(in_west2),
        .clk(clk), .rst(rst),
        .out_south(out_south2),
        .result(result2)
    );

    // PE3: input from PE2
    block PE3 (
        .in_north(out_south2),
        .in_west(in_west3),
        .clk(clk), .rst(rst),
        .out_south(),  // Not used
        .result(result3)
    );

    //done logic after 4 cycles
    reg [2:0] count;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            count <= 0;
            done <= 0;
        end else begin
            if (count == 3'd4) begin
                done <= 1;
                count <= 0;
            end else begin
                count <= count + 1;
                done <= 0;
            end
        end
    end

endmodule
