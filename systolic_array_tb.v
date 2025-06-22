/*
`timescale 1ns/1ps

module tb_systolic_array_1d_dct;

    reg clk, rst;
    reg signed [31:0] in_north0;
    reg signed [31:0] in_west0, in_west1, in_west2, in_west3;
    wire signed [63:0] result0, result1, result2, result3;
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
        forever #5 clk = ~clk; // 10 ns clock period
    end

    // Input stimulus
    integer i, row;
    reg signed [31:0] input_vector [0:3];
    reg signed [31:0] dct_basis [0:3][0:3];

    initial begin
        // VCD dump setup for waveform viewing
        $dumpfile("systolic_dct.vcd");
        $dumpvars(0, tb_systolic_array_1d_dct);

        // Initialize signals
        rst = 1;
        in_north0 = 0;
        in_west0 = 0;
        in_west1 = 0;
        in_west2 = 0;
        in_west3 = 0;

        // Example 4-point input vector
        input_vector[0] = 10;
        input_vector[1] = 20;
        input_vector[2] = 30;
        input_vector[3] = 40;

        // DCT basis matrix scaled by 256
        dct_basis[0][0] = 32'sd128; dct_basis[0][1] = 32'sd128;  dct_basis[0][2] = 32'sd128;  dct_basis[0][3] = 32'sd128;
        dct_basis[1][0] = 32'sd168; dct_basis[1][1] = 32'sd70;   dct_basis[1][2] = -32'sd70;  dct_basis[1][3] = -32'sd168;
        dct_basis[2][0] = 32'sd128; dct_basis[2][1] = -32'sd128; dct_basis[2][2] = -32'sd128; dct_basis[2][3] = 32'sd128;
        dct_basis[3][0] = 32'sd70;  dct_basis[3][1] = -32'sd168; dct_basis[3][2] = 32'sd168;  dct_basis[3][3] = -32'sd70;

        // Release reset after some time
        #12;
        rst = 0;

        // Feed input vector to systolic array, and change DCT row per iteration
        for (row = 0; row < 4; row = row + 1) begin

            // Apply DCT basis row using case
            case (row)
                0: begin
                    in_north0 = input_vector[row];
                    in_west0 = dct_basis[0][0];
                    in_west1 = dct_basis[0][1];
                    in_west2 = dct_basis[0][2];
                    in_west3 = dct_basis[0][3];
                end
                1: begin
                  in_north0 = input_vector[row];
                    in_west0 = dct_basis[1][0];
                    in_west1 = dct_basis[1][1];
                    in_west2 = dct_basis[1][2];
                    in_west3 = dct_basis[1][3];
                end
                2: begin
                    in_north0 = input_vector[row];
                    in_west0 = dct_basis[2][0];
                    in_west1 = dct_basis[2][1];
                    in_west2 = dct_basis[2][2];
                    in_west3 = dct_basis[2][3];
                end
                3: begin
                    in_north0 = input_vector[row];
                    in_west0 = dct_basis[3][0];
                    in_west1 = dct_basis[3][1];
                    in_west2 = dct_basis[3][2];
                    in_west3 = dct_basis[3][3];
                end
            endcase
          
            in_north0 = 0;

            // Wait for result to be ready
            wait(done);
            #10;

            // Display the result for current row
            case (row)
                0: $display("Y0 = %0d", result0 / 256);
                1: $display("Y1 = %0d", result1 / 256);
                2: $display("Y2 = %0d", result2 / 256);
                3: $display("Y3 = %0d", result3 / 256);
            endcase
        end

        $finish;
    end

endmodule




module tb_systolic_array_1d_dct;

    reg clk, rst;
    reg signed [31:0] in_north0;
    reg signed [31:0] in_west0, in_west1, in_west2, in_west3;
    wire signed [63:0] result0, result1, result2, result3;
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
    integer row;
    reg signed [31:0] input_vector [0:3];
    reg signed [31:0] dct_basis [0:3][0:3];

    initial begin
        // VCD dump setup
        $dumpfile("systolic_dct.vcd");
        $dumpvars(0, tb_systolic_array_1d_dct);

        // Initialize
        rst = 1;
        in_north0 = 0;
        in_west0 = 0; in_west1 = 0; in_west2 = 0; in_west3 = 0;

        // Input vector
        input_vector[0] = 10;
        input_vector[1] = 20;
        input_vector[2] = 30;
        input_vector[3] = 40;

        // DCT basis (scaled by 256)
        dct_basis[0][0] = 32'sd128; dct_basis[0][1] = 32'sd128;  dct_basis[0][2] = 32'sd128;  dct_basis[0][3] = 32'sd128;
        dct_basis[1][0] = 32'sd168; dct_basis[1][1] = 32'sd70;   dct_basis[1][2] = -32'sd70;  dct_basis[1][3] = -32'sd168;
        dct_basis[2][0] = 32'sd128; dct_basis[2][1] = -32'sd128; dct_basis[2][2] = -32'sd128; dct_basis[2][3] = 32'sd128;
        dct_basis[3][0] = 32'sd70;  dct_basis[3][1] = -32'sd168; dct_basis[3][2] = 32'sd168;  dct_basis[3][3] = -32'sd70;

        // Reset release
        #12;
        rst = 0;

        for (row = 0; row < 4; row = row + 1) begin
            @(posedge clk); // Wait for clock edge

            // Load DCT basis for current row
            case (row)
                0: begin
                    in_west0 = dct_basis[0][0];
                    in_west1 = dct_basis[0][1];
                    in_west2 = dct_basis[0][2];
                    in_west3 = dct_basis[0][3];
                end
                1: begin
                    in_west0 = dct_basis[1][0];
                    in_west1 = dct_basis[1][1];
                    in_west2 = dct_basis[1][2];
                    in_west3 = dct_basis[1][3];
                end
                2: begin
                    in_west0 = dct_basis[2][0];
                    in_west1 = dct_basis[2][1];
                    in_west2 = dct_basis[2][2];
                    in_west3 = dct_basis[2][3];
                end
                3: begin
                    in_west0 = dct_basis[3][0];
                    in_west1 = dct_basis[3][1];
                    in_west2 = dct_basis[3][2];
                    in_west3 = dct_basis[3][3];
                end
            endcase

            // Feed the input vector
            for (integer i = 0; i < 4; i = i + 1) begin
                @(posedge clk);
                in_north0 = input_vector[i];
            end

            // Clear input after feeding
            @(posedge clk);
            in_north0 = 0;

            // Wait for result
            wait(done);
            #10;

            // Display result
            case (row)
                0: $display("Y0 = %0d", result0 / 256);
                1: $display("Y1 = %0d", result1 / 256);
                2: $display("Y2 = %0d", result2 / 256);
                3: $display("Y3 = %0d", result3 / 256);
            endcase
        end

        $finish;
    end

endmodule*/

