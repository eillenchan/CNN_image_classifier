`timescale 1ns / 1ps

module top #(
    parameter H = 32,
    parameter W = 32,
    parameter K = 3
)(
    input  wire               CLK,
    input  wire               nrst,
    input  wire [7:0]         pixel_in,

    output wire [4:0]         row,
    output wire [4:0]         col,

    output wire signed [4:0]  coeff0,
    output wire signed [4:0]  coeff1,
    output wire signed [4:0]  coeff2,
    output wire signed [4:0]  coeff3,
    output wire signed [4:0]  coeff4,
    output wire signed [4:0]  coeff5,

    output wire signed [17:0] pixel_out0,
    output wire signed [17:0] pixel_out1,
    output wire signed [17:0] pixel_out2,
    output wire signed [17:0] pixel_out3,
    output wire signed [17:0] pixel_out4,
    output wire signed [17:0] pixel_out5,

    output wire               pixel_valid,
    output wire               hold,
    output wire               done,
    output wire               req
);

    wire pixel_valid0, pixel_valid1, pixel_valid2;
    wire pixel_valid3, pixel_valid4, pixel_valid5;

    wire done0, done1, done2;
    wire done3, done4, done5;

    wire hold0, hold1, hold2;
    wire hold3, hold4, hold5;

    assign pixel_valid = pixel_valid0;
    assign done = done0 & done1 & done2 & done3 & done4 & done5;
    assign hold = hold0 | hold1 | hold2 | hold3 | hold4 | hold5;

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
        .pixel_out(pixel_out0),
        .pixel_valid(pixel_valid0),
        .done(done0),
        .hold(hold0)
    );

    filter #(.SCALE_SHIFT(0)) u_filter1 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff1),
        .pixel_out(pixel_out1),
        .pixel_valid(pixel_valid1),
        .done(done1),
        .hold(hold1)
    );

    filter #(.SCALE_SHIFT(0)) u_filter2 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff2),
        .pixel_out(pixel_out2),
        .pixel_valid(pixel_valid2),
        .done(done2),
        .hold(hold2)
    );

    filter #(.SCALE_SHIFT(0)) u_filter3 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff3),
        .pixel_out(pixel_out3),
        .pixel_valid(pixel_valid3),
        .done(done3),
        .hold(hold3)
    );

    filter #(.SCALE_SHIFT(0)) u_filter4 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff4),
        .pixel_out(pixel_out4),
        .pixel_valid(pixel_valid4),
        .done(done4),
        .hold(hold4)
    );

    // Gaussian divide result by 16 using >>> 4
    filter #(.SCALE_SHIFT(4)) u_filter5 (
        .CLK(CLK),
        .nrst(nrst),
        .pixel_in(pixel_in),
        .coeff(coeff5),
        .pixel_out(pixel_out5),
        .pixel_valid(pixel_valid5),
        .done(done5),
        .hold(hold5)
    );

endmodule