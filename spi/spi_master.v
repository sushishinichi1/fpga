module spi_master(
    input clk,
    input rst,
    input start,
    input [7:0] data,
    output reg sclk,
    output reg mosi,
    output reg done
);

reg [3:0] bit_cnt;
reg [7:0] shift;
reg busy;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        sclk <= 0;
        mosi <= 0;
        done <= 0;
        busy <= 0;
        bit_cnt <= 0;
    end else begin
        done <= 0;

        if (start && !busy) begin
            busy <= 1;
            shift <= data;
            bit_cnt <= 8;
        end

        if (busy) begin
            sclk <= ~sclk;

            if (sclk == 0) begin
                mosi <= shift[7];
                shift <= shift << 1;
                bit_cnt <= bit_cnt - 1;

                if (bit_cnt == 1) begin
                    busy <= 0;
                    done <= 1;
                end
            end
        end
    end
end
endmodule
