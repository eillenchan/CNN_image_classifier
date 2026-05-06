`timescale 1ns / 1ps

module controller #(
    parameter H = 32,
    parameter W = 32,
    parameter K = 3
)(
    input  wire CLK,
    input  wire nrst,
    input  wire hold,

    output reg  [4:0] row,
    output reg  [4:0] col,

    output reg signed [4:0] coeff0, // Edge / Outline
    output reg signed [4:0] coeff1, // Sharpen
    output reg signed [4:0] coeff2, // Emboss
    output reg signed [4:0] coeff3, // Left Sobel
    output reg signed [4:0] coeff4, // Top Sobel
    output reg signed [4:0] coeff5, // Gaussian scaled

    output reg req
);

    reg [4:0] out_r;
    reg [4:0] out_c;
    reg [3:0] k_idx;

    always @(*) begin
        // ROW ADDRESS WITH EDGE REPLICATION
        case (k_idx)
            4'd0, 4'd1, 4'd2: begin
                if (out_r == 0)
                    row = 5'd0;
                else
                    row = out_r - 1'b1;
            end

            4'd3, 4'd4, 4'd5: begin
                row = out_r;
            end

            default: begin
                if (out_r == H-1)
                    row = H-1;
                else
                    row = out_r + 1'b1;
            end
        endcase

        // COLUMN ADDRESS WITH EDGE REPLICATION
        case (k_idx)
            4'd0, 4'd3, 4'd6: begin
                if (out_c == 0)
                    col = 5'd0;
                else
                    col = out_c - 1'b1;
            end

            4'd1, 4'd4, 4'd7: begin
                col = out_c;
            end

            default: begin
                if (out_c == W-1)
                    col = W-1;
                else
                    col = out_c + 1'b1;
            end
        endcase

        // coeff0: Edge / Outline
        case (k_idx)
            4'd4: coeff0 = 5'sd8;
            default: coeff0 = -5'sd1;
        endcase

        // coeff1: Sharpen
        case (k_idx)
            4'd1, 4'd3, 4'd5, 4'd7: coeff1 = -5'sd1;
            4'd4: coeff1 = 5'sd5;
            default: coeff1 = 5'sd0;
        endcase

        // coeff2: Emboss
        case (k_idx)
            4'd0: coeff2 = -5'sd2;
            4'd1: coeff2 = -5'sd1;
            4'd2: coeff2 = 5'sd0;
            4'd3: coeff2 = -5'sd1;
            4'd4: coeff2 = 5'sd1;
            4'd5: coeff2 = 5'sd1;
            4'd6: coeff2 = 5'sd0;
            4'd7: coeff2 = 5'sd1;
            4'd8: coeff2 = 5'sd2;
            default: coeff2 = 5'sd0;
        endcase

        // coeff3: Left Sobel
        case (k_idx)
            4'd0, 4'd6: coeff3 = 5'sd1;
            4'd3: coeff3 = 5'sd2;
            4'd2, 4'd8: coeff3 = -5'sd1;
            4'd5: coeff3 = -5'sd2;
            default: coeff3 = 5'sd0;
        endcase

        // coeff4: Top Sobel
        case (k_idx)
            4'd0, 4'd2: coeff4 = 5'sd1;
            4'd1: coeff4 = 5'sd2;
            4'd6, 4'd8: coeff4 = -5'sd1;
            4'd7: coeff4 = -5'sd2;
            default: coeff4 = 5'sd0;
        endcase

        // coeff5: Gaussian Blur, integer-scaled
        // [1 2 1]
        // [2 4 2]
        // [1 2 1]
        // Note: divide by 16 mamaya
        case (k_idx)
            4'd0, 4'd2, 4'd6, 4'd8: coeff5 = 5'sd1;
            4'd1, 4'd3, 4'd5, 4'd7: coeff5 = 5'sd2;
            4'd4: coeff5 = 5'sd4;
            default: coeff5 = 5'sd0;
        endcase
    end

    always @(posedge CLK or negedge nrst) begin
        if (!nrst) begin
            out_r <= 5'd0;
            out_c <= 5'd0;
            k_idx <= 4'd0;
            req   <= 1'b0;
        end

        else if (!hold && !req) begin
            if (k_idx == K*K-1) begin
                k_idx <= 4'd0;

                if ((out_r == H-1) && (out_c == W-1)) begin
                    req <= 1'b1;
                end

                else if (out_c == W-1) begin
                    out_c <= 5'd0;
                    out_r <= out_r + 1'b1;
                end

                else begin
                    out_c <= out_c + 1'b1;
                end
            end

            else begin
                k_idx <= k_idx + 1'b1;
            end
        end
    end

endmodule