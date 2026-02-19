module spi_master(
    input clk,
    input start,
    input rst_n,
    input [7:0] data,

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
        last_bit <= 0;
    end
    else begin
        start_d <= start;
        done <= 0;

        if (start && !start_d) begin
            busy <= 1;
            cs_n <= 0;
            shift <= data;
            bit_cnt <= 7;
            mosi <= data[7];
        end

        if (busy) begin
    clkdiv <= clkdiv + 1;

    if (clkdiv == 3) begin
        clkdiv <= 0;
        sclk <= ~sclk;

        if (sclk == 1) begin
            mosi <= shift[7];
            shift <= shift << 1;

            if (bit_cnt == 0) begin
            last_bit <= 1;
        end
        else begin
            bit_cnt <= bit_cnt - 1;
        end

        if (last_bit) begin
            busy <= 0;
            cs_n <= 1;
            done <= 1;
            last_bit <= 0;
        end
        end
    end
end

    end
end

endmodule
