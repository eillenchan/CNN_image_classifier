`timescale 1ns / 1ps

module filter #(
    parameter SCALE_SHIFT = 0   // 0 = no scaling, 4 = divide by 16 (para sa Gaussian)
)(
    input  wire               CLK,
    input  wire               nrst,
    input  wire [7:0]         pixel_in,
    input  wire signed [4:0]  coeff,

    output reg  signed [17:0] pixel_out,
    output reg                pixel_valid,
    output reg                done,
    output reg                hold
);

    reg signed [17:0] acc;
    reg [3:0] mac_count;
    reg [10:0] out_pixel_count;

    wire signed [8:0]  pixel_signed;
    wire signed [13:0] mult_result;

    assign pixel_signed = {1'b0, pixel_in};
    assign mult_result  = pixel_signed * coeff;

    always @(posedge CLK or negedge nrst) begin
        if (!nrst) begin
            acc             <= 18'sd0;
            mac_count       <= 4'd0;
            out_pixel_count <= 11'd0;
            pixel_out       <= 18'sd0;
            pixel_valid     <= 1'b0;
            done            <= 1'b0;
            hold            <= 1'b0;
        end

        else if (!done) begin
            hold        <= 1'b0;
            pixel_valid <= 1'b0;

            // After 9 MAC operations
            if (mac_count == 4'd8) begin
                // Apply scaling ONLY if SCALE_SHIFT != 0
                pixel_out   <= (acc + mult_result) >>> SCALE_SHIFT;
                pixel_valid <= 1'b1;

                acc       <= 18'sd0;
                mac_count <= 4'd0;

                if (out_pixel_count == 11'd1023) begin
                    done <= 1'b1;
                end
                else begin
                    out_pixel_count <= out_pixel_count + 1'b1;
                end
            end

            else begin
                acc       <= acc + mult_result;
                mac_count <= mac_count + 1'b1;
            end
        end

        else begin
            pixel_valid <= 1'b0;
            hold        <= 1'b0;
        end
    end

endmodule