module tb_systolic_array_1d_dct;

    reg clk, rst;
    reg signed [31:0] in_north0;
    reg signed [31:0] in_west0, in_west1, in_west2, in_west3;
    wire signed [63:0] result0, result1, result2, result3;
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

      // Example Input vector b = [b11 b21 b31 b41] = [2 4 8 16]
        // DCT basis matrix A scaled by 256
        // A = [
        //   128  128  128  128
        //   167   69  -69 -167
        //   128 -128 -128  128
        //    69 -167  167  -69
        // ]
        // Let Aij = A[i][j] (1-based)

        // Initialize
        rst = 32'sd1;
        in_north0 = 32'sd0;
        in_west0 = 32'sd0; in_west1 = 32'sd0; in_west2 = 32'sd0; in_west3 = 32'sd0;

        // Reset pulse
        #12;
        rst = 32'sd0;

        // === Cycle 1 ===
        @(posedge clk);
        in_north0 = 32'sd16;   // b41
        in_west0  = 32'sd512;  // a14
        in_west1  = 32'sd0;
        in_west2  = 32'sd0;
        in_west3  = 32'sd0;

        // === Cycle 2 ===
        @(posedge clk);
        in_north0 = 32'sd8;   // b31
        in_west0  = 32'sd512;  // a13
        in_west1  = -32'sd669; // a24
        in_west2  = 32'sd0;
        in_west3  = 32'sd0;

        // === Cycle 3 ===
        @(posedge clk);
        in_north0 = 32'sd4;   // b21
        in_west0  = 32'sd128;  // a12
        in_west1  = -32'sd69;  // a23
        in_west2  = 32'sd167;  // a34
        in_west3  = 0;

        // === Cycle 4 ===
        @(posedge clk);
        in_north0 = 32'sd2;   // b11
        in_west0  = 32'sd128;  // a11
        in_west1  = 32'sd70;   // a22
        in_west2  = -32'sd128; // a33
        in_west3  = -32'sd69;  // a44

        // === Cycle 5 ===
        @(posedge clk);
        in_north0 = 32'sd0;
        in_west0  = 32'sd0;
        in_west1  = 32'sd167;  // a21
        in_west2  = -32'sd128; // a32
        in_west3  = 32'sd128;  // a43

        // === Cycle 6 ===
        @(posedge clk);
        in_north0 = 32'sd0;
        in_west0  = 32'sd0;
        in_west1  = -32'sd69;  // a23 (again)
        in_west2  = 32'sd168;  // a34 (again)
        in_west3  = 0;

        // === Cycle 7 ===
        @(posedge clk);
        in_north0 = 32'sd0;
        in_west0  = 32'sd0;
        in_west1  = 32'sd0;
        in_west2  = 32'sd0;
        in_west3  = 32'sd69;   // a41

        // Deassert all inputs
        @(posedge clk);
        in_north0 = 32'sd0;
        in_west0 = 32'sd0;
        in_west1 = 32'sd0;
        in_west2 = 32'sd0;
        in_west3 = 32'sd0;

        // Wait for computation to complete
        wait(done);
        #10;

        // Output result (divide by 256 to match DCT scaling)
        $display("DCT Output:");
        $display("Y0 = %b", result0 / 256);
        $display("Y1 = %0b", result1 / 256);
        $display("Y2 = %0b", result2 / 256);
        $display("Y3 = %0b", result3 / 256);

        $finish;
    end

endmodule
