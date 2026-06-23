`timescale 1ns / 1ps

module node_impl (
    input  wire CLK,
    input  wire nrst,

    output wire pool_valid,
    output wire done,
    output wire req
);

    wire [4:0] row;
    wire [4:0] col;
    wire [7:0] pixel_in;

    wire [17:0] pool_out0;
    wire [17:0] pool_out1;
    wire [17:0] pool_out2;
    wire [17:0] pool_out3;
    wire [17:0] pool_out4;
    wire [17:0] pool_out5;

    reg [7:0] mem [0:1023];

    initial begin
        $readmemh("airplane.mem", mem);
    end

    assign pixel_in = mem[(row * 32) + col];

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

endmodule