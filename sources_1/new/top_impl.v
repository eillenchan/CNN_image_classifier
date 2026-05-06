`timescale 1ns / 1ps

module top_impl (
    input  wire CLK,
    input  wire nrst,
    output wire done,
    output wire req,
    output wire pixel_valid
);

    wire [7:0] pixel_in;
    wire [4:0] row;
    wire [4:0] col;

    wire signed [4:0] coeff0, coeff1, coeff2;
    wire signed [4:0] coeff3, coeff4, coeff5;

    wire signed [17:0] pixel_out0, pixel_out1, pixel_out2;
    wire signed [17:0] pixel_out3, pixel_out4, pixel_out5;

    wire hold;

    // Internal image memory for implementation
    reg [7:0] mem [0:1023];

    initial begin
        $readmemh("airplane.mem", mem);
    end

    assign pixel_in = mem[(row * 32) + col];

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

endmodule