
`include "block.v"

module systolic_array_1d_dct #(
    parameter DATA_WIDTH = 16    // 16 bit data width for the input 
)(
    input clk,  // clock
    input rst,  // reset

    input signed [DATA_WIDTH-1:0] in_north0,
    input signed [DATA_WIDTH-1:0] in_west0,  // basis for PE0
    input signed [DATA_WIDTH-1:0] in_west1,  // basis for PE1
    input signed [DATA_WIDTH-1:0] in_west2,  // basis for PE2
    input signed [DATA_WIDTH-1:0] in_west3,  // basis for PE3

    output signed [(2*DATA_WIDTH)-1:0] result0,  // Y0
    output signed [(2*DATA_WIDTH)-1:0] result1,  // Y1
    output signed [(2*DATA_WIDTH)-1:0] result2,  // Y2
    output signed [(2*DATA_WIDTH)-1:0] result3,  // Y3
    output reg done
);

    // Internal wires to propagate data down
    wire signed [DATA_WIDTH-1:0] out_south0, out_south1, out_south2;

    // PE0: First Processing element
    block #(.DATA_WIDTH(DATA_WIDTH)) PE0 (
        .in_north(in_north0),
        .in_west(in_west0),
        .clk(clk), .rst(rst),
        .out_south(out_south0),
        .result(result0)
    );

    // PE1: Input from PE0
    block #(.DATA_WIDTH(DATA_WIDTH)) PE1 (
        .in_north(out_south0),
        .in_west(in_west1),
        .clk(clk), .rst(rst),
        .out_south(out_south1),
        .result(result1)
    );

    // PE2: Input from PE1
    block #(.DATA_WIDTH(DATA_WIDTH)) PE2 (
        .in_north(out_south1),
        .in_west(in_west2),
        .clk(clk), .rst(rst),
        .out_south(out_south2),
        .result(result2)
    );

    // PE3: Input from PE2
    block #(.DATA_WIDTH(DATA_WIDTH)) PE3 (
        .in_north(out_south2),
        .in_west(in_west3),
        .clk(clk), .rst(rst),
        .out_south(),  // Not used
        .result(result3)
    );

    // done logic after 4 cycles
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
