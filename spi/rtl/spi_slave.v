`timescale 1ns/1ps
module spi_slave (
    input wire sclk,
    input wire cs_n,
    input wire mosi,
    input wire rst_n,
    input wire [7:0] tx_data,
    output reg [7:0] data,
    output reg valid,
    output reg miso
);

reg [7:0] shift_reg;
reg [2:0] bit_cnt;
reg [7:0] tx_shift;
reg cs_sync;

always @(negedge cs_n or negedge rst_n) begin
    if (!rst_n)
        tx_shift <= 0;
    else
        tx_shift <= tx_data;
end

always @(posedge sclk or posedge cs_n or negedge rst_n) begin
    if (cs_n) begin
        shift_reg <= 0;
        bit_cnt <= 0;
        valid <= 0;
    end else
    if (!rst_n) begin
        shift_reg <= 0;
        bit_cnt   <= 0;
        data      <= 0;
        valid     <= 0;
    end
    else begin
        if (cs_n) begin
            shift_reg <= 0;
            bit_cnt   <= 0;
            valid     <= 0;
        end
        else begin
            valid <= 0;
            shift_reg <= {shift_reg[6:0], mosi};

            if (bit_cnt == 3'd7) begin
                data <= {shift_reg[6:0], mosi};
                valid <= 1;
                bit_cnt <= 0;
            end
            else begin
                bit_cnt <= bit_cnt + 1;
            end
        end
    end
end
always @(negedge sclk or posedge cs_n) begin
    if (cs_n)
        miso <= 0;
    else begin
        miso <= tx_shift[7];
        tx_shift <= {tx_shift[6:0],1'b0};
    end
end

endmodule
