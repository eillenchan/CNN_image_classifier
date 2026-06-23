`timescale 1ns / 1ps

module maxpool2x2 #(
    parameter H = 32,
    parameter W = 32,
    parameter DATA_W = 18,
    parameter ADDR_W = 5
)(
    input  wire              CLK,
    input  wire              nrst,
    input  wire              in_valid,
    input  wire [DATA_W-1:0] pixel_in,

    output reg  [DATA_W-1:0] pixel_out,
    output reg               out_valid,
    output reg               done
);

    reg [DATA_W-1:0] line_buffer [0:W-1];
    reg [DATA_W-1:0] left_pair_max;

    reg [ADDR_W-1:0] in_row;
    reg [ADDR_W-1:0] in_col;

    integer i;

    reg [DATA_W-1:0] vertical_max;
    reg [DATA_W-1:0] pool_max;

    always @(*) begin
        vertical_max = (line_buffer[in_col] > pixel_in) ? line_buffer[in_col] : pixel_in;
        pool_max     = (left_pair_max > vertical_max) ? left_pair_max : vertical_max;
    end

    always @(posedge CLK or negedge nrst) begin
        if (!nrst) begin
            in_row        <= {ADDR_W{1'b0}};
            in_col        <= {ADDR_W{1'b0}};
            left_pair_max <= {DATA_W{1'b0}};
            pixel_out     <= {DATA_W{1'b0}};
            out_valid     <= 1'b0;
            done          <= 1'b0;

            for (i = 0; i < W; i = i + 1)
                line_buffer[i] <= {DATA_W{1'b0}};
        end else begin
            out_valid <= 1'b0;

            if (in_valid && !done) begin

                if (in_row[0] == 1'b0) begin
                    line_buffer[in_col] <= pixel_in;
                end else begin
                    if (in_col[0] == 1'b0) begin
                        left_pair_max <= vertical_max;
                    end else begin
                        pixel_out <= pool_max;
                        out_valid <= 1'b1;
                    end
                end

                if ((in_row == H-1) && (in_col == W-1)) begin
                    done <= 1'b1;
                end else if (in_col == W-1) begin
                    in_col <= {ADDR_W{1'b0}};
                    in_row <= in_row + 1'b1;
                end else begin
                    in_col <= in_col + 1'b1;
                end
            end
        end
    end

endmodule