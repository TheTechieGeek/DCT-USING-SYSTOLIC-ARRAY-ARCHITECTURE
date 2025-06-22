module block(
    input  signed [15:0] in_north,
    input  signed [15:0] in_west,
    input  clk, rst,
    output reg signed [15:0] out_south,
    output reg signed [31:0] result
);

    wire signed [31:0] multi;
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

        
