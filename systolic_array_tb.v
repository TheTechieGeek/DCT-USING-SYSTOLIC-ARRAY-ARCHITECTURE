
module systolic_array_1d_dct_tb;

    reg clk;
    reg rst;
    reg [31:0] in_north0;
    reg [31:0] in_north1;
    reg [31:0] in_north2;
    reg [31:0] in_north3;

    reg [31:0] in_west0;
    reg [31:0] in_west1;
    reg [31:0] in_west2;
    reg [31:0] in_west3;

    wire signed [63:0] result0, result1, result2, result3;
    wire signed [63:0] result4, result5, result6, result7;
    wire signed [63:0] result8, result9, result10, result11;
    wire signed [63:0] result12, result13, result14, result15;
  
    reg signed [63:0] raw_result_matrix[0:3][0:3];
  	reg signed [63:0] coeff_transpose[0:3][0:3];
  	reg signed [63:0] final_dct[0:3][0:3];
  // absolute function
    function [31:0] abs;
      input signed [63:0] val;
      begin
        abs = (val < 0) ? -val : val;
      end
    endfunction
  
    integer i, j;
    wire done;

    // Instantiate the DUT
    systolic_array_1d_dct dut (
        .clk(clk),
        .rst(rst),
      // instantiating the north inputs(input matrix)
        .in_north0(in_north0),
        .in_north1(in_north1),
        .in_north2(in_north2),
        .in_north3(in_north3),
      // instantiating the west inputs(coeff)
        .in_west0(in_west0),
        .in_west1(in_west1),
        .in_west2(in_west2),
        .in_west3(in_west3),
      // instantiating the results
        .result0(result0),
      	.result1(result1),
      	.result2(result2),
      	.result3(result3),
        .result4(result4),
      	.result5(result5),
      	.result6(result6),
      	.result7(result7),
        .result8(result8), 
      	.result9(result9),
      	.result10(result10),
      	.result11(result11),
        .result12(result12),
      	.result13(result13),
      	.result14(result14),
      	.result15(result15),
      // instantiating the done logic
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Input stimulus
    initial begin
        $dumpfile("systolic_dct.vcd");
        $dumpvars(0, systolic_array_1d_dct_tb);

        rst = 1;
      
        in_north0 = 0;
        in_north1 = 0;
        in_north2 = 0;
        in_north3 = 0;
      
        in_west0 = 0;
        in_west1 = 0;
        in_west2 = 0;
        in_west3 = 0;

        #10;
        rst = 0;

        @(posedge clk);
        in_north0 = 16'sd2;        // b11 = 1
      	in_north1 = 16'sd0;
      	in_north2 = 16'sd0;
      	in_north3 = 16'sd0;
      
        in_west0  = 16'sd16384;    // a11 = 0.5 = 16384
        in_west1  = 16'sd0;
        in_west2  = 16'sd0;
        in_west3  = 16'sd0;

        // === Cycle 2 ===
        @(posedge clk);
        in_north0 = 16'sd19;				// b21 =  2
        in_north1 = 16'sd5;				// b12 = 5
      	in_north2 = 16'sd0;
      	in_north3 = 16'sd0;


        in_west0  = 16'sd16384;    // a12 = 0.5 = 16384
        in_west1  = 16'sd21404;    // a21 = 0.6532 = 21404
        in_west2  = 16'sd0;
        in_west3  = 16'sd0;

        // === Cycle 3 ===
        @(posedge clk);
        in_north0 = 16'sd13;			// b31 = 9
        in_north1 = 16'sd23;
      	in_north2 = 16'sd12;
      	in_north3 = 16'sd0;


        in_west0  = 16'sd16384;    // a13 = 0.5 = 16384
        in_west1  = 16'sd8867;     // a22 = 0.2706 = 8867
        in_west2  = 16'sd16384;    // a31 = 0.5 = 16384
        in_west3  = 16'sd0;

        // === Cycle 4 ===
        @(posedge clk);
        in_north0 = 16'sd4;        // b41 = 13
      	in_north1 = 16'sd9;
      	in_north2 = 16'sd1;
      	in_north3 = 16'sd18;

        in_west0  = 16'sd16384;     // a14 = 0.5 = 16384
        in_west1  = -16'sd8867;     // a23 = -0.2706 = -8867
        in_west2  = -16'sd16384;    // a32 = -0.5 = -16384
        in_west3  = 16'sd8867;      // a41 = 0.2706 = 8867

        // === Cycle 5 ===
        @(posedge clk);
        in_north0 = 16'sd0;
      	in_north1 = 16'sd6;
      	in_north2 = 16'sd10;
      	in_north3 = 16'sd17;

        in_west0  = 16'sd0;
        in_west1  = -16'sd21404;    // a24 = -0.6532 = -21404
        in_west2  = -16'sd16384;    // a33 = -0.5 = -16384
        in_west3  = -16'sd21404;    // a42 = -0.6532 = -21404

        // === Cycle 6 ===
        @(posedge clk);
        in_north0 = 16'sd0;
      	in_north1 = 16'sd0;
      	in_north2 = 16'sd22;
      	in_north3 = 16'sd16;
      
        in_west0  = 16'sd0;
        in_west1  = 16'sd0;    
        in_west2  = 16'sd16384;     // a34 = 0.5 = 16384
        in_west3  = 16'sd21404;		// a43 = 0.6532 = 21404

        // === Cycle 7 ===
        @(posedge clk);
        in_north0 = 16'sd0;
      	in_north1 = 16'sd0;
      	in_north2 = 16'sd0;
      	in_north3 = 16'sd20;

        in_west0  = 16'sd0;
        in_west1  = 16'sd0;
        in_west2  = 16'sd0;
        in_west3  = -16'sd8867;     // a44 = 0.2706 = 8867

        // Deassert inputs
        @(posedge clk);
        in_north0 = 0;
      	in_north1 = 0;
      	in_north2 = 0;
      	in_north3 = 0;
      
        in_west0  = 0;
      	in_west1 = 0;
      	in_west2 = 0;
      	in_west3 = 0;
    end

    // Display result matrix after computation is done
    initial begin
        wait(done);
        #10;

        raw_result_matrix[0][0] = result0;
      	raw_result_matrix[0][1] = result1;
        raw_result_matrix[0][2] = result2;
      	raw_result_matrix[0][3] = result3;
      
        raw_result_matrix[1][0] = result4;
      	raw_result_matrix[1][1] = result5;
        raw_result_matrix[1][2] = result6;
      	raw_result_matrix[1][3] = result7;
      
        raw_result_matrix[2][0] = result8; 
      	raw_result_matrix[2][1] = result9;
        raw_result_matrix[2][2] = result10;
      	raw_result_matrix[2][3] = result11;
      
        raw_result_matrix[3][0] = result12;
      	raw_result_matrix[3][1] = result13;
        raw_result_matrix[3][2] = result14;
      	raw_result_matrix[3][3] = result15;
      
      // giving values to the coefficient matrix
      coeff_transpose[0][0] = 16'sd16384;	// 0.5 = 16384
      coeff_transpose[0][1] = 16'sd21404;	// 0.6532 = 21404
      coeff_transpose[0][2] = 16'sd16384;	// 0.5 = 16384
      coeff_transpose[0][3] = 16'sd8867;	// 0.2706 = 8867
      
      coeff_transpose[1][0] = 16'sd16384;
      coeff_transpose[1][1] = 16'sd8867;
      coeff_transpose[1][2] = -16'sd16384;
      coeff_transpose[1][3] = -16'sd21404;
      
      coeff_transpose[2][0] = 16'sd16384;
      coeff_transpose[2][1] = -16'sd8867;
      coeff_transpose[2][2] = -16'sd16384;
      coeff_transpose[2][3] = 16'sd21404;
      
      coeff_transpose[3][0] = 16'sd16384;
      coeff_transpose[3][1] = -16'sd21404;
      coeff_transpose[3][2] = 16'sd16384;
      coeff_transpose[3][3] = -16'sd8867;
      
      // 1st row of the final DCT output
      final_dct[0][0] = raw_result_matrix[0][0] * coeff_transpose[0][0] + 
                        raw_result_matrix[0][1] * coeff_transpose[1][0] + 
                        raw_result_matrix[0][2] * coeff_transpose[2][0] + 
                        raw_result_matrix[0][3] * coeff_transpose[3][0];
      
      final_dct[0][1] = raw_result_matrix[0][0] * coeff_transpose[0][1] + 
                        raw_result_matrix[0][1] * coeff_transpose[1][1] +
                        raw_result_matrix[0][2] * coeff_transpose[2][1] + 
                        raw_result_matrix[0][3] * coeff_transpose[3][1];
      
      final_dct[0][2] = raw_result_matrix[0][0] * coeff_transpose[0][2] + 
                        raw_result_matrix[0][1] * coeff_transpose[1][2] + 
                        raw_result_matrix[0][2] * coeff_transpose[2][2] +
                        raw_result_matrix[0][3] * coeff_transpose[3][2];
      
      final_dct[0][3] = raw_result_matrix[0][0] * coeff_transpose[0][3] + 
                        raw_result_matrix[0][1] * coeff_transpose[1][3] + 
                        raw_result_matrix[0][2] * coeff_transpose[2][3] + 
                        raw_result_matrix[0][3] * coeff_transpose[3][3];
      
      
      // 2nd row of the final DCT output
      final_dct[1][0] = raw_result_matrix[1][0] * coeff_transpose[0][0] + 
                        raw_result_matrix[1][1] * coeff_transpose[1][0] + 
                        raw_result_matrix[1][2] * coeff_transpose[2][0] + 
                        raw_result_matrix[1][3] * coeff_transpose[3][0];
      
      final_dct[1][1] = raw_result_matrix[1][0] * coeff_transpose[0][1] +
                        raw_result_matrix[1][1] * coeff_transpose[1][1] + 
                        raw_result_matrix[1][2] * coeff_transpose[2][1] + 
                        raw_result_matrix[1][3] * coeff_transpose[3][1];
      
      final_dct[1][2] = raw_result_matrix[1][0] * coeff_transpose[0][2] +
                        raw_result_matrix[1][1] * coeff_transpose[1][2] +
                        raw_result_matrix[1][2] * coeff_transpose[2][2] + 
                        raw_result_matrix[1][3] * coeff_transpose[3][2];
      
      final_dct[1][3] = raw_result_matrix[1][0] * coeff_transpose[0][3] +
                        raw_result_matrix[1][1] * coeff_transpose[1][3] +
                        raw_result_matrix[1][2] * coeff_transpose[2][3] + 
                        raw_result_matrix[1][3] * coeff_transpose[3][3];

        
      // 3rd row of the final DCT output
      final_dct[2][0] = raw_result_matrix[2][0] * coeff_transpose[0][0] + 
                        raw_result_matrix[2][1] * coeff_transpose[1][0] + 	
                        raw_result_matrix[2][2] * coeff_transpose[2][0] + 	
                        raw_result_matrix[2][3] * coeff_transpose[3][0];
      
      final_dct[2][1] = raw_result_matrix[2][0] * coeff_transpose[0][1] + 
                        raw_result_matrix[2][1] * coeff_transpose[1][1] + 
                        raw_result_matrix[2][2] * coeff_transpose[2][1] + 
                        raw_result_matrix[2][3] * coeff_transpose[3][1];
      
      final_dct[2][2] = raw_result_matrix[2][0] * coeff_transpose[0][2] + 
                        raw_result_matrix[2][1] * coeff_transpose[1][2] + 
                        raw_result_matrix[2][2] * coeff_transpose[2][2] + 
                        raw_result_matrix[2][3] * coeff_transpose[3][2];
      
      final_dct[2][3] = raw_result_matrix[2][0] * coeff_transpose[0][3] + 
                        raw_result_matrix[2][1] * coeff_transpose[1][3] +
                        raw_result_matrix[2][2] * coeff_transpose[2][3] + 
                        raw_result_matrix[2][3] * coeff_transpose[3][3];

        
      // 4th row of the final DCT output
      final_dct[3][0] = raw_result_matrix[3][0] * coeff_transpose[0][0] + 
                        raw_result_matrix[3][1] * coeff_transpose[1][0] + 
                        raw_result_matrix[3][2] * coeff_transpose[2][0] + 
                        raw_result_matrix[3][3] * coeff_transpose[3][0];
      
      final_dct[3][1] = raw_result_matrix[3][0] * coeff_transpose[0][1] + 
                        raw_result_matrix[3][1] * coeff_transpose[1][1] + 
                        raw_result_matrix[3][2] * coeff_transpose[2][1] + 
                        raw_result_matrix[3][3] * coeff_transpose[3][1];

      final_dct[3][2] = raw_result_matrix[3][0] * coeff_transpose[0][2] + 
                        raw_result_matrix[3][1] * coeff_transpose[1][2] + 
                        raw_result_matrix[3][2] * coeff_transpose[2][2] +
                        raw_result_matrix[3][3] * coeff_transpose[3][2];
      
      final_dct[3][3] = raw_result_matrix[3][0] * coeff_transpose[0][3] +
                        raw_result_matrix[3][1] * coeff_transpose[1][3] + 
                        raw_result_matrix[3][2] * coeff_transpose[2][3] +
                        raw_result_matrix[3][3] * coeff_transpose[3][3];
      
    
     /* 
      for (i = 0; i < 4; i++) begin
        for (j = 0; j < 4; j++) begin
          final_dct[i][j] = 0;
          for (integer k = 0; k < 4; k++) begin
          	final_dct[i][j] = final_dct[i][j] + 
                            (raw_result_matrix[i][k] * coeff_transpose[k][j]);
        end
      end
  end*/
      
// ---------------------------------------------------------------------------
		
        $display("\nDCT Result Matrix (C x F) (Q15 -> Fixed-point x.xxx):"); 
        $display("---------------------------------------------------------");
    for (i = 0; i < 4; i++) begin
        for (j = 0; j < 4; j++) begin
            // Handle negative numbers properly
          if (raw_result_matrix[i][j] < 0) begin
            	$write("-%2d.%05d\t",
                       -raw_result_matrix[i][j] / 32768,
                       ((-raw_result_matrix[i][j]) % 32768) * 100000 / 32768);
            end else begin
                $write(" %2d.%05d\t",
                        raw_result_matrix[i][j] / (32768),
                       ( raw_result_matrix[i][j] % 32768) * 100000 / 32768);
            end
        end
        $display("");
    end

// ---------------------------------------------------------------------------
      $display("\n COEFFICIENT TRANSPOSE MATRIX");
		$display("---------------------------------------------------------");
    	for (i = 0; i < 4; i++) begin
        	for (j = 0; j < 4; j++) begin
            // Handle negative numbers properly
              if (coeff_transpose[i][j] < 0) begin
                $write("-%2d.%05d\t",
                       -coeff_transpose[i][j] / (32768),
                       ((-coeff_transpose[i][j]) % (32768)) * 100000 / 32768);
            end else begin
                $write(" %2d.%05d\t",
                        coeff_transpose[i][j] / (32768),
                       ( coeff_transpose[i][j] % (32768)) * 100000 / 32768);
            end
        end
        $display("");
    end
// ---------------------------------------------------------------------------
      
          $display("\n FINAL DCT RESULT");
    $display("---------------------------------------------------------------");
    for (i = 0; i < 4; i++) begin
        for (j = 0; j < 4; j++) begin
            // Handle negative numbers properly
            if (final_dct[i][j] < 0) begin
                $write("-%2d.%05d\t",
                       ((-final_dct[i][j]) / (32768 * 32768)),
                       ((-final_dct[i][j]) % (32768 * 32768)) * 100000 / (32768 * 32768));
            end else begin
                $write(" %2d.%05d\t",
                        final_dct[i][j] / (32768*32768),
                       (final_dct[i][j] % (32768*32768)) * 100000 / (32768 * 32768));
            end
        end
        $display("");
    end
  end
      
endmodule
