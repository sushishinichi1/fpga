`default_nettype none
`timescale 1ns/1ps
`include "spi_defs.v"

module spi_master(
    
    input start,
    input logic clk,
    input rst_n,
    input [7:0] data,
    input miso,

    output reg sclk,
    output reg cs_n,
    output reg busy,
    output reg mosi,
    output reg done
);
reg [2:0] bit_cnt;
reg [7:0] shift;
reg start_d;
reg [2:0] clkdiv;
reg last_bit;
reg finish_pending;
reg last_bit_phase;
reg start_wait;
wire sclk_next = ~sclk;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sclk <= 0;
        mosi <= 0;
        done <= 0;
        busy <= 0;
        cs_n <= 1;
        bit_cnt <= 0;
        start_d <= 0;
        shift <= 0;
        clkdiv <= 0;
        last_bit_phase <= 0;
        start_wait <= 0;
        finish_pending <= 0;
    end
    else begin
        done <= 0;

        //====================
        // start edge detect
        //====================
        if (start && !start_d) begin
            busy <= 1;
            cs_n <= 0;
            sclk <= 0;
            clkdiv <= 0;
            shift <= {data[6:0],1'b0};
            bit_cnt <= 7;
            mosi <= shift[7];
            start_wait <= 1;
        end

        //====================
        // transfer
        //====================
        if (busy) begin

            if (start_wait)
                start_wait <= 0;

            if (clkdiv == 3) begin
                clkdiv <= 0;


                if (sclk_next == 0) begin
                    mosi <= shift[7];
                    shift <= shift << 1;

                    if (bit_cnt != 0)
                        bit_cnt <= bit_cnt - 1;
                end

                sclk <= sclk_next;

                if (bit_cnt == 0 && sclk == 1) begin
                    if (last_bit_phase == 0)
                        last_bit_phase <= 1;
                    else begin
                        busy <= 0;
                        cs_n <= 1;
                        done <= 1;
                        last_bit_phase <= 0;
                    end
                end
            end
            else begin
                clkdiv <= clkdiv + 1;
            end
        end

    
    start_d <= start;

    end
end

endmodule
