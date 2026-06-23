`timescale 1ns / 1ps

module relu #(
    parameter IN_W  = 18,
    parameter OUT_W = 18
)(
    input  wire signed [IN_W-1:0]  data_in,
    output wire        [OUT_W-1:0] data_out
);

    assign data_out = data_in[IN_W-1] ? {OUT_W{1'b0}} : data_in[OUT_W-1:0];

endmodule