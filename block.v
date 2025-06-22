module block #(
    parameter DATA_WIDTH = 16
)(
    input  signed [DATA_WIDTH-1:0] in_north,
    input  signed [DATA_WIDTH-1:0] in_west,
    input  clk, rst,
    output reg signed [DATA_WIDTH-1:0] out_south,
    output reg signed [(2*DATA_WIDTH)-1:0] result
);

    // Intermediate multiplication (double width)
    wire signed [(2*DATA_WIDTH)-1:0] multi;
    assign multi = in_north * in_west;

    always @(posedge clk) 
      begin
        if (rst) 
          begin
            result     <= 0;
            out_south  <= 0;
          end
  		else 
          begin
            result     <= result + multi;
            out_south  <= in_north;
          end
      end

endmodule
