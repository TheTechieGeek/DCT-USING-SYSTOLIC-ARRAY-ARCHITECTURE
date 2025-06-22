module block(
    input  signed [31:0] in_north,
    input  signed [31:0] in_west,
    input  clk, rst,
    output reg signed [31:0] out_south,
    output reg signed [63:0] result
);

    wire signed [63:0] multi;
    assign multi = in_north * in_west;

    always @(posedge clk) begin
      if (rst)
        begin
          result <= 0;
          out_south <= 0;
        end
      else
        begin
          result <= result + multi;
          out_south <= in_north;
        end
    end
endmodule