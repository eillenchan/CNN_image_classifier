`timescale 1ns / 1ps

module node #(
    parameter H = 32,
    parameter W = 32,
    parameter K = 3
)(
    input  wire        CLK,
    input  wire        nrst,
    input  wire [7:0]  pixel_in,

    output wire [4:0]  row,
    output wire [4:0]  col,

    output wire [17:0] pool_out0,
    output wire [17:0] pool_out1,
    output wire [17:0] pool_out2,
    output wire [17:0] pool_out3,
    output wire [17:0] pool_out4,
    output wire [17:0] pool_out5,

    output wire        pool_valid,
    output wire        done,
    output wire        req
);

    wire signed [4:0] coeff0, coeff1, coeff2, coeff3, coeff4, coeff5;

    wire signed [17:0] filt_out0, filt_out1, filt_out2;
    wire signed [17:0] filt_out3, filt_out4, filt_out5;

    wire [17:0] relu_out0, relu_out1, relu_out2;
    wire [17:0] relu_out3, relu_out4, relu_out5;

    wire filt_valid0, filt_valid1, filt_valid2;
    wire filt_valid3, filt_valid4, filt_valid5;

    wire filt_done0, filt_done1, filt_done2;
    wire filt_done3, filt_done4, filt_done5;

    wire hold0, hold1, hold2, hold3, hold4, hold5;
    wire hold;

    wire pool_valid0, pool_valid1, pool_valid2;
    wire pool_valid3, pool_valid4, pool_valid5;

    wire pool_done0, pool_done1, pool_done2;
    wire pool_done3, pool_done4, pool_done5;

    assign hold = hold0 | hold1 | hold2 | hold3 | hold4 | hold5;

    assign pool_valid = pool_valid0;

    assign done = pool_done0 & pool_done1 & pool_done2 &
                  pool_done3 & pool_done4 & pool_done5;

    controller #(
        .H(H),
        .W(W),
        .K(K)
    ) u_controller (
        .CLK(CLK),
        .nrst(nrst),
        .hold(hold),
        .row(row),
        .col(col),
        .coeff0(coeff0),
        .coeff1(coeff1),
        .coeff2(coeff2),
        .coeff3(coeff3),
        .coeff4(coeff4),
        .coeff5(coeff5),
        .req(req)
    );

    filter #(.SCALE_SHIFT(0)) u_filter0 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff0),
        .pixel_out(filt_out0),
        .pixel_valid(filt_valid0),
        .done(filt_done0),
        .hold(hold0)
    );

    filter #(.SCALE_SHIFT(0)) u_filter1 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff1),
        .pixel_out(filt_out1),
        .pixel_valid(filt_valid1),
        .done(filt_done1),
        .hold(hold1)
    );

    filter #(.SCALE_SHIFT(0)) u_filter2 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff2),
        .pixel_out(filt_out2),
        .pixel_valid(filt_valid2),
        .done(filt_done2),
        .hold(hold2)
    );

    filter #(.SCALE_SHIFT(0)) u_filter3 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff3),
        .pixel_out(filt_out3),
        .pixel_valid(filt_valid3),
        .done(filt_done3),
        .hold(hold3)
    );

    filter #(.SCALE_SHIFT(0)) u_filter4 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff4),
        .pixel_out(filt_out4),
        .pixel_valid(filt_valid4),
        .done(filt_done4),
        .hold(hold4)
    );

    filter #(.SCALE_SHIFT(4)) u_filter5 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff5),
        .pixel_out(filt_out5),
        .pixel_valid(filt_valid5),
        .done(filt_done5),
        .hold(hold5)
    );

    relu u_relu0 (.data_in(filt_out0), .data_out(relu_out0));
    relu u_relu1 (.data_in(filt_out1), .data_out(relu_out1));
    relu u_relu2 (.data_in(filt_out2), .data_out(relu_out2));
    relu u_relu3 (.data_in(filt_out3), .data_out(relu_out3));
    relu u_relu4 (.data_in(filt_out4), .data_out(relu_out4));
    relu u_relu5 (.data_in(filt_out5), .data_out(relu_out5));

    maxpool2x2 u_pool0 (
        .CLK(CLK),
        .nrst(nrst),
        .in_valid(filt_valid0),
        .pixel_in(relu_out0),
        .pixel_out(pool_out0),
        .out_valid(pool_valid0),
        .done(pool_done0)
    );

    maxpool2x2 u_pool1 (
        .CLK(CLK),
        .nrst(nrst),
        .in_valid(filt_valid1),
        .pixel_in(relu_out1),
        .pixel_out(pool_out1),
        .out_valid(pool_valid1),
        .done(pool_done1)
    );

    maxpool2x2 u_pool2 (
        .CLK(CLK),
        .nrst(nrst),
        .in_valid(filt_valid2),
        .pixel_in(relu_out2),
        .pixel_out(pool_out2),
        .out_valid(pool_valid2),
        .done(pool_done2)
    );

    maxpool2x2 u_pool3 (
        .CLK(CLK),
        .nrst(nrst),
        .in_valid(filt_valid3),
        .pixel_in(relu_out3),
        .pixel_out(pool_out3),
        .out_valid(pool_valid3),
        .done(pool_done3)
    );

    maxpool2x2 u_pool4 (
        .CLK(CLK),
        .nrst(nrst),
        .in_valid(filt_valid4),
        .pixel_in(relu_out4),
        .pixel_out(pool_out4),
        .out_valid(pool_valid4),
        .done(pool_done4)
    );

    maxpool2x2 u_pool5 (
        .CLK(CLK),
        .nrst(nrst),
        .in_valid(filt_valid5),
        .pixel_in(relu_out5),
        .pixel_out(pool_out5),
        .out_valid(pool_valid5),
        .done(pool_done5)
    );

endmodule