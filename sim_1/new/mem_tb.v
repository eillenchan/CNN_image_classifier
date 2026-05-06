`timescale 1ns / 1ps

module mem_tb #(
    parameter H = 32,
    parameter W = 32
)(
    input  wire [4:0] row,
    input  wire [4:0] col,
    output wire [7:0] pixel_out
);

    reg [7:0] mem [0:H*W-1];

    initial begin
        $readmemh("airplane.mem", mem);
    end

    assign pixel_out = mem[(row * W) + col];

endmodule