`timescale 1ns / 1ps

module tb_node;

    reg CLK;
    reg nrst;

    wire [4:0] row;
    wire [4:0] col;
    wire [7:0] pixel_in;

    wire [17:0] pool_out0;
    wire [17:0] pool_out1;
    wire [17:0] pool_out2;
    wire [17:0] pool_out3;
    wire [17:0] pool_out4;
    wire [17:0] pool_out5;

    wire pool_valid;
    wire done;
    wire req;

    integer f0, f1, f2, f3, f4, f5;
    integer pool_count;

    initial begin
        CLK = 1'b0;
        forever #180.85 CLK = ~CLK;
    end

    mem_tb u_mem_tb (
        .row(row),
        .col(col),
        .pixel_out(pixel_in)
    );

    node u_node (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),

        .row(row),
        .col(col),

        .pool_out0(pool_out0),
        .pool_out1(pool_out1),
        .pool_out2(pool_out2),
        .pool_out3(pool_out3),
        .pool_out4(pool_out4),
        .pool_out5(pool_out5),

        .pool_valid(pool_valid),
        .done(done),
        .req(req)
    );

    initial begin
        pool_count = 0;

        f0 = $fopen("pooled_kernel0_edge.txt", "w");
        f1 = $fopen("pooled_kernel1_sharpen.txt", "w");
        f2 = $fopen("pooled_kernel2_emboss.txt", "w");
        f3 = $fopen("pooled_kernel3_leftsobel.txt", "w");
        f4 = $fopen("pooled_kernel4_topsobel.txt", "w");
        f5 = $fopen("pooled_kernel5_gaussian_scaled.txt", "w");

        nrst = 1'b0;
        repeat (5) @(posedge CLK);
        nrst = 1'b1;

        wait(done == 1'b1);
        repeat (5) @(posedge CLK);

        $display("NODE simulation finished.");
        $display("Total pooled outputs per kernel = %0d", pool_count);
        $display("Expected pooled outputs per kernel = 256");
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
        if (pool_valid) begin
            pool_count = pool_count + 1;

            $fwrite(f0, "%0d\n", pool_out0);
            $fwrite(f1, "%0d\n", pool_out1);
            $fwrite(f2, "%0d\n", pool_out2);
            $fwrite(f3, "%0d\n", pool_out3);
            $fwrite(f4, "%0d\n", pool_out4);
            $fwrite(f5, "%0d\n", pool_out5);

            $display("POOL[%0d] edge=%0d sharpen=%0d emboss=%0d leftsobel=%0d topsobel=%0d gaussian=%0d",
                     pool_count - 1,
                     pool_out0,
                     pool_out1,
                     pool_out2,
                     pool_out3,
                     pool_out4,
                     pool_out5);
        end
    end

endmodule