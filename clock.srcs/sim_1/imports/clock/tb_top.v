`timescale 1ns / 1ps

module tb_top();
    reg clk, reset, ena, mode, load_h, load_m;
    reg [7:0] sw;
    wire [7:0] seg;
    wire [3:0] an;

    top_module uut (clk, reset, ena, mode, sw, load_h, load_m, seg, an);

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
        reset = 1; ena = 0; mode = 0; sw = 0; load_h = 0; load_m = 0;
        #20 reset = 0; ena = 1;
        #100 mode = 1;
        #100 mode = 0;
        #500 $finish;
    end
endmodule