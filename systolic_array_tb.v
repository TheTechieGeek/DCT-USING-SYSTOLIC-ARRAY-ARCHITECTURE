module tb_systolic_array_1d_dct;

    reg clk, rst;
    reg signed [15:0] in_north0;
    reg signed [15:0] in_west0, in_west1, in_west2, in_west3;
    wire signed [31:0] result0, result1, result2, result3;
    wire done;

    // Instantiate the DUT
    systolic_array_1d_dct uut (
        .clk(clk),
        .rst(rst),
        .in_north0(in_north0),
        .in_west0(in_west0),
        .in_west1(in_west1),
        .in_west2(in_west2),
        .in_west3(in_west3),
        .result0(result0),
        .result1(result1),
        .result2(result2),
        .result3(result3),
        .done(done)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Input stimulus
    initial begin
        // VCD dump setup
        $dumpfile("systolic_dct.vcd");
        $dumpvars(0, tb_systolic_array_1d_dct);

        // Initialize
        rst = 1;
        in_north0 = 16'sd0;
        in_west0 = 16'sd0; in_west1 = 16'sd0; in_west2 = 16'sd0; in_west3 = 16'sd0;

        // Reset pulse
        #12;
        rst = 16'sd0;

        // === Cycle 1 ===
        @(posedge clk);
        in_north0 = 16'sd3;        // b11
        in_west0  = 16'sd10384;    // a11 = 0.5 = 16384
        in_west1  = 16'sd0;
        in_west2  = 16'sd0;
        in_west3  = 16'sd0;

        // === Cycle 2 ===
        @(posedge clk);
        in_north0 = 16'sd17;       // b31 
        in_west0  = 16'sd16384;    // a12 = 0.5 = 16384
        in_west1  = 16'sd21404;    // a21 = 0.6532 = 21404
        in_west2  = 16'sd0;
        in_west3  = 16'sd0;

        // === Cycle 3 ===
        @(posedge clk);
        in_north0 = 16'sd26;       // b21
        in_west0  = 16'sd16384;    // a13 = 0.5 = 16384
        in_west1  = 16'sd8867;     // a22 = 0.2706 = 8867
        in_west2  = 16'sd16384;    // a31 = 0.5 = 16384
        in_west3  = 16'sd0;

        // === Cycle 4 ===
        @(posedge clk);
        in_north0 = 16'sd38;        // b11
        in_west0  = 16'sd16384;     // a14 = 0.5 = 16384
        in_west1  = -16'sd8867;     // a23 = -0.2706 = -8867
        in_west2  = -16'sd16384;    // a32 = -0.5 = -16384
        in_west3  = 16'sd8867;      // a41 = 0.2706 = 8867

        // === Cycle 5 ===
        @(posedge clk);
        in_north0 = 16'sd0;
        in_west0  = 16'sd0;
        in_west1  = -16'sd21404;    // a24 = -0.6532 = -21404
        in_west2  = -16'sd16384;    // a33 = -0.5 = -16384
        in_west3  = -16'sd21404;    // a42 = -0.6532 = -21404

        // === Cycle 6 ===
        @(posedge clk);
        in_north0 = 16'sd0;
        in_west0  = 16'sd0;
        in_west1  = 16'sd0;    
        in_west2  = 16'sd16384;     // a34 = 0.5 = 16384
        in_west3  = 16'sd21404;		// a43 = 0.6532 = 21404

        // === Cycle 7 ===
        @(posedge clk);
        in_north0 = 16'sd0;
        in_west0  = 16'sd0;
        in_west1  = 16'sd0;
        in_west2  = 16'sd0;
        in_west3  = -16'sd8867;     // a44 = 0.2706 = 8867

        // Deassert all inputs
        @(posedge clk);
        in_north0 = 16'sd0;
        in_west0 = 16'sd0;
        in_west1 = 16'sd0;
        in_west2 = 16'sd0;
        in_west3 = 16'sd0;

        // Wait for computation to complete
        wait(done);
        #10;

        // Output result (Q15 scaled to floating point)
        $display("DCT Output (Q15):");
        $display("Y0 = %0d.%03d", result0 / 32768, (abs(result0 % 32768) * 1000) / 32768);
        $display("Y1 = %0d.%03d", result1 / 32768, (abs(result1 % 32768) * 1000) / 32768);
        $display("Y2 = %0d.%03d", result2 / 32768, (abs(result2 % 32768) * 1000) / 32768);
        $display("Y3 = %0d.%03d", result3 / 32768, (abs(result3 % 32768) * 1000) / 32768);

        $finish;
    end

endmodule

