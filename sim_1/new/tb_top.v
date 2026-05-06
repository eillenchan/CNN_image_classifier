`timescale 1ns / 1ps

module tb_top;

    reg CLK;
    reg nrst;

    wire [4:0] row;
    wire [4:0] col;
    wire [7:0] pixel_in;

    wire signed [4:0] coeff0, coeff1, coeff2;
    wire signed [4:0] coeff3, coeff4, coeff5;

    wire signed [17:0] pixel_out0, pixel_out1, pixel_out2;
    wire signed [17:0] pixel_out3, pixel_out4, pixel_out5;

    wire pixel_valid;
    wire hold;
    wire done;
    wire req;

    integer f0, f1, f2, f3, f4, f5;
    integer output_count;

    initial begin
        CLK = 1'b0;
        forever #180.85 CLK = ~CLK; // 361.7 ns period
    end

    mem_tb u_mem_tb (
        .row(row),
        .col(col),
        .pixel_out(pixel_in)
    );

    top u_top (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),

        .row(row),
        .col(col),

        .coeff0(coeff0),
        .coeff1(coeff1),
        .coeff2(coeff2),
        .coeff3(coeff3),
        .coeff4(coeff4),
        .coeff5(coeff5),

        .pixel_out0(pixel_out0),
        .pixel_out1(pixel_out1),
        .pixel_out2(pixel_out2),
        .pixel_out3(pixel_out3),
        .pixel_out4(pixel_out4),
        .pixel_out5(pixel_out5),

        .pixel_valid(pixel_valid),
        .hold(hold),
        .done(done),
        .req(req)
    );

    initial begin
        output_count = 0;
        //for text file mamaya sa Python
        f0 = $fopen("output_kernel0_edge.txt", "w");
        f1 = $fopen("output_kernel1_sharpen.txt", "w");
        f2 = $fopen("output_kernel2_emboss.txt", "w");
        f3 = $fopen("output_kernel3_leftsobel.txt", "w");
        f4 = $fopen("output_kernel4_topsobel.txt", "w");
        f5 = $fopen("output_kernel5_gaussian_scaled.txt", "w");

        nrst = 1'b0;
        repeat (5) @(posedge CLK);
        nrst = 1'b1;

        wait(done == 1'b1);

        repeat (5) @(posedge CLK);

        $display("Six-kernel parallel simulation finished.");
        $display("Total output pixels written per kernel = %0d", output_count);
        $display("done = %b, req = %b", done, req);

        $fclose(f0);
        $fclose(f1);
        $fclose(f2);
        $fclose(f3);
        $fclose(f4);
        $fclose(f5);

        $finish;
    end

    always @(posedge CLK) begin
        if (pixel_valid) begin
            output_count = output_count + 1;

            $fwrite(f0, "%0d\n", pixel_out0);
            $fwrite(f1, "%0d\n", pixel_out1);
            $fwrite(f2, "%0d\n", pixel_out2);
            $fwrite(f3, "%0d\n", pixel_out3);
            $fwrite(f4, "%0d\n", pixel_out4);
            $fwrite(f5, "%0d\n", pixel_out5);

            $display("OUT[%0d] edge=%0d sharp=%0d emboss=%0d leftsobel=%0d topsobel=%0d gaussian=%0d",
                     output_count-1,
                     pixel_out0,
                     pixel_out1,
                     pixel_out2,
                     pixel_out3,
                     pixel_out4,
                     pixel_out5);
        end
    end

endmodule