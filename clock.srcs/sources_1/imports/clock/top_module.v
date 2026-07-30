`timescale 1ns / 1ps

module top_module(
    input clk,
    input reset,
    input ena,
    input mode, 
    input [7:0] sw,
    input load_h,
    input load_m,
    output [7:0] seg,
    output reg [3:0] an,
    output err_led
);

    reg [26:0] clkdiv;
    reg tick_1hz;

    always @(posedge clk) begin
        if (reset) begin
            clkdiv <= 0;
            tick_1hz <= 0;
        end else if (clkdiv == 99999999) begin
            clkdiv <= 0;
            tick_1hz <= 1;
        end else begin
            clkdiv <= clkdiv + 1;
            tick_1hz <= 0;
        end
    end

    reg [7:0] h = 8'h12, m = 8'h00, s = 8'h00;

    wire h_err = (sw[7:4] > 2) || (sw[7:4] == 2 && sw[3:0] > 3) || (sw[3:0] > 9);
    wire m_err = (sw[7:4] > 5) || (sw[3:0] > 9);
    assign err_led = (mode == 0) ? h_err : m_err;

    always @(posedge clk) begin
        if (reset) begin
            h <= 8'h12; m <= 8'h00; s <= 8'h00;
        end else if (load_h && !h_err) begin
            h <= sw;
        end else if (load_m && !m_err) begin
            m <= sw;
        end else if (ena && tick_1hz) begin
            if (s == 8'h59) begin
                s <= 8'h00;
                if (m == 8'h59) begin
                    m <= 8'h00;
                    if (h == 8'h23) h <= 8'h00;
                    else if (h[3:0] == 9) h <= {h[7:4] + 1'b1, 4'h0};
                    else h <= h + 1'b1;
                end else begin
                    if (m[3:0] == 9) m <= {m[7:4] + 1'b1, 4'h0};
                    else m <= m + 1'b1;
                end
            end else begin
                if (s[3:0] == 9) s <= {s[7:4] + 1'b1, 4'h0};
                else s <= s + 1'b1;
            end
        end
    end

    reg [18:0] refresh;
    always @(posedge clk) refresh <= refresh + 1;

    reg [3:0] d;
    always @(*) begin
        if (mode == 0) begin
            case(refresh[18:17])
                2'b00: begin an = 4'b1110; d = m[3:0]; end
                2'b01: begin an = 4'b1101; d = m[7:4]; end
                2'b10: begin an = 4'b1011; d = h[3:0]; end
                2'b11: begin an = 4'b0111; d = h[7:4]; end
            endcase
        end else begin
            case(refresh[18:17])
                2'b00: begin an = 4'b1110; d = s[3:0]; end
                2'b01: begin an = 4'b1101; d = s[7:4]; end
                2'b10: begin an = 4'b1011; d = m[3:0]; end
                2'b11: begin an = 4'b0111; d = m[7:4]; end
            endcase
        end
    end

    reg [7:0] s_out;
    always @(*) begin
        case(d)
            4'h0: s_out = 8'b11000000;
            4'h1: s_out = 8'b11111001;
            4'h2: s_out = 8'b10100100;
            4'h3: s_out = 8'b10110000;
            4'h4: s_out = 8'b10011001;
            4'h5: s_out = 8'b10010010;
            4'h6: s_out = 8'b10000010;
            4'h7: s_out = 8'b11111000;
            4'h8: s_out = 8'b10000000;
            4'h9: s_out = 8'b10010000;
            default: s_out = 8'b11111111;
        endcase
    end
    assign seg = s_out;

endmodule